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
    final messageList = Provider.of<ChatMessages>(context).getMessageList;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) => Message(
                message: messageList[index],
                index: index,
              ),
            ),
          ),
        ),
        ChatInputField(),
      ],
    );
  }
}
