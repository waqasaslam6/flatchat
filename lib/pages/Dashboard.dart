import 'package:flatchat/pages/ChangeGroupName.dart';
import 'package:flatchat/pages/ChangePassword.dart';
import 'package:flatchat/pages/CreateGroup.dart';
import 'package:flatchat/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Box<String> usersBox;

  var sessionid;
  var username;
  var email;
  var groupname;
  var groupinvite;

  void usersBoxData() async
  {
    usersBox.put("username", username);
    usersBox.put("groupname", groupname);
    usersBox.put("groupinvite", groupinvite);
  }

  Future<dynamic> getUserData() async
  {
    setState(() {
      sessionid= usersBox.get("sessionid");
      email = usersBox.get("email");
    //  print("Local Group: "+groupname);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usersBox = Hive.box<String>("usersBox");
    getUserData();
    dataRequest(email, sessionid);
  }


  final String url = "https://flatchat-app.com/api";
    var response;
    bool success;
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
            username = authResponseData["username"];
            groupname = authResponseData["groupname"];
            groupinvite = authResponseData["groupinvite"];
                usersBoxData();
          });

          print("Data Updated Successfully");

        }
        else{

        }
      }
      catch(e)
      {print("There is an error."+e);}
    }



  Future<Map<String, dynamic>> logout(String email, String sessionid) async {

    Map data = {
      "type":"logout_request",
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
    print("Logout API Response:  ${response.body}");
    final Map<String, dynamic> authResponseData = json.decode(response.body);
    success= authResponseData["success"];

    try{
      if(success==true)
      {
        print("Logout Successfully");

      }
      else{

      }
    }
    catch(e)
    {print("There is an error."+e);}
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 6,
        initialIndex: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 1,
            toolbarHeight: 50,
            title:  TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(icon: Icon(Icons.group,color: Colors.black,),),
                Tab(icon: Icon(Icons.store_mall_directory,color: Colors.black,)),
                Tab(icon: Icon(Icons.local_play,color: Colors.black,)),
                Tab(icon: Icon(Icons.play_circle_filled,color: Colors.black,)),
                Tab(icon: Icon(Icons.calendar_today,color: Colors.black,)),
                Tab(icon: Icon(Icons.menu,color: Colors.black,)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Tab(icon: Icon(Icons.group,color: Colors.black,),),
              Tab(icon: Icon(Icons.store_mall_directory,color: Colors.black,)),
              Tab(icon: Icon(Icons.local_play,color: Colors.black,)),
              Tab(icon: Icon(Icons.play_circle_filled,color: Colors.black,)),
              Tab(icon: Icon(Icons.calendar_today,color: Colors.black,)),
              Tab(child: Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle
                      ),
                    ),
                    Text(username == null? "Loading":username.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),),
                    Text(groupname  == null ? "Loading":groupname.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),),
                    Text(groupinvite == null ?"Loading":"Invite Code : "+groupinvite.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),),
                    MaterialButton(
                      onPressed: (){},
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Text("Pick Avatar or Profile",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),),
                      color: Theme.of(context).primaryColor,
                    ),
                    MaterialButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CreateGroup()
                        ));
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Text("Create / Join Group",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),),
                      color: Theme.of(context).primaryColor,
                    ),
                    MaterialButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChangeGroupName()
                        ));
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Text("Change Group Name",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),),
                      color: Theme.of(context).primaryColor,
                    ),
                    MaterialButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChangePassword()
                        ));
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Text("Change Password",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),),
                      color: Theme.of(context).primaryColor,
                    ),
                    MaterialButton(
                      onPressed: (){},
                      minWidth: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Text("Leave Flatchat Group",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),),
                      color: Theme.of(context).primaryColor,
                    ),
                    MaterialButton(
                      onPressed: (){
                        setState(() {
                          logout(email, sessionid);
                        });
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Login()
                        ));
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Text("Log out of Flatchat",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
