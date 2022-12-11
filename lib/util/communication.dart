import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Communication {

  static final Communication _communication = Communication._internal();
  final LocalStorage storage = new LocalStorage('feratelAppLogin');
  factory Communication() {
    return _communication;
  }
  Communication._internal();
  bool loggedIn = false;

  logIn(dynamic login, Function callable) {
    Future<dynamic> response = this.callServer('login/',login);
    return response.then((r){
      if (r['login']=='OK') {
        this.storage.setItem("login", login);
        this.storage.setItem("checkpoint", r['checkpoint']);
        this.storage.setItem("secToken", r['secToken']);
        this.loggedIn = true;
      } else {
        this.loggedIn = false;
      };
      callable.call(this.amILoggedIn());
      return this.amILoggedIn();
    });
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

  checkCardValidity(String code, Function callback){
    dynamic data = {
      'checkPointId': this.storage.getItem("checkpoint"),
      'identifier':code
    };
    final response = this.callServer("checkcard/",data);
    response.then((r){
      var result = false;
      if (r['card']=='OK') {
        result = true;
      }
      callback.call(result);
    });
  }

  dynamic callServer(String url, dynamic parameters) async {
    try {
      final response = await http.post(
        Uri.parse('/feratelAPI.php/'+url),
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
      //TODO Error communication
    }
    return {'login':'ERROR'};
  }
}