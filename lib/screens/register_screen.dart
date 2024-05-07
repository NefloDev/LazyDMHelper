import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/core.dart';
import 'package:lazy_dm_helper/screens/login_screen.dart';
import 'package:lazy_dm_helper/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>{
  late bool _passwordVisible;
  late TextEditingController passwordController;
  late TextEditingController password2Controller;
  late TextEditingController emailController;
  final AuthService service = AuthService();
  late bool isConsent;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    isConsent = false;
    passwordController = TextEditingController();
    password2Controller = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(Texts.registerTitle),
            centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LogoAvatar(radius: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    icon: Icon(Icons.person, size: 50, color: colors.primary),
                    filled: true,
                    fillColor: colors.surface,
                    labelText: Texts.email
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => email != null && email.isEmpty ? Texts.emailNotEmpty : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  validator: (passwd) => passwordValidation(passwd)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: password2Controller,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                    icon: const Icon(Icons.password, size: 50, color: Colors.transparent),
                    filled: true,
                    fillColor: colors.surface,
                    labelText: Texts.repeatPassword,
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
                validator: (passwd) => passwordValidation(passwd)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: -20,
                spacing: -6,
                children: [
                  Checkbox(value: isConsent, onChanged: (consent){
                    setState(() {
                      isConsent = consent!;
                    });
                  }),
                  const Text(Texts.consent),
                  MaterialButton(
                      onPressed: (){},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text(
                          Texts.termsAndConditions,
                          style: TextStyle(
                              color: colors.primary,
                              decoration: TextDecoration.underline
                          )
                      )
                  ),
                  const Text(Texts.and),
                  MaterialButton(
                      onPressed: (){},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text(
                        "${Texts.privacyPolicy}.",
                        style: TextStyle(
                            color: colors.primary,
                            decoration: TextDecoration.underline
                        )
                      )
                  )
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MaterialButton(
                  onPressed: isConsent && passwordController.text == password2Controller.text ? (){
                    service.signUpEmailPassword(emailController.text, passwordController.text).then((user){
                      if(user != null){
                        APIManager.saveData(json: user.toJson(), endpointPlural: Texts.usersEndpoint);
                        context.read<AuthenticationBloc>().add(UpdateUserEvent(user));
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (_) => false);
                      }else{
                        String message;
                        if(emailController.text.isEmpty){
                          message = Texts.emailNotEmpty;
                        }else if(passwordController.text.isEmpty){
                          message = Texts.passwordNotEmpty;
                        }else if(password2Controller.text.isEmpty){
                          message = Texts.passwordNotEmpty;
                        }else if(passwordController.text != password2Controller.text){
                          message = Texts.passwordsMatch;
                        } else if(passwordController.text.length < 6){
                          message = Texts.passwordShort;
                        }else{
                          message = Texts.errorOccurred;
                        }
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                              title: const Text(Texts.error),
                              content: Text(message),
                              actions: <Widget>[
                                MaterialButton(
                                    child: const Text(Texts.close),
                                    onPressed: () { Navigator.of(context).pop(); }
                                ),
                              ]
                          );
                        });
                      }
                    });
                  } : null,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  color: colors.primary,
                  disabledColor: colors.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(Texts.register,
                      style: TextStyle(
                          color: colors.surface
                      ),
                    ),
                  )
              ),
            )
          ]
        )
      )
    );
  }

  String? passwordValidation(String? password){
    return password != null && password.isEmpty ? Texts.passwordNotEmpty :
    passwordController.text != password ? Texts.passwordsMatch :
    passwordController.text.length < 6 ? Texts.passwordShort : null;
  }

}