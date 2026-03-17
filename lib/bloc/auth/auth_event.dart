part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class SubmitEvent extends AuthEvent{
  
}

final class CheckLoginStatusEvent extends AuthEvent{

}

final class LogoutEvent extends AuthEvent{}