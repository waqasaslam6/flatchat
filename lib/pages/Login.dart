import 'package:flatchat/pages/Dashboard.dart';
import 'package:flatchat/pages/OnBoarding.dart';
import 'package:flatchat/pages/Signup.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Box<String> usersBox;
  var sessionid;
  var username = "";
  var u_email = "";
  var groupname="";
  bool inAgroup;
  var groupinvite;



  void usersBoxData() async
  {
    usersBox.put("sessionid", sessionid);
    usersBox.put("email", u_email);
    print("Session ID: " +usersBox.get("sessionid"));
    print("User Data Saved Locally");
  }

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool success;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void validate(email,password) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      doLogin(email, password);

    } else {
      print('Form is invalid');
    }
  }


  var response;
  final String url = "https://flatchat-app.com/api";


  Future<Map<String, dynamic>> doLogin(String email, String password) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(email);
      print(password);
      Map data = {
        "type":"login_request",
        "email":email,
        "password":password};
      //encode Map to JSON
      var body = json.encode(data);
      response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
          body: body
      );
     print("Login API Response:  ${response.body}");
      final Map<String, dynamic> authResponseData = json.decode(response.body);
      success= authResponseData["success"];


      AlertDialog ok_alert = AlertDialog(
        title: Text("Login"),
        content: Text("Success!"),
        actions: [
           MaterialButton(
             color: Theme.of(context).primaryColor,
             child: Text("Go to Dashboard"),
             onPressed: (){
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                   Dashboard()), (Route<dynamic> route) => false);
             },
           ),
        ],
      );
      AlertDialog fail_alert = AlertDialog(
        title: Text("Invalid"),
        content: Text("Login Details"),
        actions: [
        ],
      );
      try{
        if(success==true)
        {
          username = authResponseData["username"];
          sessionid = authResponseData["sessionid"];
          u_email = authResponseData["email"];
          groupname = authResponseData["groupname"];
          inAgroup = authResponseData["inagroup"];
          groupinvite = authResponseData["groupinvite"];

          setState(() {
            usersBoxData();
          });
          print("Login Success");
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
 }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  Future<bool> _onBackPressed() async {
    // Your back press code here...

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        OnBoarding()), (Route<dynamic> route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xffF0F0F0),
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    OnBoarding()), (Route<dynamic> route) => false);
              },
              icon: Icon(Icons.close,color: Colors.black,),
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
                    padding: EdgeInsets.all(15),
                    //         height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey[300])
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Log In",
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 26,
                                fontWeight: FontWeight.w700
                            ),),
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Email Address",
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor)
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            obscureText: _obscureText,
                            controller: password,
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: "Password (8 characters min.)",
                                enabledBorder: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor)
                                ),
                                suffixIcon: IconButton(icon: Icon(Icons.visibility_off),
                                  onPressed: ()
                                  {
                                    _toggle();
                                  },)
                            ),
                          ),
                          SizedBox(height: 10,),
                         Row(
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                  height: 40,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: (){
                                   setState(() {
                                     validate(email.text, password.text);
                                   });

                                  },
                                  child: Text("Click to Log In",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             FlatButton(
                               onPressed: ()
                               {
                                 showDialog(context: context,
                                 child: AlertDialog(
                                   title: Text("Password reset"),
                                   content: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: <Widget>[
                                       Text("Please enter your email address"),
                                       SizedBox(height: 3,),
                                       TextFormField(
                                         decoration: InputDecoration(
                                           hintText: "Email"
                                         ),
                                       ),
                                     ],
                                   ),
                                   actions: [
                                     FlatButton(
                                       onPressed: (){
                                         Navigator.pop(context);
                                       },
                                       child: Text("CANCEL",
                                       style: TextStyle(
                                           color: Colors.grey
                                       ),),
                                   ),
                                     FlatButton(
                                       onPressed: (){
                                         Navigator.pop(context);
                                       },
                                       child: Text("CONTINUE"),
                                     ),
                                   ],
                                 ));

                               },
                               child: Text("Forgotten your password?",
                               style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 18,
                                 fontWeight: FontWeight.w700
                               ),),
                             )
                           ],
                         ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: (){},
                    child: Text("Have an account?",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),),
                  ),
                  FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Signup()
                      ));
                    },
                    child: Text("Sign up here",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
