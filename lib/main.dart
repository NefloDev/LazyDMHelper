import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lazy_dm_helper/constants/themes.dart';
import 'package:lazy_dm_helper/core/bloc/authentication_bloc.dart';
import 'package:lazy_dm_helper/screens/login_screen.dart';
import 'package:lazy_dm_helper/screens/menu_screen.dart';
import 'constants/constants.dart';
import 'firebase_options.dart';
import 'models/models.dart';

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
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(),
      child: MaterialApp(
          title: 'Lazy DM Helper',
          debugShowCheckedModeBanner: false,
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                UserModel temp =
                UserModel(id: snapshot.data!.uid, email: snapshot.data!.email!);
                context.read<AuthenticationBloc>().add(UpdateUserEvent(temp));
                return const MenuScreen();
              }
              if (snapshot.hasError) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text(Texts.error),
                          content: Text(snapshot.error.toString()),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text(Texts.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ]);
                    });
              }
              return const LoginScreen();
            },
          )
      ),
    );
  }
}
