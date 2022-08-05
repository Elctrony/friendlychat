import 'package:chat/constants.dart';
import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: StreamBuilder<QuerySnapshot<Map>>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final snapshotData = snapshot.data!;
                  final size = snapshotData.size;
                  List<ChatMessage> chatMessages = [];
                  final user =
                      Provider.of<GoogleUser>(context, listen: false).user;
                  if(user == null){
                    Navigator.of(context).pop();
                  }
                  snapshotData.docs.forEach((element) {
                    final data = element.data();
                    ChatMessageType type;
                    ChatMessage message;
                    final senderId = data['senderId'];

                    if (data['type'] == 1) {
                      type = ChatMessageType.image;
                      message = ChatMessage(
                        messageType: type,
                        messageStatus: MessageStatus.viewed,
                        isSender: user.uid == senderId,
                        senderImage: data['senderImage'],
                        sender: data['senderName'],
                        imageUrl: data['image']
                      );
                    } else {
                      type = ChatMessageType.text;
                      message = ChatMessage(
                        messageType: type,
                        messageStatus: MessageStatus.viewed,
                        isSender: user.uid == senderId,
                        senderImage: data['senderImage'],
                        sender: data['senderName'],
                        text: data['message'],
                      );
                    }
                    chatMessages.add(message);
                  });
                  return ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) => Message(
                      message: chatMessages[index],
                      index: index,
                    ),
                  );
                }),
          ),
        ),
        ChatInputField(),
      ],
    );
  }
}
