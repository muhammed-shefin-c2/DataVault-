import 'package:bloc/bloc.dart';
import 'package:technical_test/Services/auth_service.dart';
import 'package:technical_test/domain/auths_bloc/auth_event.dart';
import 'package:technical_test/domain/auths_bloc/auth_state.dart';



class AuthBloc extends Bloc<AuthEvent, AuthrState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AppStartEvent>(_appStarted);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthrState> emit) async {
    emit(AuthLoading());
    try{
      final userEntity = await authService.signInWithEmailPassword(event.email, event.password);
      emit(AuthAuthenticated(userEntity));
    } catch (e) {
      emit(AuthError("Error in Sign in: ${e.toString()}"));
    }
  }

  Future<void> _appStarted(AppStartEvent event, Emitter<AuthrState> emit) async {
    emit(AuthLoading());
    final user = await authService.userChanges.first;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthrState> emit,) async {
    emit(AuthLoading());
    try{
      final userEntity = await authService.signUpWithEmailPassword(event.email, event.password);
      emit(AuthCreatedSuccess(userEntity));
    } catch (e) {
      emit(AuthCreatedFailed("Error in Sign Up: ${e.toString()}"));
    }
  }
}