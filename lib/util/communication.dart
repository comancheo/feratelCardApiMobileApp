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

  Future<bool> handleOnstartLoading(){
    return this.storage.ready.then((_){
      return this.tryRelogin((_){
        MyApp.of(applicationKey.currentContext!).authService.authenticated = Communication().amILoggedIn();
        MyApp.of(applicationKey.currentContext!).authService.isAdmin = (Communication().storage.getItem("role")=="admin");
        if (Communication().amILoggedIn()) {
          return this.loadCheckpoints();
        }
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
    Future<dynamic> response = this.callServer('logout/',{});
    this.storage.setItem("login",null);
    this.storage.setItem("checkpoint",null);
    this.storage.setItem("checkpointName",null);
    this.storage.setItem("sectoken",null);
    this.storage.setItem("role",null);
    this.loggedIn = false;
    MyApp.of(applicationKey.currentContext!).authService.authenticated = Communication().amILoggedIn();
    MyApp.of(applicationKey.currentContext!).authService.isAdmin = (Communication().storage.getItem("role")=="admin");
    return response.then((r){
      if (r['logout']=="OK") {}
      callable.call(this.amILoggedIn());
      return this.amILoggedIn();
    });
  }

  loadCheckpoints(){
    Future<dynamic> response = this.callServer('checkpoints/',{"sectoken":this.storage.getItem("sectoken")});
    return response.then((r){
      if (r['checkpoints']!="ERROR") {
        this.storage.setItem("checkpoints", r['checkpoints']);
        return this.amILoggedIn();
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
  dynamic callServer(String url, dynamic parameters) async {
    try {
      final response = await http.post(
        Uri.parse('https://svazekapi.tabor-belun.cz/feratelAPI.php/'+url),
        headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
        },
        body: jsonEncode(parameters),
        encoding: Encoding.getByName("utf-8"),
      );
      dynamic data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        return data;
      }
    } catch (e) {
      if (this.applicationKey.currentContext!=null) {
        AlertWindow(
          context: this.applicationKey.currentContext!,
          show:true,
          message: "Chyba komunikace, zkuste to pouzději",
          color:Colors.redAccent,
          title: "Chyba komunikace",
          icon: Icons.warning
        ).getWidget();
      }
      //TODO Error communication
    }
    return {'login':'ERROR'};
  }
}