import '/main.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '/screens/parts/parts.dart';
import 'package:flutter/material.dart';


class Communication {
  static final Communication _communication = Communication._internal();
  final LocalStorage storage = new LocalStorage('feratelAppLogin');
  @override
  final GlobalKey<NavigatorState> applicationKey = new GlobalKey<NavigatorState>();
  factory Communication() {
    return _communication;
  }
  Communication._internal();
  Map<String, String> Checkpoints = {};
  bool loggedIn = false;
  bool isStorageReady = false;
  BuildContext? currentContext;

  Future<bool> handleOnstartLoading({context}){
    this.currentContext = context;
    return this.storage.ready.then((_){
      return this.tryRelogin((_){
        MyApp.of(applicationKey.currentContext!).authService.authenticated = Communication().amILoggedIn();
        MyApp.of(applicationKey.currentContext!).authService.isAdmin = (Communication().storage.getItem("role")=="admin");
        return this.amILoggedIn();
      });
    });
  }

  bool tryRelogin(Function callable){
    if (this.amILoggedIn()) {
      this.logIn(this.storage.getItem("login"),callable);
    } else {
      return callable.call(this.amILoggedIn());
    }
    return true;
  }

  logout (Function callable) {
    Future<dynamic> response = this.callServer('logout/',{"sectoken":Communication().storage.getItem("sectoken")});
    this.storage.setItem("login",null);
    this.storage.setItem("checkpoint",null);
    this.storage.setItem("checkpointName",null);
    this.storage.setItem("sectoken",null);
    this.storage.setItem("role",null);
    this.loggedIn = false;
    MyApp.of(applicationKey.currentContext!).authService.authenticated = false;
    MyApp.of(applicationKey.currentContext!).authService.isAdmin = false;
    return response.then((r){
      try{
        if (r['logout']=="OK") {

        }
      } catch(e){

      }
      callable.call(this.amILoggedIn());
      return this.amILoggedIn();
    });
  }

  Future<dynamic>loadCheckpoints(){
    Future<dynamic> response = this.callServer('checkpoints/',{"sectoken":this.storage.getItem("sectoken")});
    return response.then((r){
      if (r['checkpoints']!="ERROR") {
        this.storage.setItem("checkpoints", r['checkpoints']);
        return r['checkpoints'];
      }
    });
  }

  logIn(dynamic login, Function callable) {
    Future<dynamic> response = this.callServer('login/',login);
    return response.then((r){
      if (r['login']=='OK') {
        this.storage.setItem("login", login);
        this.storage.setItem("checkpoint", r['checkpoint']);
        this.storage.setItem("checkpointName", r['checkpointName']);
        this.storage.setItem("sectoken", r['sectoken']);
        this.storage.setItem("role", r['role']);
        this.loggedIn = true;
        callable.call(this.amILoggedIn());
      } else {
        this.loggedIn = false;
        this.logout(callable);
      };
      return this.amILoggedIn();
    });
  }
  String getCheckpointName(){
    return this.storage.getItem('checkpointName');
  }

  bool amILoggedIn() {
    if (this.loggedIn || (this.storage.getItem("login")!=null && this.storage.getItem("sectoken") != null)) {
      return true;
    } else {
      return false;
    }
  }

  checkCardValidity(String code, Function callback){
    dynamic data = {
      'checkPointId': this.storage.getItem("checkpoint"),
      'sectoken': this.storage.getItem("sectoken"),
      'identifier':code
    };
    final response = this.callServer("checkcard/",data);
    response.then((r){
      callback.call(r);
    }).onError((error, stackTrace){
      dynamic r = {"card":"ERROR", "data":{"valid":false}};
      callback.call(r);
    });
  }
  String getLoginQRData(){
    if (this.amILoggedIn()) {
      String base64Login = base64.encode(utf8.encode(jsonEncode(this.storage.getItem("login"))));
      return (base64Login);
    }
    return "";
  }
  dynamic getLoginFromQRData(String base64Login){
    try{
      return jsonDecode(utf8.decode(base64.decode(base64Login)));
    } catch (e) {
      return false;
    }
  }
  Future<dynamic> getUsers(){
    return callServer("users", {
      'sectoken': this.storage.getItem("sectoken")
    });
  }
  Future<dynamic> updateUser(user){
    var data = {"user":user, "sectoken":this.storage.getItem("sectoken")};
    Future<dynamic> response = this.callServer("updateuser", data);
    return response.then((r){
      return r;
    });
  }
  Future<dynamic> callServer(String url, dynamic parameters) async {
      Future<dynamic> response = http.post(
        Uri.parse('https://svazekapi.tabor-belun.cz/feratelAPI.php/'+url),
        headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
        },
        body: jsonEncode(parameters),
        encoding: Encoding.getByName("utf-8"),
      ).then((response){
        dynamic data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          return data;
        } else {
          throw new Exception("Chyba komunikace!");
        }
      }).onError((error, stackTrace){
        throw new Exception("Chyba komunikace!");
      }).catchError((error){
        print(error);
        SnackBar snackBar = SnackBar(
          content: Text(error.toString()),
        );
        ScaffoldMessenger.of(this.currentContext!).showSnackBar(snackBar);
      });
      return response;
  }
}