part of 'package:lazy_dm_helper/core/bloc/authentication_bloc.dart';

//This class serves as the foundation for various events that cause
//changes in the authentication status
abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

//This class represents an event where a user is trying to register using email and password
class SignUpUserEmail extends AuthenticationEvent {
  final String email;
  final String password;

  const SignUpUserEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

//This class represents an event where a user is trying to register using a google account
class SignUpUserGoogle extends AuthenticationEvent {
  const SignUpUserGoogle();

  @override
  List<Object> get props => [];
}

//Instances of this class will notify the Bloc that a user is attempting to log out
class SignOut extends AuthenticationEvent {}