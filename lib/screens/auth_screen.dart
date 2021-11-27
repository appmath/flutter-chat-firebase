import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase_fcg/utils/constants.dart';
import 'package:flutter_chat_firebase_fcg/widgets/auth/auth_form.dart';

final _firestore = FirebaseFirestore.instance;
final _firebaseStorage = FirebaseStorage.instance;

late User loggedInUser;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential user;
    try {
      print('_submitAuthForm');
      setState(() {
        _isLoading = true;
      });
      print('isLogin: $isLogin');
      print('email: $email ,  password: $password');

      if (isLogin) {
        user = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        print('New User');

        user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        var uid = user.user!.uid;

        // TODO Add this
        try {
          TaskSnapshot taskSnapshot = await _firebaseStorage
              .ref()
              .child(kUserImage)
              .child('$uid.jpeg')
              .putFile(image!);

          var downloadURL = await taskSnapshot.ref.getDownloadURL();
          print('downloadURL: $downloadURL');

          await _firestore.collection(kUsers).doc(uid).set(
              {kUsername: username, kEmail: email, kImageUrl: downloadURL});
        } catch (e) {
          print(e);
        }
      }

      // } on PlatformException catch (e) {
      //   print('PlatformError: $e');
      //
      //   var message = 'An error occurred, please check your credentials';
      //
      //   if (e.message != null) {
      //     message = e.message!;
      //   }
      //   ScaffoldMessenger.of(ctx).showSnackBar(
      //     SnackBar(
      //       content: Text(message),
      //       backgroundColor: Theme.of(context).errorColor,
      //     ),
      //   );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      var message = 'An error occurred, please check your credentials';

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
    print('Done!');
  }

  @override
  Widget build(BuildContext context) {
    return // Probably need SafeArea()
        Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(''),
        // backgroundColor: Colors.white,
      ),
      body: AuthForm(onSubmitFn: _submitAuthForm, isLoading: _isLoading),
    );
  }
}
