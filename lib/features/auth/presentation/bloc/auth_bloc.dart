import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_logout.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserLogout _userLogout;

AuthBloc({
  required UserSignUp userSignUp,
  required UserLogin userLogin,
  required CurrentUser currentUser,
  required UserLogout userLogout,
  required AppUserCubit appUserCubit,
})  : _userSignUp = userSignUp,
      _userLogin = userLogin,
      _currentUser = currentUser,
      _userLogout = userLogout,
      _appUserCubit = appUserCubit,
      super(AuthInitial()) {
  on<AuthEvent>((_, emit) => emit(AuthLoading()));
  on<AuthSignUp>(_onAuthSignUp);
  on<AuthLogin>(_onAuthLogin);
  on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  on<AuthLogout>(_onAuthLogout);
}


  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold((l) => emit(AuthFailure(l.message)),
        (r) =>  _emitAuthSuccess(r, emit));
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp.call(UserSignUpParams(
        email: event.email, password: event.password, name: event.name));
    res.fold((failure) {
      emit(AuthFailure(failure.message));
    }, (user) {
      _emitAuthSuccess(user, emit);
    });
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin
        .call(UserLoginParams(email: event.email, password: event.password));
    res.fold((l) {
      emit(AuthFailure(l.message));
    }, (r) {
      _emitAuthSuccess(r, emit);
    });
  }

  void _emitAuthSuccess(User user,Emitter<AuthState> emit){
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  final res = await _userLogout(NoParams());
  res.fold((failure) {
    emit(AuthFailure(failure.message));
  }, (_) {
    _appUserCubit.updateUser(null); // Reset user in global state
    emit(AuthInitial()); // Or a custom LoggedOut state
  });
}

}
