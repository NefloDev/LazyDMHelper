import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_dm_helper/core/auth_service.dart';
import 'package:lazy_dm_helper/models/user_model.dart';
import 'package:logger/logger.dart';

part 'event/authentication_event.dart';
part 'state/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{
  final AuthService service = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()){
    Logger logger = Logger();
    on<AuthenticationEvent>((event, emit) {});

    on<SignUpUserEmail>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try{
        final UserModel? user = await service.signUpEmailPassword(event.email, event.password);
        if (user!=null){
          emit(AuthenticationSuccessState(user));
        }else{
          emit(const AuthenticationFailureState("Create user failed"));
        }
      }catch(e){
        logger.e(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignUpUserGoogle>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try{
        final UserModel? user = await service.signInGoogle();
        if (user!=null){
          emit(AuthenticationSuccessState(user));
        }else{
          emit(const AuthenticationFailureState("Create user failed"));
        }
      }catch(e){
        logger.e(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try{
        service.signOutUser();
      }catch(e){
        logger.e(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}