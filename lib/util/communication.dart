import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Communication {

  static final Communication _communication = Communication._internal();
  factory Communication() {
    return _communication;
  }
  Communication._internal();
  bool loggedIn = false;

  logIn(dynamic login){
    var response = this.callServer('login/',login);
    if (response['login']=='OK') {
      this.loggedIn = true;
    } else {
      this.loggedIn = false;
    };
    return this.amILoggedIn();
  }



  bool amILoggedIn() {
    if (this.loggedIn) {
      return true;
    } else {
      return false;
    }
  }

  bool checkLoginOnline(){
    var response = this.callServer('checklogin/',[]);
    if (response['login']=='OK') {
      return true;
    }
    return false;
  }

  checkCardValidity(String code){
    dynamic data = {'checkPointId':'2db36571-3b83-4c46-9341-326a4ecacb55', 'identifier':code};
    final response =  this.callServer("checkcard/",data);
    if (response['card']=='OK') {
      return true;
    }
    return false;
  }

  dynamic callServer(String url, dynamic parameters) async {
    try {
      print(url);
      print(parameters);
      final response = await http.post(
        Uri.parse('/feratelAPI.php/'+url),
        headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8',
        },
        body: jsonEncode(parameters),
        encoding: Encoding.getByName("utf-8"),
      );
      print(response.body);
      var data = jsonDecode(response.body);
      if (data["status"] == "OK") {
        return data;
      }
    } catch (e) {
      //TODO Error communication
    }
    return [];
  }
}