import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase_fcg/utils/aziz_material_colors.dart';
import 'package:flutter_chat_firebase_fcg/utils/constants.dart';
import 'package:flutter_chat_firebase_fcg/widgets/chat/messages_widget.dart';
import 'package:flutter_chat_firebase_fcg/widgets/chat/new_message_widget.dart';

final _firestore = FirebaseFirestore.instance;
final _firebaseAuth = FirebaseAuth.instance;
final _firebaseMessaging = FirebaseMessaging.instance;

const messagesPath = 'chats/QNE7jNi4eafToKLQ8qJi/messages';

class ChatScreen extends StatefulWidget {
  // Warning: use didChangeDependencies() for ModalRoute.of(context) or anything that's loaded/created during initState (too early)

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null) {
        print('notification.body: ${notification.body}');
        print('notification.title: ${notification.title}');
      }
      print('message: ${message.data}');

      print('----- Received Notification');
    });
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return // DON'T FORGET TO SPECIFY THE itemCount!!!!
        // Probably need SafeArea()
        Scaffold(
      appBar: AppBar(
        title: const Text(kChat),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: darkGrey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: darkGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                _firebaseAuth.signOut();
              }
            },
          ),
        ],
        // backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesWidget(),
          ),
          NewMessageWidget(),
        ],
      ),
    );
  }
}
