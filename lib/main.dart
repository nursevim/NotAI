import 'package:flutter/material.dart';
import 'package:notai/introPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notai',
      debugShowCheckedModeBanner: false, // Debug yazısını kaldırmak için bu satırı ekleyin
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: IntroPage(),
    );
  }
}