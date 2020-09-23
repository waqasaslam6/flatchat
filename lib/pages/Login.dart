import 'package:flatchat/pages/Signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: "Password (8 characters min.)",
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor)
                          ),
                          suffixIcon: Icon(Icons.visibility_off)
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
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context)=>Signup()
                              ));
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
                       Text("Forgotten your password?",
                       style: TextStyle(
                         color: Colors.grey,
                         fontSize: 18,
                         fontWeight: FontWeight.w700
                       ),)
                     ],
                   ),
                  ],
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
                onPressed: (){},
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
    );
  }
}
