part of 'package:lazy_dm_helper/core/bloc/authentication_bloc.dart';

//This class serves as the foundation for various events that cause
//changes in the authentication status
abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class UpdateUserEvent extends AuthenticationEvent{
  UserModel user;
  UpdateUserEvent(this.user);
}