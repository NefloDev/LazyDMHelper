import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Root widget of the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazy DM Helper',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
    );
  }
}
