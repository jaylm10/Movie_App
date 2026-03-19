import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie/service/profile_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileService profileService;
  ProfileBloc(this.profileService) : super(ProfileInitial()) {
    on<SubmitProfileEvent>((event, emit) async {
      await profileService.storeProfile(
        event.name,
        event.mobile,
        event.email,
        event.bio,
      );
      emit(
        ProfileCompleted(
          name: event.name,
          mobile: event.mobile,
          email: event.email,
          bio: event.bio,
        ),
      );
    });

    on<CheckProfileStatusEvent>((event, emit) async {
      bool isProfileComplete = await profileService.checkProfileStatus();

      if (!isProfileComplete) {
        emit(ProfilePending());
        return;
      }

      final Map<String, String> profile = await profileService.getProfile();

      emit(
        ProfileCompleted(
          name: profile['name'] ?? '',
          mobile: profile['mobile'] ?? '',
          email: profile['email'] ?? '',
          bio: profile['bio'] ?? '',
        ),
      );
    });

    on<DeleteAccountEvent>((event, emit) async{
      await profileService.deleteAccount();
      
    },);
  }
}
