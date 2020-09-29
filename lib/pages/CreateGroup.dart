import 'package:flatchat/pages/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  Box<String> usersBox;
  bool success=false;

  var response;

  var sessionid;
  var username;
  var email;
  var groupname;
  var error_text;

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



  TextEditingController gname = new TextEditingController();
  TextEditingController scountry = new TextEditingController();
  TextEditingController inviteCode = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validate(email,sessionid,groupname,region) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      createGroup(email, sessionid,groupname,region);

    } else {
      print('Form is invalid');
    }
  }


  final String url = "https://flatchat-app.com/api";
   var groupinvite;

  Future<Map<String, dynamic>> createGroup(String email, String sessionid, String groupname, String region) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(email);
      Map data = {
        "type":"group_request",
        "email":email,
        "sessionid":sessionid,
        "group_name":groupname,
        "region":region
      };
      //encode Map to JSON
      var body = json.encode(data);
      response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: body
      );
      print("Create Group API Response:  ${response.body}");
      final Map<String, dynamic> authResponseData = json.decode(response.body);
      success= authResponseData["success"];


      AlertDialog ok_alert = AlertDialog(
        title: Text("Success"),
        content: Column(
          children: [
            Text("Group Created"),
            Text("Invite Code : "+ groupinvite.toString() == null ?"":groupinvite.toString())
          ],
        ),
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
        content: Text(error_text.toString()),
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
          groupinvite  = authResponseData["groupinvite"];
          print("Group Created Successfully");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ok_alert;
            },
          );
        }
        else{
          error_text  = authResponseData["error_text"];
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


  final GlobalKey<FormState> _formKeyJoin = GlobalKey<FormState>();

  void validateJoin(email,sessionid,invitecode) {
    final FormState form = _formKeyJoin.currentState;
    if (form.validate()) {
      print('Form is valid');
      joinGroup(email, sessionid,invitecode);

    } else {
      print('Form is invalid');
    }
  }

  Future<Map<String, dynamic>> joinGroup(String email, String sessionid, String invitecode) async {
    if (_formKeyJoin.currentState.validate()) {
      _formKeyJoin.currentState.save();
      print(email);
      Map data = {
        "type":"invite_request",
        "email":email,
        "sessionid":sessionid,
        "invite_code":invitecode
      };
      //encode Map to JSON
      var body = json.encode(data);
      response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: body
      );
      print("Invite Code API Response:  ${response.body}");
      final Map<String, dynamic> authResponseData = json.decode(response.body);
      success= authResponseData["success"];


      AlertDialog ok_alert = AlertDialog(
        title: Text("Success"),
        content: Text("Group Joined"),
        actions: [
        ],
      );
      AlertDialog fail_alert = AlertDialog(
        title: Text("Error"),
        content: Text("ERROR_INVITE_CODE_NOT_FOUND"),
        actions: [
        ],
      );
      try{
        if(success==true)
        {
          print("Group Joined Successfully");
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





  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                              Text("Create New Group",
                              style: TextStyle(
                                color: Color(0xff7D538E),
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 10,),
                              TextFormField(
                                controller: gname,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Group Name",
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor)
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                controller: scountry,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Select Country",
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
                                        validate(email, sessionid, gname.text, "GB");
                                      });
                                    },
                                    height: 45,
                                    child: Text("Create Group",
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
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.all(20),
                            //         height: MediaQuery.of(context).size.height/2,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.grey[300])),
                            child: Form(
                              key: _formKeyJoin,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Join with an Invite Code",
                                    style: TextStyle(
                                        color: Color(0xff7D538E),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    controller: inviteCode,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Enter Invite Code",
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
                                            validateJoin(email, sessionid, inviteCode.text);
                                          });
                                        },
                                        height: 45,
                                        child: Text("Join Existing Group",
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
                          )
                    ])))));
  }
}
