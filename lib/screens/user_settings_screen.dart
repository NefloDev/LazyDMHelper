import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_dm_helper/constants/constants.dart';
import 'package:lazy_dm_helper/core/core.dart';
import 'package:lazy_dm_helper/models/user_model.dart';
import 'package:lazy_dm_helper/screens/screens.dart';
import 'package:lazy_dm_helper/widgets/widgets.dart';

class UserSettingsScreen extends StatefulWidget{
  const UserSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => UserSettingScreenState();
}

class UserSettingScreenState extends State<UserSettingsScreen>{

  late bool waiting;
  late int dataDeleteResult;

  @override
  void initState() {
    super.initState();
    waiting = false;
    dataDeleteResult = 400;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    AuthService service = AuthService();
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
      UserModel user = (state as AuthenticationLoggedInState).user;
      return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(Texts.userSettingsTitle),
              centerTitle: true,
              actions: [
                IconButton(onPressed: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: const Text(Texts.logout),
                      content: const Text(Texts.confirmLogout),
                      actions: [
                        MaterialButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(Texts.cancel),
                        ),
                        MaterialButton(
                          onPressed: () {
                            service.signOutUser();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (_) => false);
                          },
                          child: const Text(Texts.accept),
                        )
                      ],
                    );
                  });
                }, icon: const Icon(Icons.logout))
              ]
          ),
          body: SingleChildScrollView(
              child: Column(
                  children: [
                    const LogoAvatar(radius: 100),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(user.email),
                    ),
                    SizedBox(
                        height: 200,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RoundedTextButton(
                                text: const Text(Texts.export),
                                backgroundColor: colors.secondaryContainer,
                                foregroundColor: colors.onSecondaryContainer,
                                elevation: 0,
                                size: const Size(250, 10),
                                radius: 100,
                              ),
                              RoundedTextButton(
                                text: const Text(Texts.import),
                                backgroundColor: colors.secondaryContainer,
                                foregroundColor: colors.onSecondaryContainer,
                                elevation: 0,
                                size: const Size(250, 10),
                                radius: 100,
                              ),
                              RoundedTextButton(
                                text: const Text(Texts.reset),
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                elevation: 0,
                                size: const Size(250, 10),
                                radius: 100,
                                onPressed: (){
                                  showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text(Texts.dataDelete),
                                      content: waiting ? const SizedBox(height: 200, child: CircularProgressIndicator()) : const Text(Texts.dataDeleteConfirm),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text(Texts.no),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              waiting = true;
                                            });
                                            showDialog(context: context, builder: (BuildContext context){
                                              return const AlertDialog(
                                                  title: Text(Texts.dataDelete),
                                                  content: Padding(
                                                    padding: EdgeInsets.all(48.0),
                                                    child: SizedBox(height: 132, child: CircularProgressIndicator(strokeWidth: 10,)),
                                                  )
                                              );
                                            });
                                            APIManager.deleteData(uid: user.id).then((value){
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              setState(() {
                                                waiting = false;
                                                dataDeleteResult = value;
                                              });
                                              showDialog(context: context, builder: (BuildContext context){
                                                return AlertDialog(
                                                    title: const Text(Texts.dataDelete),
                                                    content: Text(dataDeleteResult == 200 ? Texts.dataDeleteSuccess : Texts.dataDeleteFail),
                                                    actions: [
                                                      MaterialButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text(Texts.close)
                                                      )
                                                    ]
                                                );
                                              });
                                            });
                                          },
                                          child: const Text(Texts.yes),
                                        )
                                      ],
                                    );
                                  });
                                },
                              )
                            ]
                        )
                    ),
                    Divider(
                      indent: 32,
                      endIndent: 32,
                      height: 1,
                      thickness: 1,
                      color: colors.outlineVariant,
                    ),
                    SizedBox(
                        height: 150,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RoundedTextButton(
                                onPressed: (){
                                  service.resetPassword(email: user.email);
                                  showDialog(context: context, builder: (BuildContext context){
                                    return AlertDialog(
                                        title: const Text(Texts.resetPasswd),
                                        content: Text("${Texts.resetPasswdEmailSent}${user.email}"),
                                        actions: <Widget>[
                                          MaterialButton(
                                              child: const Text(Texts.close),
                                              onPressed: () { Navigator.of(context).pop(); }
                                          ),
                                        ]
                                    );
                                  });
                                },
                                text: const Text(Texts.changePasswd),
                                backgroundColor: colors.secondaryContainer,
                                foregroundColor: colors.onSecondaryContainer,
                                elevation: 0,
                                size: const Size(250, 10),
                                radius: 100,
                              ),
                              ElevatedButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return AlertDialog(
                                        title: const Text(Texts.accRemovalTitle),
                                        content: const Text(Texts.accRemovalConfirmation),
                                        actions: [
                                          MaterialButton(
                                              child: const Text(Texts.close),
                                              onPressed: () { Navigator.of(context).pop(); }
                                          ),
                                          MaterialButton(
                                              child: const Text("Accept"),
                                              onPressed: () {
                                                APIManager.deleteUser(uid: user.id);
                                                service.deleteAccount();
                                                Navigator.of(context).pop();
                                                showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                                                  return AlertDialog(
                                                    title: const Text(Texts.accDeleted),
                                                    content: const Text(Texts.accDeletionInfo),
                                                    actions: [
                                                      MaterialButton(
                                                        onPressed: (){
                                                          service.signOutUser();
                                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (_) => false);
                                                          },
                                                        child: const Text(Texts.accept),
                                                      )
                                                    ],
                                                  );
                                                });
                                              }
                                          )
                                        ],
                                      );
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(colors.primary),
                                      foregroundColor: MaterialStatePropertyAll(colors.onPrimary),
                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100)
                                      )),
                                      fixedSize: const MaterialStatePropertyAll( Size(250, 10))
                                  ),
                                  child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.delete_forever),
                                        Text(Texts.deleteAcc)
                                      ]
                                  )
                              )
                            ]
                        )
                    )
                  ]
              )
          )
      );
    });
  }
}