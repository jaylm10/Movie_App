part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class Authenticated extends AuthState{}

final class Unauthenticated extends AuthState{}

final class Error extends AuthState{}
