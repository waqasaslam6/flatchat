import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flatchat/pages/Login.dart';
import 'package:flatchat/pages/Signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {

  final FirebaseMessaging _fcm = FirebaseMessaging();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );

  }
  final pages = [
    SkOnboardingModel(
        title: 'Choose your item',
        description:
        'Easily find your grocery items and you will get delivery in wide range',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/first_screen.png'),
    SkOnboardingModel(
        title: 'Pick Up or Delivery',
        description:
        'We make ordering fast, simple and free-no matter if you order online or cash',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/first_screen.png'),
    SkOnboardingModel(
        title: 'Pay quick and easy',
        description: 'Pay for order using credit or debit card',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/first_screen.png'),
    SkOnboardingModel(
        title: 'Slide 4',
        description: 'description 4',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/first_screen.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            padding: EdgeInsets.only(left: 30,right: 30),
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
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
                        child: Text("Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                            fontSize: 16
                        ),),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlineButton(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Login()
                          ));
                        },
                        child: Text("Log In",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
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
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width/2,
                child: Image.asset("assets/images/logo.png",),
              ),
            ),
            Expanded(
              flex: 8,
              child: SKOnboardingScreen(
                bgColor: Colors.white,
                themeColor: const Color(0xFF2C95D7),
                pages: pages,
                skipClicked: (value) {
                  print("Skip");
                },
                getStartedClicked: (value) {
                  print("Get Started");
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

}




