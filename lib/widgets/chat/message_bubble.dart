import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userImage;
  final Key myKey;

  MessageBubble({
    required this.message,
    required this.isMe,
    required this.myKey,
    required this.username,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: Column(
                children: [
                  // TODO practice by switching back to FutureBuilder
                  if (!isMe)
                    Text(
                      username,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.yellowAccent,
                        fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.yellowAccent,
                      fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        )
      ],
      clipBehavior: Clip.none,
    );
  }
}

// FutureBuilder(
//                 future: _firestore.collection(kUsers).doc(userId).get(),
//                 builder: (ctx, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Text('Loading...');
//                   }
//                   return Text(snapshot.data[kUsername]);
//                 },
//               ),
