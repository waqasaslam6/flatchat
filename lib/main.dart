import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flatchat/pages/Dashboard.dart';
import 'package:flatchat/pages/Login.dart';
import 'package:flatchat/pages/OnBoarding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>("usersBox");
  runApp(MaterialApp(
    title: "FlatChat",
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.system,
    home: Home(),
    theme: ThemeData(
      primaryColor: Color(0xff2C95D7),
      accentColor: Color(0xff7D538E)
    ),
    routes: {
      "/view-image": (context)=>Dashboard(5),
    },
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseMessaging _fcm = FirebaseMessaging();

  var sessionid;
  var email;

  Box<String> usersBox;

  Future<dynamic> getUserData() async
  {

    String fcmToken = await _fcm.getToken();
    print(fcmToken);

    setState(() {
      sessionid= usersBox.get("sessionid");
      email = usersBox.get("email");
    });

    print(email);
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    usersBox = Hive.box<String>("usersBox");
    getUserData();
    dataRequest(email, sessionid);



  }


  final String url = "https://flatchat-app.com/api";
  var response;
  bool success;
  var groupname;
  Future<Map<String, dynamic>> dataRequest(String email, String sessionid) async {
    Map data = {
      "type":"data_request",
      "email":email,
      "sessionid":sessionid,
    };
    //encode Map to JSON
    var body = json.encode(data);
    response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: body
    );
    print("Data Request API Response:  ${response.body}");
    final Map<String, dynamic> authResponseData = json.decode(response.body);
    success= authResponseData["success"];

    try{
      if(success==true)
      {
        setState(() {
          groupname = authResponseData["groupname"];

        });

        print("Data Updated Successfully");

      }
      else{

      }
    }
    catch(e)
    {print("There is an error."+e);}
  }

  @override
  Widget build(BuildContext context) {
    return sessionid == null && groupname == null ?  OnBoarding(): Dashboard(0);
  }
}
