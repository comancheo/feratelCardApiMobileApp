<?php
session_start();
class config {
    /*DB Configuration*/
    static private $db_driver = "mysql"; //PDO driver
    static private $db_user = "a104545_belun"; //DB USER
    static private $db_password = "d4XkDkGn"; //DB PASS
    static private $db_name = "d104545_belun"; //DB NAME
    static private $db_server = "wm91.wedos.net"; //DB SERVER

    public static function db_driver(){
        return self::$db_driver;
    }
    public static function db_user(){
        return self::$db_user;
    }
    public static function db_password(){
        return self::$db_password;
    }
    public static function db_name(){
        return self::$db_name;
    }
    public static function db_server(){
        return self::$db_server;
    }
}

class database extends PDO {
    public function __construct(){
        $dns = config::db_driver().":dbname=".config::db_name().";host=".config::db_server();
        parent::__construct($dns, config::db_user(), config::db_password());
        $this->exec("set names utf8");
    }
}
class feratelAPI
{
    const TOKEN_URL = "https://idp.feratel.com/auth/realms/card-api/protocol/openid-connect/token";
    const CLIENT_ID = "fe88b250";
    const CLIENT_SECRET = "8ebc9ea23e2bb3adb3f84eb67047109b";
    const API_TENANT = "kpc01";
    const GRANT_TYPE = "password";
    const API_URL = "https://card-check-api.feratel.com:443/v1/".self::API_TENANT."/secure/checkpoints/";
    const CHECKPOINTS_SERVICES_EXCEPTIONS = ["1d997ac6-61a0-4de6-a435-a4f7fed479a7","49f41c4b-577a-48cb-9887-6c880dbd8d3b","20ad6330-4363-46c1-9d39-3b289aa91e14"];
    const API_USERNAME = "api_comancheo";
    const API_PASSWORD = "Phphtml213";
    const ALLOWED_METHODS = ['handleLogin','handleCheckcard', 'handleCheckpoints', 'handleLogout','handleUsers','handleUpdateuser'];

    private $json = [];

    private $user = [];

    private $db;
    public function __construct(){
            $this->db = new database();
            $this->cors();
            $this->setJsonInput();
            echo $this->getResponse();
    }

    /**
     *  An example CORS-compliant method.  It will allow any GET, POST, or OPTIONS requests from any
     *  origin.
     *
     *  In a production environment, you probably want to be more restrictive, but this gives you
     *  the general idea of what is involved.  For the nitty-gritty low-down, read:
     *
     *  - https://developer.mozilla.org/en/HTTP_access_control
     *  - https://fetch.spec.whatwg.org/#http-cors-protocol
     *
     */
    private function cors() {
        // Allow from any origin
        if (isset($_SERVER['HTTP_ORIGIN'])) {
            // Decide if the origin in $_SERVER['HTTP_ORIGIN'] is one
            // you want to allow, and if so:
            header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
            header('Access-Control-Allow-Credentials: true');
            header('Access-Control-Max-Age: 86400');    // cache for 1 day
        }

        // Access-Control headers are received during OPTIONS requests
        if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {

            if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
                // may also be using PUT, PATCH, HEAD etc
                header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

            if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
                header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

            exit(0);
        }
    }

    private function setJsonInput(){
        $this->json = json_decode(file_get_contents('php://input')??"{}",true)??[];
    }

