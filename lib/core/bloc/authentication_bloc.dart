import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_dm_helper/core/auth_service.dart';
import 'package:lazy_dm_helper/models/user_model.dart';

part 'event/authentication_event.dart';
part 'state/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{
  UserModel user = UserModel(id: "", email: "");
  final AuthService service = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()){
    on<AuthenticationEvent>((event, emit) {});
    on<UpdateUserEvent>(onUserUpdate);
  }

  Future onUserUpdate(UpdateUserEvent event, Emitter<AuthenticationState> emit) async {
    user = event.user;
    emit(AuthenticationLoggedInState(user: user));
  }
}