part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileCompleted extends ProfileState{
  final String name;
  final String mobile;
  final String email;
  final String bio;

  ProfileCompleted({required this.name, required this.mobile,required this.email,required this.bio});
}

final class ProfilePending extends ProfileState{}