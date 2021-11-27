import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase_fcg/utils/constants.dart';
import 'package:flutter_chat_firebase_fcg/widgets/chat/message_bubble.dart';

final _firebaseAuth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class MessagesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO Add this
    return FutureBuilder(
        future: Future.value(_firebaseAuth.currentUser),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return StreamBuilder(
            stream: _firestore
                .collection(kChat)
                .orderBy(
                  kCreatedAt,
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var chatDocs = snapshot.data!.docs;

              return ListView.builder(
                reverse: true,
                itemBuilder: (context, index) {
                  var chat = chatDocs[index];
                  print('chat.id: ${chat.id}');

                  return Container(
                    padding: const EdgeInsets.all(2),
                    child: MessageBubble(
                      message: chat[kText],
                      userImage: chat[kUserImage],
                      isMe: isMe(chat),
                      myKey: ValueKey(chat.id),
                      username: chat[kUsername],
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          );
        });
  }

  bool isMe(QueryDocumentSnapshot<Object?> chat) {
    var currentUser = _firebaseAuth.currentUser;
    bool isMe = false;
    if (currentUser != null) {
      isMe = currentUser.uid == chat[kUserId];
    }
    print('isMe: $isMe');

    return isMe;
  }
}
