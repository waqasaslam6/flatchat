import 'package:flatchat/models/DropDownSelectItem.dart';
import 'package:flatchat/models/GridViewItem.dart';
import 'package:flatchat/models/ImageArgs.dart';
import 'package:flatchat/pages/ChangeGroupName.dart';
import 'package:flatchat/pages/ChangePassword.dart';
import 'package:flatchat/pages/CreateGroup.dart';
import 'package:flatchat/pages/Login.dart';
import 'package:flatchat/pages/OnBoarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:simple_image_crop/simple_image_crop.dart';


class Dashboard extends StatefulWidget {
  final int page;
  Dashboard(this.page);
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
  String avatar;

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

  List<String> _selectedIcons = [];

  final List<String> _icons = [
    "assets/avatars/profile_1.jpg",
    "assets/avatars/profile_2.jpg",
    "assets/avatars/profile_3.jpg",
    "assets/avatars/profile_4.jpg",
    "assets/avatars/profile_5.jpg",
    "assets/avatars/profile_6.jpg",
    "assets/avatars/profile_7.jpg",
    "assets/avatars/profile_8.jpg",
    "assets/avatars/profile_9.jpg",
    "assets/avatars/profile_10.jpg"

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usersBox = Hive.box<String>("usersBox");
    getUserData();
    dataRequest(email, sessionid);

  // getImage(sessionid);
  }


  int files=0;

  final imgCropKey = GlobalKey<ImgCropState>();
  File file;

  _pickImage(ImageSource imageSource) async {
    File image = await ImagePicker.pickImage(source: imageSource);
    if (image != null) {
      setImage(image);
      Navigator.pushNamed(context, '/view-image', arguments: ImageArgs(image));
    }
  }

  final String image_url = "https://flatchat-app.com/api";
  var error_text;


   getImage(String session) async
  {
    final String getImageURL = "https://flatchat-app.com/api/$session.jpg";
     final http.Response response = await http.get(getImageURL,
       headers: {"Content-Type": "application/json"}
       );

     return Image.network(response.toString());

  }

  Future<Map<String, dynamic>> setImage(File img) async
  {
    String base64Doc = base64Encode(img.readAsBytesSync());
    // String fileName = file.path.split("/").last;
    print(base64Doc);
    // print(fileName.toString());
    Map userDoc = {
      "type":"photo_upload",
      "email":email,
      "sessionid":sessionid,
      "image_in_base64":base64Doc
    };

    var body = json.encode(userDoc);
    response = await http.post(image_url,
         headers: {"Content-Type": "application/json"},
        body: body
    );

    print("${response.body}");

    final Map<String, dynamic> authResponseData = json.decode(response.body);
    success= authResponseData["success"];
    try {
     if (success==true) {
       setState(() {
         showDialog(
           context: context,
           builder: (BuildContext context) {
             return AlertDialog(
               title: Text("Upload Status"),
               content: Text("Successfully Uploaded"),
               actions: [

               ],
             );
           },
         );
       });
      }
     else
       {
         error_text = authResponseData["error_text"];
         setState(() {
           showDialog(
             context: context,
             builder: (BuildContext context) {
               return AlertDialog(
                 title: Text("Upload Status"),
                 content: Text(error_text.toString()),
                 actions: [

                 ],
               );
             },
           );
         });

       }
    }
    catch(e)
    {
      print(e);
    }

  }



