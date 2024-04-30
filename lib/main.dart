import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lazy_dm_helper/constants/themes.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: "././assets/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
