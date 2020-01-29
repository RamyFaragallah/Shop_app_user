import 'package:flutter/material.dart';
import 'LoginComponents/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'shop app',
      theme: ThemeData(

        primarySwatch: Colors.red,
      ),
      home:LoginPage(),
    );
  }
}


