part of 'package:lazy_dm_helper/core/bloc/authentication_bloc.dart';

//It's the main class that covers all the different stages the
//authentication process can go through
abstract class AuthenticationState{
  const AuthenticationState();

  List<Object> get props => [];
}

//This signifies the starting point of the authentication process
class AuthenticationInitialState extends AuthenticationState{}


class AuthenticationLoggedInState extends AuthenticationState{
  final UserModel user;
  AuthenticationLoggedInState({required this.user});
}
