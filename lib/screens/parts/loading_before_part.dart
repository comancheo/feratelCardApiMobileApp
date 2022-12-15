import 'package:flutter/material.dart';
import '/util/communication.dart';
import '/screens/parts/parts.dart';

class LoadingBeforePart extends StatefulWidget {
  LoadingBeforePart({Key? key, required this.body}) : super(key: key);
  final Widget body;
  @override
  _LoadingBeforePart createState() => _LoadingBeforePart(body:this.body);
}
class _LoadingBeforePart extends State<LoadingBeforePart> {
  _LoadingBeforePart({required this.body});
  bool loading = true;
  final Widget body;
  @override
  Widget build(BuildContext context) {
      return this.showBody();
  }
  Widget loadingBefore(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Akceptace karty: Načítání"),
      ),
      drawer: DrawerPart(context),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loadingCircle()
            ]
        ),
      ),
    );
  }
  showBody(){
    if (this.loading) {
      Communication().handleOnstartLoading((_){
        setState(() {
          this.loading = false;
        });
      });
    }
    if(this.loading){
      return loadingBefore(context);
    } else {
      return this.body;
    }
  }
}