    public function handleLogin($request){
        if (!$this->getJson('login')) {
            return false;
        }
        $user = $this->authUser($this->getJson('login'));
        if (!$user) {
            return $this->setResponse('OK', [
                'login'=>'ERROR'
            ]);
        }
        return $this->setResponse('OK', [
            'login'=>'OK',
            'checkpoint' => $user['checkpoint'],
            'checkpointName' => $this->getCheckpointById($user['checkpoint'])['name'],
            'checkpointData' => $this->getCheckpointById($user['checkpoint']),
            'role' => $user['role'],
            'sectoken'=>$user['sectoken']
        ]);
    }
    public function handleUsers($request){
        $users = $this->getUsers();
        foreach ($users as &$user){
            unset($user['password']);
            $user['checkpointName'] = $this->getCheckpointById($user['checkpoint'])['name'];
        }
        return $this->setResponse("OK",["users"=>$users]);
    }
    public function handleLogout($request){
        $this->logout();
        return $this->setResponse('OK', [
            'logout'=>'OK'
        ]);
    }
    private function logout(){
        //TODO
    }
    public function handleUpdateuser($request){
        if ($this->user['role'] !== "admin") {
            return $this->setResponse("OK", ["updateUser"=>"ERROR", "message"=>"Nemáte dostatečná práva"]);
        }
        $dataUser = $this->getJson("user");
        unset($dataUser['checkpointName']);
        $dataUser['password'] = trim($dataUser['password']??"");
        if ($dataUser['password']) {
            $dataUser['password'] = password_hash($dataUser['password'], PASSWORD_DEFAULT);
            $dataUser['sectoken'] = password_hash($dataUser['username'].$dataUser['password'], PASSWORD_DEFAULT);
        } else {
            unset($dataUser['password']);
            unset($dataUser['sectoken']);
        }
        if ($dataUser['id']==0) {
            unset($dataUser['id']);
        }
        $query = $this->storeUser($dataUser);
        return $this->setResponse("OK", ["updateUser"=>"OK", "user"=>$dataUser, "message"=>"Přidán nový uživatel ".$dataUser['username']]);
    }
    public function handleCheckcard($request){
        $params = [
            'checkPointId'=>$this->getJson('checkPointId'),
            'check'=>'check',
            'identifier'=>$this->getJson('identifier'),
        ];
        $data = $this->getApiResponse($params, (in_array($this->getJson('checkPointId'),self::CHECKPOINTS_SERVICES_EXCEPTIONS))?"POST":"GET");
        if (!$data['identification']){
            return $this->setResponse('OK', [
                'card'=>'ERROR',
                'data'=>$data,
                'service' => null,
            ]);
        }
        $info = $data['identification'];
        $from = strtotime($info['fromDate']);
        $to = strtotime($info['toDate']);
        $now = time();
        if ($now < $from && $now > $to) {
            return $this->setResponse('OK', [
                'card'=>'ERROR',
                'cardValidTo'=>0,
                'data'=>$data,
                'service' => null,
            ]);
        }

        $services = $data['checkPoint']['serviceTypeAssignments'];
        foreach($services as &$service){
            $service['valid'] = $data['valid'];
        }
        if (!in_array($this->getJson('checkPointId'),self::CHECKPOINTS_SERVICES_EXCEPTIONS)) {
            $checkpoint = $this->getCheckpointById($this->getJson('checkPointId'));
            $services = $checkpoint['serviceTypeAssignments'];
        }
        $response = $this->setResponse('OK', [
            'card'=>'OK',
            'cardValidTo' => $to,
            'service' => $services,
            'data' => $data
        ]);
        if (!in_array($this->getJson('checkPointId'),self::CHECKPOINTS_SERVICES_EXCEPTIONS)) {
            $response = $this->checkCardPerService($response);
        }
        return $response;
    }
    private function checkCardPerService($response){
        $response['data']['valid'] = false;
        foreach ($response['service'] as &$service) {
            $checkCardService = $this->checkCardByService($service["type"]['id']);
            $service['valid'] = $checkCardService['valid'];
            if ($checkCardService['valid']) {
                $response['data']['valid'] = true;
            }
        }
        return $response;
    }

    private function checkCardByService($serviceTypeId){
        $params = [
            'checkPointId'=>$this->getJson('checkPointId'),
            'check'=>'check',
            'identifier'=>$this->getJson('identifier'),
            "serviceTypeId"=>$serviceTypeId
        ];
        return $this->getApiResponse($params, "GET");
    }
    public function handleCheckpoints(){
        if (!$this->getCheckpoints()) {
            return $this->setResponse("OK", ["checkpoints"=>"ERROR"]);
        }
        return $this->setResponse("OK", ["checkpoints"=>$this->getCheckpoints()]);
    }
    private function getCheckpointById($id){
        $checkpoints = $this->getCheckpoints();
        foreach ($checkpoints as $point){
            if ($point['id']==$id) {
                return $this->getCheckpointData($id);
            }
        }
        return false;
    }
    private function getFirstCheckpoint(){
        $checkpoints = $this->getCheckpoints();
        return $checkpoints[0];
    }
    public function getCheckpoints(){
        static $checkpoints;
        if (!$checkpoints) {
            $checkpoints = $this->getApiResponse([]);
        }
        return $checkpoints;
    }
    private function getCheckpointData($id){
        $params = [
            'checkPointId'=>$id,
        ];
        return $this->getApiResponse($params);
    }
    private function getApiResponse($params, $method = "GET"){
        $header = [
            'Accept: application/json',
            'Authorization: Bearer '.$this->getToken()['access_token'],
        ];
        $ch = curl_init($this->getApiUrl($params));
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $response = curl_exec($ch);
        $response = str_replace("","ž",$response); //ž repair
        /*$response = str_replace("Identification not valid","Neplatná Karta
její platnost již vypršela",$response); //ž repair
        $response = str_replace("Permission not granted (INCL/BOOK)","Neplatná Karta
dnes již byla jednou akceptována",$response);*/
        $data = json_decode($response ?? '',true) ?? [];
        $info = curl_getinfo($ch);
        if (in_array($info['http_code'] ?? null, [200, 201, 202,401])) {
            return $data;
        }
        return $data;
    }

    private function getApiUrl($p){
        $url = self::API_URL;
        if (!$p['checkPointId']) {
            return $url;
        }
        $url .= $p['checkPointId']."/";
        if (!$p['check']) {
            return $url;
        }
        $url .= $p['check']."/";
        if ($p['serviceTypeId']) {
        $url .= $p['serviceTypeId']."/";
        }
        if (!$p['identifier']) {
            return $url;
        }
        return $url."?identifier=".$p['identifier'];
    }

