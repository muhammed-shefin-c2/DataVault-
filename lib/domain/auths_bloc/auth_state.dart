import 'package:equatable/equatable.dart';
import 'package:technical_test/domain/entities/user_entity.dart';

abstract class AuthrState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitial extends AuthrState {}

class AuthLoading extends AuthrState {}

class AuthAuthenticated extends AuthrState {
  final UserEntity userEntity;

  AuthAuthenticated(this.userEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [userEntity];
}

class AuthUnauthenticated extends AuthrState {
}

class AuthError extends AuthrState{
  final String message;

  AuthError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}


class AuthCreatedInitial extends AuthrState {}

class AuthCreatedLoading extends AuthrState {}

class AuthCreatedSuccess extends AuthrState {
  final UserEntity userEntity;

  AuthCreatedSuccess(this.userEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [userEntity];
}

class AuthCreatedFailed extends AuthrState {
  final String message;

  AuthCreatedFailed(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

