import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase_fcg/screens/auth_screen.dart';
import 'package:flutter_chat_firebase_fcg/screens/chat_screen.dart';
import 'package:flutter_chat_firebase_fcg/widgets/chat/splash_screen.dart';

import 'utils/aziz_material_colors.dart';

final _firebaseAuth = FirebaseAuth.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() {
    print('Firebase is initialized');
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: greyMaterialColor,
        accentColor: orangeMaterialColor,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        // textTheme: ThemeData.light().textTheme.copyWith(
        //       bodyText1: TextStyle(
        //         color: darkOrange,
        //
        //         // color: Color.fromRGBO(20, 51, 51, 1),
        //       ),
        //       bodyText2: TextStyle(
        //
        //           // color: Color.fromRGBO(20, 51, 51, 1),
        //           ),
        //       headline6: TextStyle(
        //         // fontWeight: FontWeight.bold,
        //         color: darkOrange,
        //       ),
        //     ),
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: orangeMaterialColor,
          textTheme: ButtonTextTheme.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      // add final _firebaseAuth = FirebaseAuth.instance;
      home: StreamBuilder(
          stream: _firebaseAuth.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              return ChatScreen();
            }
            return AuthScreen();
          }),
    );
  }
}
