import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/auth/auth_bloc.dart';
import 'package:movie/home.dart';
import 'package:movie/login.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  @override
  void initState() {
    
    super.initState();
    context.read<AuthBloc>().add(CheckLoginStatusEvent());
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(listener: (context,state){
          if (state is Authenticated){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
          } 
           if(state is Unauthenticated){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));

          }
    });
  }
}