  Future<Map<String, dynamic>> setAvatar(int avatar) async
  {
    // print(fileName.toString());
    Map userDoc = {"type":"choose_avatar_request",
      "email":email,
      "sessionid":sessionid,
      "avatar":avatar};

    var body = json.encode(userDoc);
    response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print("${response.body}");

    final Map<String, dynamic> authResponseData = json.decode(response.body);
    success= authResponseData["success"];
    try {
      if (success==true) {
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Avatar Status"),
                content: Text("Successfully Changed"),
                actions: [
                  MaterialButton(
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          Dashboard(5)), (Route<dynamic> route) => false);
                    },
                    child: Text("OK"),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              );
            },
          );
        });
      }
      else
      {
        error_text = authResponseData["error_text"];
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Avatar Status"),
                content: Text(error_text.toString()),
                actions: [

                ],
              );
            },
          );
        });

      }
    }
    catch(e)
    {
      print(e);
    }

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
            avatar = authResponseData["avatar"].toString();
                usersBoxData();
          });

          print("Avatar = "+ avatar);
          print("Data Updated Successfully");

        }
        else{

        }
      }
      catch(e)
      {print("There is an error."+e);}
    }



  void removeSession() async
  {
    usersBox.put("sessionid", null);
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
        removeSession();
      }
      else{

      }
    }
    catch(e)
    {print("There is an error."+e);}
  }



  Future<Map<String, dynamic>> leaveGroup(String email, String sessionid) async {

    Map data = {
      "type":"leave_group",
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
    print("Leave Group Response:  ${response.body}");
    final Map<String, dynamic> authResponseData = json.decode(response.body);
    success= authResponseData["success"];

    AlertDialog ok_alert = AlertDialog(
      title: Text("Success"),
      content: Text("Group Left"),
      actions: [
        MaterialButton(
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                OnBoarding()), (Route<dynamic> route) => false);
          },
          child: Text("OK"),
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
    AlertDialog fail_alert = AlertDialog(
      title: Text("Error"),
      content: Text("Group not left"),
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
        print("Group Left");
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

  String image;



  @override
  Widget build(BuildContext context) {
    Widget gridViewSelection = GridView.count(
      childAspectRatio: 2.0,
      crossAxisCount: 3,
      mainAxisSpacing: 20.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      children: _icons.map((iconData) {
        return GestureDetector(
          onTap: () {
            _selectedIcons.clear();

            setState(() {
              _selectedIcons.add(iconData);
            });
          },
          child: GridViewItem(iconData, _selectedIcons.contains(iconData)),
        );
      }).toList(),
    );


    final ImageArgs args = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: DefaultTabController(
        length: 6,
        initialIndex: widget.page,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
            children: <Widget>[
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
                    GestureDetector(
                      onTap: (){
                        _pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        height: MediaQuery.of(context).size.height*0.25,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 20,left: 15,right: 15),
                        decoration: BoxDecoration(
                          color:  Color(0xffefeff1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if(args==null && image == null)
                              avatar == "0" ?
                              Image.asset("assets/avatars/profile_1.jpg",
                                scale: 2,
                                width: 100,):
                                  avatar == "1"?
                                  Image.asset("assets/avatars/profile_2.jpg",
                                    scale: 2,
                                    width: 100,):
                                      avatar == "2"?
                                  Image.asset("assets/avatars/profile_3.jpg",
                                    scale: 2,
                                    width: 100,):
                                          avatar == "3"?
                                          Image.asset("assets/avatars/profile_4.jpg",
                                            scale: 2,
                                            width: 100,):
                                              avatar == "4"?
                                              Image.asset("assets/avatars/profile_5.jpg",
                                                scale: 2,
                                                width: 100,):
                                                  avatar == "5"?
                                                  Image.asset("assets/avatars/profile_6.jpg",
                                                    scale: 2,
                                                    width: 100,):
                                                      avatar == "6"?
                                                      Image.asset("assets/avatars/profile_7.jpg",
                                                        scale: 2,
                                                        width: 100,):
                                                          avatar == "7"?
                                                          Image.asset("assets/avatars/profile_8.jpg",
                                                            scale: 2,
                                                            width: 100,):
                                                              avatar == "8"?
                                                              Image.asset("assets/avatars/profile_9.jpg",
                                                                scale: 2,
                                                                width: 100,):
                                                                  avatar == "9"?
                                                                  Image.asset("assets/avatars/profile_10.jpg",
                                                                    scale: 2,
                                                                    width: 100,):
    CircleAvatar(
    radius: 50.0,
    backgroundImage: args == null? NetworkImage("https://flatchat-app.com/api/"+sessionid+".jpg"): FileImage(args.image),
    backgroundColor: Colors.transparent,
    )
                            else
                              CircleAvatar(
                                radius: 50.0,
                                backgroundImage: args == null? NetworkImage("https://flatchat-app.com/api/"+sessionid+".jpg"): FileImage(args.image),
                                backgroundColor: Colors.transparent,
                              ),
                          ],
                        ),
                      ),
                    ),
                    username == null?
                        Container(height: 0,width: 0,):
                    Text(username == null? "Loading":username.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),),
                    groupname == null ?
                    Container(height: 0,width: 0,):
                    Text(groupname  == null ? "Loading":groupname.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),),
                    groupinvite == null ?
                    Container(height: 0,width: 0,):
                    Text(groupinvite == null ?"Loading":"Invite Code : "+groupinvite.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),),
                    MaterialButton(
                      onPressed: (){
                       // _pickImage(ImageSource.gallery);

                        setState(() {
                          showDialog(context: context,
                          child: AlertDialog(
                            content: Container(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: ()
                                    {
                                      _pickImage(ImageSource.camera);
                                    },
                                    child: Text("Take a picture",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),),
                                  ),
                                  FlatButton(
                                    onPressed: ()
                                    {
                                      _pickImage(ImageSource.gallery);
                                    },
                                    child: Text("Choose a picture",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),),
                                  ),
                                  FlatButton(
                                    onPressed: (){
                                      setState(() {
                                        showDialog(context: context,
                                        child: AlertDialog(
                                          title: Text("Choose an avatar",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500
                                            ),),
                                          content: Container(
                                          width: MediaQuery.of(context).size.width,
                                              height: 250,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(0);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_1.jpg",
                                                        width: 50,),
                                                      ),
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(1);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_2.jpg",
                                                          width: 50,),
                                                      ),
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(2);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_3.jpg",
                                                          width: 50,),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(3);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_4.jpg",
                                                          width: 50,),
                                                      ),
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(4);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_5.jpg",
                                                          width: 50,),
                                                      ),
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(5);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_6.jpg",
                                                          width: 50,),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(6);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_7.jpg",
                                                          width: 50,),
                                                      ),
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(7);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_8.jpg",
                                                          width: 50,),
                                                      ),
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(8);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_9.jpg",
                                                          width: 50,),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setAvatar(9);
                                                          });
                                                        },
                                                        child: Image.asset("assets/avatars/profile_10.jpg",
                                                          width: 50,),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              )),
                                          // actions: [
                                          //   FlatButton(
                                          //     onPressed: ()=>Navigator.pop(context),
                                          //     child: Text("CANCEL"),
                                          //   ),
                                          //   FlatButton(
                                          //     onPressed: ()=>Navigator.pop(context),
                                          //     child: Text("CONTINUE"),
                                          //   ),
                                          // ],
                                        ),
                                        );

                                      });
                                    },
                                    child: Text("Choose an avatar",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),),
                                  )
                                ],
                              ),
                            ),
                          )
                          );
                        });
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Text("Pick Avatar or Profile",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),),
                      color: Theme.of(context).primaryColor,
                    ),
                    // MaterialButton(
                    //   onPressed: (){
                    //     Navigator.push(context, MaterialPageRoute(
                    //         builder: (context) => CreateGroup()
                    //     ));
                    //   },
                    //   minWidth: MediaQuery.of(context).size.width,
                    //   height: 50,
                    //   child: Text("Create / Join Group",
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.white,
                    //   ),),
                    //   color: Theme.of(context).primaryColor,
                    // ),
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
                      onPressed: (){
                        setState(() {
                          leaveGroup(email, sessionid);
                        });
                      },
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
