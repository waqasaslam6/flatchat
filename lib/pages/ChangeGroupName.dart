import 'package:flatchat/pages/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class ChangeGroupName extends StatefulWidget {
  @override
  _ChangeGroupNameState createState() => _ChangeGroupNameState();
}

class _ChangeGroupNameState extends State<ChangeGroupName> {

  Box<String> usersBox;
  bool success=false;

  var response;

  var sessionid;
  var username;
  var email;
  var groupname;

  Future<dynamic> getUserData() async
  {
    setState(() {
      sessionid= usersBox.get("sessionid");
      username = usersBox.get("username");
      email = usersBox.get("email");
      groupname = usersBox.get("groupname");
      print("Local User Name: "+username);
      print("Local Email: "+email);
      //  print("Local Group: "+groupname);
    });
  }

  TextEditingController new_name = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validate(email,sessionid,new_name) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      changePass(email, sessionid,new_name);

    } else {
      print('Form is invalid');
    }
  }

  final String url = "https://flatchat-app.com/api";


  Future<Map<String, dynamic>> changePass(String email, String sessionid, String new_name) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(email);
      Map data = {
        "type":"change_group_name_request",
        "email":email,
        "sessionid":sessionid,
        "new_name":new_name
      };
      //encode Map to JSON
      var body = json.encode(data);
      response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: body
      );
      print("Change Group Name API Response:  ${response.body}");
      final Map<String, dynamic> authResponseData = json.decode(response.body);
      success= authResponseData["success"];


      AlertDialog ok_alert = AlertDialog(
        title: Text("Success"),
        content: Text("Group Name Changed"),
        actions: [
          MaterialButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("OK"),
            color: Theme.of(context).primaryColor,
          ),
        ],
      );
      AlertDialog fail_alert = AlertDialog(
        title: Text("Error"),
        content: Text("Group Name not changed"),
        actions: [
          MaterialButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("OK"),
            color: Theme.of(context).primaryColor,
          ),
        ],
      );
      try{
        if(success==true)
        {
          print("Group Name Changed Successfully");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ok_alert;
            },
          );
        }
        else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return fail_alert;
            },
          );


        }
      }
      catch(e)
      {print("There is an error."+e);}
    }
  }


  @override
  void initState()
  {
    super.initState();
    usersBox = Hive.box<String>("usersBox");
    getUserData();
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        Dashboard()), (Route<dynamic> route) => false);

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Color(0xffF0F0F0),
              appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        Dashboard()), (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
              body: Container(
                  padding: EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(20),
                              //         height: MediaQuery.of(context).size.height/2,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.grey[300])),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Change Group Name",
                                      style: TextStyle(
                                          color: Color(0xff7D538E),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    SizedBox(height: 10,),
                                    TextFormField(
                                      controller: new_name,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "New Group Name",
                                        enabledBorder: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).primaryColor)
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              )
                                          ),
                                          minWidth: MediaQuery.of(context).size.width*0.6,
                                          color: Theme.of(context).primaryColor,
                                          onPressed: (){
                                            setState(() {
                                              validate(email, sessionid, new_name.text);
                                            });
                                          },
                                          height: 45,
                                          child: Text("Change Group Name",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16
                                            ),),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]))))),
    );
  }
}
