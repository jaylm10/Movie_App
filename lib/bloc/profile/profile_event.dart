part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class SubmitProfileEvent extends ProfileEvent{
  final String name;
  final String mobile;
  final String email;
  final String bio;

  SubmitProfileEvent({required this.name, required this.mobile,required this.email,required this.bio});

}

final class CheckProfileStatusEvent extends ProfileEvent{}

final class DeleteAccountEvent extends ProfileEvent{}
