part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  AuthEvent();

  @override
  List<Object?> get props => [];
}

// * save access token
class SaveAccessTokenEvent extends AuthEvent {
  final String accessToken;

  SaveAccessTokenEvent({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}

// * get access token
class GetAccessTokenEvent extends AuthEvent {}

// * logout
class LogoutEvent extends AuthEvent {}
