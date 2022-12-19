import 'package:flutter/material.dart';
import '/util/communication.dart';
import '/screens/parts/parts.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key, this.user}) : super(key: key);
  final dynamic user;

  @override
  _UserScreen createState() =>
      _UserScreen(user: this.user);
}
class _UserScreen extends State<UserScreen> {
  _UserScreen({this.user});
  dynamic user;
  GlobalKey<FormState>formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {
    "username":TextEditingController(),
    "password":TextEditingController(),
    "role":TextEditingController(),
    "checkpoint":TextEditingController(),
  };
  final Future<bool> startLoading = Communication().handleOnstartLoading();
  String checkpointValue = "";
  String roleValue = "";
  dynamic checkpoints = Communication().storage.getItem("checkpoints");
  List<DropdownMenuItem<String>> checkpointsItems = [DropdownMenuItem<String>(
                              value: "Akceptační místo",
                              child: Text("Akceptační místo"),
                            )];
  List<DropdownMenuItem<String>> roleItems = [DropdownMenuItem<String>(
                              value: "user",
                              child: Text("Uživatel"),
                            ),DropdownMenuItem<String>(
                              value: "admin",
                              child: Text("Administrátor"),
                            )];
  @override
  void initState() {
    this.checkpointValue = this.user["checkpoint"]??checkpoints[0]["id"];
    this.controllers["username"]!.text=this.user["username"];
    this.controllers["password"]!.text="";
    this.roleValue=this.user["role"];
    this.controllers["checkpoint"]!.text=this.user["checkpoint"];
    for(var checkpoint in checkpoints){
      this.checkpointsItems.add(
        DropdownMenuItem<String>(
          value: checkpoint["id"]!,
          child: Flexible(child:Text(checkpoint["name"]!, style: TextStyle(), overflow: TextOverflow.clip,)),
        ));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(this.checkpointValue);
    return FutureBuilder<bool>(
      future: startLoading,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Akceptace karty: Editace "+user["username"]),
            ),
            drawer: DrawerPart(context),
            body: SingleChildScrollView(
              child: Form(
                  key:this.formKey,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputTextField(
                          controller: this.controllers["username"],
                          label: "Jméno",
                          hint: "Jméno uživatele",
                          obscureText: false,
                          onSubmit: (_) {
                          }
                        ).getWidget(),
                        inputTextField(
                          controller: this.controllers["password"],
                          label: "Heslo",
                          hint: "Heslo uživatele",
                          obscureText: true,
                          onSubmit: (_) {
                          }
                        ).getWidget(),
                        dropDownInput(
                          label: "Role uživatele",
                          items:this.roleItems,
                          value:this.roleValue,
                          onChanged: (_){
                            setState(() {
                              this.roleValue = _;
                            });
                          }
                        ).getWidget(),
                        dropDownInput(
                          label: "Akceptační místo",
                          items:this.checkpointsItems,
                          value:this.checkpointValue,
                          onChanged: (_){
                            setState(() {
                              this.checkpointValue = _;
                            });
                          }
                        ).getWidget(),
                      ],
                  ),
              ),
            ),
          );
        } else {
          return loadingCircle();
        }
      }
    );
  }
}