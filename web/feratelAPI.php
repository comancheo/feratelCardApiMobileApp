<?php
session_start();
class feratelAPI
{
    const TOKEN_URL = "https://idp.feratel.com/auth/realms/card-api/protocol/openid-connect/token";
    const CLIENT_ID = "985c74b7";
    const CLIENT_SECRET = "e569715e5484235b8638a29ebec5a213";
    const API_TENANT = "itest";
    const GRANT_TYPE = "password";
    const API_URL = "https://card-check-api.feratel.com:443/v1/".self::API_TENANT."/secure/checkpoints/";
    const ALLOWED_METHODS = ['handleLogin','handleCheckcard', 'handleCheckpoints', 'handleLogout'];

    private $json = [];
    public function __construct(){
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
        $data = $this->getToken($this->getJson('login'),true);
        if ($data['access_token']) {
            $this->setSession('login', $this->getJson('login'));
            return $this->setResponse('OK', [
                'login'=>'OK',
                'checkpoint' => $this->getFirstCheckpoint()['id'],
                'secToken'=>session_id()
            ]);
        } else {
            return $this->setResponse('OK', [
                'login'=>'ERROR'
            ]);
        }
    }
    public function handleLogout($request){
        $this->logout();
        return $this->setResponse('OK', [
            'logout'=>'OK'
        ]);
    }
    private function logout(){
        $this->setSession("login","");
        $this->setSession("token","");
    }
    public function handleCheckcard($request){
        $params = [
            'checkPointId'=>$this->getJson('checkPointId'),
            'check'=>'check',
            'identifier'=>$this->getJson('identifier'),
        ];
        $data = $this->getApiResponse($params);
        if (!$data['identification']){
            return false;
        }
        $info = $data['identification'];
        $from = strtotime($info['fromDate']);
        $to = strtotime($info['toDate']);
        $now = time();
        if ($now < $from && $now > $to) {
            return $this->setResponse('OK', [
                'card'=>'ERROR',
                'cardValidTo'=>0
            ]);
        }
        return $this->setResponse('OK', [
            'card'=>'OK',
            'cardValidTo' => $to,
            'service' => $data['checkPoint']['serviceTypeAssignments'],
            'data' => $data
        ]);
    }
    public function handleCheckpoints(){
        return $this->getFirstCheckpoint()['id'];
    }
    private function getFirstCheckpoint(){
        $checkpoints = $this->getCheckpoints();
        return $checkpoints[0];
    }
    private function getCheckpoints(){
        return $this->getApiResponse([]);
    }
    private function getApiResponse($params){
        $header = [
            'Accept: application/json',
            'Authorization: Bearer '.$this->getToken($this->getSession('login'))['access_token'],
        ];
        $ch = curl_init($this->getApiUrl($params));
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
        curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $response = curl_exec($ch);
        $data = json_decode($response ?? '',true) ?? [];
        $info = curl_getinfo($ch);
        if (in_array($info['http_code'] ?? null, [200, 201, 202])) {
            return $data;
        }
        return [];
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
        if (!$p['identifier']) {
            return $url;
        }
        return $url."?identifier=".$p['identifier'];
    }

    private function getToken($login, $revalidate=false){
        if (!$revalidate && $this->isTokenValid()) {
            return $this->getSession('token');
        }
        $header = [
            'Accept: application/json,text/*;q=0.99',
            'Content-Type: application/x-www-form-urlencoded; charset=UTF-8',
        ];
        $postData = [
            'client_id' => self::CLIENT_ID,
            'client_secret' => self::CLIENT_SECRET,
            'grant_type' => self::GRANT_TYPE,
            'username' => $login['username']??'',
            'password' => $login['password']??'',
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
                $this->setSession('token', $data);
            }
            return $data;
        }
        return [];
    }
    private function checkLogin(){
        if ($this->getSession('login')==""){
            //TODO force re-login
        }
    }
    private function isTokenValid(){
        $now = time();
        if (is_array($this->getSession('token')) && $this->getSession('token')['not-before-policy'] > $now) {
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
        if (method_exists($this, $method) && in_array($method, self::ALLOWED_METHODS)) {
            $response = $this->{$method}($this->getRequest());
        }
        return $response;
    }
}
$feratelAPI = new feratelAPI();