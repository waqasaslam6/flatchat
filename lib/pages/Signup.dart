
import 'package:flatchat/pages/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var myFormat = DateFormat('d-MM-yyyy');

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController fname= new TextEditingController();
  TextEditingController lname = new TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool success;
  var datePicked;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void validate(email,password,fname,lname,birthday) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      doRegister(email, password,fname,lname,birthday);

    } else {
      print('Form is invalid');
    }
  }


  var response;
  String error_text;
  int error;
  final String url = "https://flatchat-app.com/api";

  Future<Map<String, dynamic>> doRegister(String email, String password, String fname, String lname, String birthday) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(email);
      print(password);
      print(fname);
      print(lname);
      print(birthday);
      Map data = {
        "type":"signup_request",
        "email":email,
        "password":password,
        "firstname":fname,
        "lastname":lname,
        "dateofbirth":birthday};
      //encode Map to JSON
      var body = json.encode(data);
      response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      print("${response.body}");

      final Map<String, dynamic> authResponseData = json.decode(response.body);
      success= authResponseData["success"];
      error_text = authResponseData["error_text"];
      error = authResponseData["error"];

        print(success);
      AlertDialog ok_alert = AlertDialog(
        title: Text("Successfully Registered"),
        content: Text("You are registered. Login now!"),
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
        title: Text("Status"),
        content: Text(error_text),
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
          print("Register Success");
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

  DateTime selectedBirthDate = DateTime.now();

  Future<Null> _selectDateofBirth(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedBirthDate,
        firstDate: DateTime(1920, 8),
        lastDate: DateTime(2030));
    if (picked != null && picked != selectedBirthDate)
      setState(() {
        selectedBirthDate = DateTime(picked.year, picked.month, picked.day);
      });
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
            onPressed: ()=>Navigator.pop(context),
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
                        Text("Sign Up",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w700
                        ),),
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: fname,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "First Name",
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: TextFormField(
                                controller: lname,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Last Name",
                                    enabledBorder: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor)
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          onTap: ()
                          {
                            _selectDateofBirth(context);
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "${myFormat.format(selectedBirthDate.toLocal())}",
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor)
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: password,
                          obscureText: _obscureText,
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
                        Container(
                          padding: EdgeInsets.only(left: 15,right: 15),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width-100
                          ),
                          child: Text("By creating an account you agree to our terms of service and privacy policy",
                          textAlign: TextAlign.center,),
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
                                    validate(email.text,password.text,fname.text,lname.text,myFormat.format(selectedBirthDate.toLocal()));
                                  });
                                },
                                child: Text("Create Account",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16
                                  ),),
                              ),
                            ),
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
                      builder: (context) => Login()
                    ));
                  },
                  child: Text("Log in here",
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
    );
  }
}
