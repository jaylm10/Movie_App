import 'package:bloc/bloc.dart';
import 'package:movie/service/auth_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{

  AuthService authService;

  AuthBloc({required this.authService}) :super(AuthInitial()){
    on<SubmitEvent>((event, emit) async{
      await authService.storeToken(event.email);
      emit(Authenticated());
    },);

    on<CheckLoginStatusEvent>((event, emit) async {
      bool isLoggedIn =  await authService.checkStatus();

      if(isLoggedIn){
        emit(Authenticated());

      }else{
        emit(Unauthenticated());
      }
      
    },);

    on<LogoutEvent>((event, emit) async {
      await authService.logout();
      emit(Unauthenticated());
    });
  }
  
}