import 'package:flatchat/pages/Dashboard.dart';
import 'package:flatchat/pages/OnBoarding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



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
    home: OnBoarding(),
    theme: ThemeData(
      primaryColor: Color(0xff2C95D7),
      accentColor: Color(0xff7D538E)
    ),
  ));
}