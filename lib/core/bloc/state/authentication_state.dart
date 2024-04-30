part of 'package:lazy_dm_helper/core/bloc/authentication_bloc.dart';

//It's the main class that covers all the different stages the
//authentication process can go through
abstract class AuthenticationState{
  const AuthenticationState();

  List<Object> get props => [];
}

//This signifies the starting point of the authentication process
class AuthenticationInitialState extends AuthenticationState{}

//This indicates a situation where the authentication process is underway,
//and the user interface should display a loading indicator
class AuthenticationLoadingState extends AuthenticationState{
  final bool isLoading;
  AuthenticationLoadingState({required this.isLoading});
}

//This indicates a condition in which the authentication process has finished successfully
class AuthenticationSuccessState extends AuthenticationState{
  final UserModel user;
  const AuthenticationSuccessState(this.user);

  @override
  List<Object> get props => [user];
}

//
// This means that the authentication attempt was not successful
class AuthenticationFailureState extends AuthenticationState{
  final String errorMessage;
  const AuthenticationFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}