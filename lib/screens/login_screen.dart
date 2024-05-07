import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazy_dm_helper/models/models.dart';
import 'package:lazy_dm_helper/screens/screens.dart';
import 'package:lazy_dm_helper/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/core.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<StatefulWidget>{
  late bool _passwordVisible;
  late TextEditingController passwordController;
  late TextEditingController emailController;
  final AuthService service = AuthService();


  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    passwordController = TextEditingController();
    emailController = TextEditingController();
  }

  bool isEmailValid(String email){
    RegExp reg = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return reg.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          UserModel temp = UserModel(id: snapshot.data!.uid, email: snapshot.data!.email!);
          context.read<AuthenticationBloc>().add(UpdateUserEvent(temp));
          return const MenuScreen();
        }
        if (snapshot.hasError) {
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
                title: const Text(Texts.error),
                content: Text(snapshot.error.toString()),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text(Texts.close),
                    onPressed: () { Navigator.of(context).pop(); },
                  ),
                ]
            );
          });
        }
        return SafeArea(
            child: Scaffold(
                body: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LogoAvatar(radius: 150),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical:8.0),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.person, size: 50, color: colors.primary),
                                      filled: true,
                                      fillColor: colors.surface,
                                      labelText: Texts.email
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (email) => email == null || email.isEmpty
                                      ? Texts.emailNotEmpty : !isEmailValid(email) ? Texts.emailFormat : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical:8.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.password, size: 50, color: colors.primary),
                                      filled: true,
                                      fillColor: colors.surface,
                                      labelText: Texts.password,
                                      suffixIcon: IconButton(
                                          icon: Icon(_passwordVisible ?
                                          Icons.visibility_off :
                                          Icons.visibility,
                                              color: colors.primary),
                                          onPressed: (){
                                            setState(() {
                                              _passwordVisible = !_passwordVisible;
                                            });
                                          }
                                      )
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (passwd) => passwd != null && passwd.isEmpty ? Texts.passwordNotEmpty : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MaterialButton(
                                      onPressed: (){
                                        showDialog(context: context, builder: (BuildContext context){
                                          TextEditingController cont = TextEditingController();
                                          return AlertDialog(
                                            title: const Text(Texts.reset),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  controller: cont,
                                                  decoration: const InputDecoration(
                                                    labelText: Texts.email
                                                  ),
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                  validator: (email) => email == null || email.trim().isEmpty 
                                                      ? Texts.emailNotEmpty : !isEmailValid(email) ? Texts.emailFormat : null
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    MaterialButton(
                                                      onPressed: () => Navigator.of(context).pop(),
                                                      child: const Text(Texts.cancel),
                                                    ),
                                                    MaterialButton(
                                                        onPressed: (){
                                                          String email = cont.text.trim();
                                                          if(email.isNotEmpty && isEmailValid(email)){
                                                            service.resetPassword(email: email);
                                                            Navigator.of(context).pop();
                                                            showDialog(context: context, builder: (BuildContext context){
                                                              return AlertDialog(
                                                                  title: const Text("Reset password"),
                                                                  content: Text("An email to reset your password has been sent to: $email"),
                                                                  actions: <Widget>[
                                                                    MaterialButton(
                                                                        child: const Text(Texts.close),
                                                                        onPressed: () { Navigator.of(context).pop(); }
                                                                    ),
                                                                  ]
                                                              );
                                                            });
                                                          }
                                                        },
                                                      child: Text("Continue"),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      child: Text(Texts.forgotPassword,
                                          style: TextStyle(
                                              color: colors.primary,
                                              decoration: TextDecoration.underline
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical:8.0),
                                child: MaterialButton(
                                    onPressed: (){
                                      service.signInEmailPassword(email: emailController.text, password: passwordController.text).then((value){
                                        if(value != null){
                                          context.read<AuthenticationBloc>().add(UpdateUserEvent(value));
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen()));
                                        }else{
                                          String message;
                                          if(emailController.text.isEmpty){
                                            message = Texts.emailNotEmpty;
                                          }else if(passwordController.text.isEmpty){
                                            message = Texts.passwordNotEmpty;
                                          }else{
                                            message = Texts.accountNotExist;
                                          }
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                                title: const Text(Texts.error),
                                                content: Text(message),
                                                actions: <Widget>[
                                                  MaterialButton(
                                                      child: const Text(Texts.close),
                                                      onPressed: () => Navigator.of(context).pop()
                                                  ),
                                                ]
                                            );
                                          });
                                        }
                                      });
                                    },
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    color: colors.primary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(Texts.login,
                                        style: TextStyle(
                                            color: colors.surface
                                        ),
                                      ),
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical:8.0),
                                child: SizedBox(
                                  width: 220,
                                  child: MaterialButton(
                                      onPressed: (){
                                        service.signInGoogle().then((user){
                                          if(user != null){
                                            APIManager.saveData(json: user.toJson(), endpointPlural: Texts.usersEndpoint);
                                            context.read<AuthenticationBloc>().add(UpdateUserEvent(user));
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen()));
                                          }
                                        });
                                      },
                                      elevation: 3.0,
                                      color: colors.surface,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(100))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SvgPicture.asset(
                                                Resources.googleLogoAsset,
                                                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
                                                width: 30),
                                            Text(Texts.googleSignIn,
                                              style: TextStyle(
                                                  color: colors.primary
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical:8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(Texts.dontHaveAccount,
                                          style: TextStyle(
                                              color: colors.primary
                                          )
                                      ),
                                      MaterialButton(
                                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Text(Texts.register,
                                              style: TextStyle(
                                                  color: colors.primary,
                                                  decoration: TextDecoration.underline
                                              ))
                                      )
                                    ]
                                ),
                              )
                            ]
                        )
                      )
                    ]
                )
            )
        );
      },
    );
  }
}