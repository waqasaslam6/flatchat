import 'package:flatchat/pages/OnBoarding.dart';
import 'package:flutter/material.dart';

void main()
{
  runApp(MaterialApp(
    title: "FlatChat",
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.system,
    home: OnBoarding(),
    theme: ThemeData(
      primaryColor: Color(0xff2C95D7),
      accentColor: Color(0xff7D538E)
    ),
  ));
}