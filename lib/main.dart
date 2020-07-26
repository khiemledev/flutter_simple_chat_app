import 'package:simple_chat_app/screens/chat_screen.dart';
import 'package:simple_chat_app/screens/sign_in_screen.dart';
import 'package:simple_chat_app/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.id,
      routes: {
        SignInScreen.id: (_) => SignInScreen(),
        SignUpScreen.id: (_) => SignUpScreen(),
        ChatScreen.id: (_) => ChatScreen(),
      },
    );
  }
}
