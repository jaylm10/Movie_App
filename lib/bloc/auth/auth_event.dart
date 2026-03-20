part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class SubmitEvent extends AuthEvent{
  final String email;

  SubmitEvent(this.email);
  
}

final class CheckLoginStatusEvent extends AuthEvent{

}

final class LogoutEvent extends AuthEvent{}