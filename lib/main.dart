import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:chat/screens/signinOrSignUp/signin_or_signup_screen.dart';
import 'package:chat/screens/welcome/welcome_screen.dart';
import 'package:chat/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp().then((value){
      FirebaseMessaging.instance.getToken().then((value) => print(value));
      FirebaseMessaging.instance.subscribeToTopic('messages').then((value) => print("DONE"));
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatMessages>.value(value: ChatMessages()),
        ChangeNotifierProvider<GoogleUser>.value(value: GoogleUser())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        home: SigninOrSignupScreen(),
      ),
    );
  }
}