    private function getToken($revalidate=false){
        if (!$revalidate && $this->isTokenValid()) {
            return $this->getApiTokenFromDB();
        }
        $header = [
            'Accept: application/json,text/*;q=0.99',
            'Content-Type: application/x-www-form-urlencoded; charset=UTF-8',
        ];
        $postData = [
            'client_id' => self::CLIENT_ID,
            'client_secret' => self::CLIENT_SECRET,
            'grant_type' => self::GRANT_TYPE,
            'username' => self::API_USERNAME,
            'password' => self::API_PASSWORD,
        ];
        $fields_string = http_build_query($postData);
        $ch = curl_init(self::TOKEN_URL);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
        curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $response = curl_exec($ch);
        $data = json_decode($response ?? '',true) ?? [];
        $info = curl_getinfo($ch);
        if (in_array($info['http_code'] ?? null, [200, 201, 202])) {
            if ($data['access_token']) {
                $this->storeApiTokenToDB($data);
            }
            return $data;
        }
        return [];
    }

    private function isTokenValid(){
        $now = time();
        if (is_array($this->getApiTokenFromDB()) && $this->getApiTokenFromDB()['not-before-policy'] > $now) {
            return true;
        }
        return false;
    }

    private function getRequest(){
        $scriptName = basename(__FILE__);
        $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $path = explode('/', $path);
        $return = [];
        foreach($path as $item){
            if (!empty($item) && $item!==$scriptName) {
                $return[] = $item;
            }
        }
        return $return;
    }

    private function getSession($key){
        return $_SESSION[$key]??'';
    }
    private function setSession($key,$data){
        $_SESSION[$key]=$data;
        return $this->getSession($key);
    }
    private function getJson($key){
        return $this->json[$key]??'';
    }
    private function getPost($key){
        return $_POST[$key]??'';
    }
    private function getGet($key){
        return $_GET[$key]??'';
    }

    private function setResponse($status, array $data = []){
        $response = ["status" => $status];
        foreach ($data as $key => $val) {
            $response[$key]=$val;
        }
        return $response;
    }

    private function getResponse(){
        $data = $this->route();
        if (is_bool($data)) {
            $status = $data?"OK":"ERROR";
            $data = ['status'=>$status, 'method'=>$this->getMethodName()];
        }
        return json_encode($data);
    }
    private function getMethodName(){
        return 'handle' . ucfirst($this->getRequest()[0] ?? '');
    }
    private function route()
    {
        $method = $this->getMethodName();
        $response = false;
        if (method_exists($this, $method) && in_array($method, self::ALLOWED_METHODS) && ($this->authSecToken($this->getJson('sectoken'))||$method=="handleLogin")) {
            $response = $this->{$method}($this->getRequest());
        }
        return $response;
    }

    private function getUsers(){
        static $users;
        if (!$users) {
            $us = $this->db->prepare("SELECT * FROM svazek_users");
            $us->execute();
            $users = $us->fetchAll(PDO::FETCH_ASSOC);
        }
        return $users;
    }
    private function storeUser($user) {
        $keys = array_keys($user);
        $update = [];
        foreach($keys as $key){
            if ($key=="id") {
                continue;
            }
            $update[] = $key."=:".$key;
        }
        $query = "INSERT INTO svazek_users (".implode(",",$keys).")
        VALUES (:".implode(",:",$keys).") 
        ON DUPLICATE KEY UPDATE ".implode(",",$update);
        $this->db->prepare($query)->execute($user);
        return $query;
    }

    private function authUser($login){
        $user = $this->db->prepare("SELECT * FROM svazek_users WHERE username=:username LIMIT 1");
        $user->execute(['username'=>$login['username']]);
        $user = $user->fetchAll(PDO::FETCH_ASSOC);
        foreach($user as $u){
            if (password_verify($login['password'], $u['password'])) {
                unset($u['password']);
                $this->user = $u;
                return $u;
            }
        }
        return false;
    }

    private function authSecToken($sectoken){
        $user = $this->db->prepare("SELECT * FROM svazek_users WHERE sectoken=:sectoken LIMIT 1");
        $user->execute(['sectoken'=>$sectoken]);
        $user = $user->fetchAll(PDO::FETCH_ASSOC);
        foreach($user as $u){
            $this->user = $u;
            return $u;
        }
        return false;
    }

    private function storeApiTokenToDB($token){
        $this->db->prepare("DELETE FROM svazek_token")->execute();
        $this->db->prepare("INSERT INTO svazek_token (token) VALUES (:token)")->execute(["token"=>json_encode($token)]);
    }

    private function getApiTokenFromDB(){
        $token = $this->db->prepare("SELECT * FROM svazek_token LIMIT 1");
        $token->execute();
        $token = $token->fetchAll(PDO::FETCH_ASSOC);
        foreach($token as $t){
            return json_decode($t['token'], true);
        }
        return false;
    }

}
$feratelAPI = new feratelAPI();