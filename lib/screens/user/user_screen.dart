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
  bool lock = false;
  String checkpointValue = "";
  String roleValue = "";
  Future<dynamic> futureCheckpoints = Communication().loadCheckpoints();
  List<DropdownMenuItem<String>>? checkpointsItems;
  List<DropdownMenuItem<String>> roleItems = [DropdownMenuItem<String>(
                              value: "user",
                              child: Text("Uživatel"),
                            ),DropdownMenuItem<String>(
                              value: "admin",
                              child: Text("Administrátor"),
                            )];
  @override
  void initState() {
    this.checkpointValue = this.user["checkpoint"]??"";
    this.controllers["username"]!.text=this.user["username"];
    this.controllers["password"]!.text="";
    this.roleValue=this.user["role"];
    this.controllers["checkpoint"]!.text=this.user["checkpoint"];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Communication().handleOnstartLoading(context: context),
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
                          enabled: (this.user["id"]==0 && (!this.lock)),
                          obscureText: false,
                          onSubmit: (_) {
                          }
                        ).getWidget(),
                        inputTextField(
                          controller: this.controllers["password"],
                          label: "Heslo",
                          hint: "Heslo uživatele",
                          obscureText: true,
                          enabled: (!this.lock),
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
                        FutureBuilder<dynamic>(
                            future: futureCheckpoints,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                this.checkpointsItems = [DropdownMenuItem<String>(
                                  value: "Akceptační místo",
                                  child: Text("Akceptační místo"),
                                )];
                                for(var checkpoint in snapshot.data){
                                  this.checkpointsItems!.add(
                                    DropdownMenuItem<String>(
                                      value: checkpoint["id"]!,
                                      child:Text(checkpoint["name"]!, style: TextStyle(), overflow: TextOverflow.clip,),
                                    ));
                                }
                                return dropDownInput(
                                  label: "Akceptační místo",
                                  items:this.checkpointsItems!,
                                  value:this.checkpointValue,
                                  onChanged: (_){
                                    setState(() {
                                      this.checkpointValue = _;
                                    });
                                  }
                                ).getWidget();
                              } else {
                                return loadingCircle();
                              }
                            }
                        ),
                        SizedBox(height: 50),
                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20)),
                          child: MaterialButton(
                            onPressed: () {
                              this.handleSubmitForm();
                            },
                            child: Text(
                              (this.user["id"]==0)?'Přidat uživatele':'Upravit uživatele',
                              style: TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        )
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
  handleSubmitForm(){
    dynamic dataUser = this.user;
    dataUser['username'] = this.controllers["username"]!.text;
    dataUser['password'] = this.controllers["password"]!.text;
    dataUser['role'] = this.roleValue;
    dataUser['checkpoint'] = this.checkpointValue;
    setState(() {
      this.lock=true;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      SnackBar snackBar = SnackBar(
        content: Text("Ukládám"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    Future<dynamic> response = Communication().updateUser(dataUser);
    response.then((data){
      dynamic user = this.user;
      if ((data["user"]??null)!=null) {
          user = data["user"];
      }
      setState(() {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text("Uživatel uložen"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        this.user = user;
        this.lock=false;
      });
    }).onError((error, stackTrace){
      //TODO smthing went wrong
      setState(() {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Chyba při ukládání uživatele"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        this.lock=false;
      });
    });
  }
}