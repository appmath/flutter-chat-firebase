import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase_fcg/utils/aziz_material_colors.dart';
import 'package:flutter_chat_firebase_fcg/utils/constants.dart';

final _firestore = FirebaseFirestore.instance;
final _firebaseAuth = FirebaseAuth.instance;

class NewMessageWidget extends StatefulWidget {
  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final User? user = _firebaseAuth.currentUser;
    final userData = await _firestore.collection(kUsers).doc(user!.uid).get();

    _firestore.collection(kChat).add({
      kText: _enteredMessage,
      kCreatedAt: Timestamp.now(),
      kUserId: user.uid,
      kUsername: userData[kUsername],
      kUserImage: userData[kImageUrl],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: 'Send a message...',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: darkOrange,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}

// final _controller = TextEditingController();
// _controller.clear();
