import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../constants.dart';

class ChatInputField extends StatefulWidget {
  ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    messageController.text.isEmpty
                        ? IconButton(
                            onPressed: () async {
                              print('Gallery');
                              XFile? file = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              print(file!.path);
                              final image = Image.file(File(file.path));
                              print('image:${image}');
                              print('height:${image.height}');
                              final message = ChatMessage(
                                  messageType: ChatMessageType.image,
                                  messageStatus: MessageStatus.viewed,
                                  isSender: true,
                                  imageUrl: file.path);
                              final storage = FirebaseStorage.instance;
                              final firestore = FirebaseFirestore.instance;
                              final user = Provider.of<GoogleUser>(context,listen: false).user;
                              final ref = storage.ref().child('images').child(
                                  DateTime.now().toIso8601String() + file.name);

                              await ref.putFile(File(file!.path));
                              final url = await ref.getDownloadURL();
                              print(url);
                              await firestore.collection('messages').add({
                                'image': url,
                                'senderId': user.uid,
                                'senderName': user.displayName,
                                'senderImage': user.photoURL,
                                'type': 1,
                                'timestamp': DateTime.now(),
                              }).then((value) => print(value.id));
                              Provider.of<ChatMessages>(context, listen: false)
                                  .addMessage(message);
                            },
                            icon: Icon(
                              Icons.attach_file,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          )
                        : SizedBox(),
                    messageController.text.isEmpty
                        ? SizedBox(width: kDefaultPadding / 4)
                        : SizedBox(),
                    messageController.text.isEmpty
                        ? IconButton(
                            onPressed: () async {
                              print('Camera');
                              XFile? file = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              print(file!.path);
                              final image = Image.file(File(file.path));
                              print('width:${image.width}');
                              print('height:${image.height}');
                              final message = ChatMessage(
                                  messageType: ChatMessageType.image,
                                  messageStatus: MessageStatus.viewed,
                                  isSender: true,
                                  imageUrl: file.path);

                              final storage = FirebaseStorage.instance;
                              final firestore = FirebaseFirestore.instance;
                              final user = Provider.of<GoogleUser>(context,listen: false).user;
                              final ref = storage.ref().child('images').child(
                                  DateTime.now().toIso8601String() + file.name);

                              await ref.putFile(File(file!.path));
                              final url = await ref.getDownloadURL();
                              print(url);
                             await firestore.collection('messages').add({
                                'image': url,
                                'senderId': user.uid,
                                'senderName': user.displayName,
                                'senderImage': user.photoURL,
                                'type': 1,
                                'timestamp': DateTime.now(),
                              }).then((value) => print(value.id));
                              Provider.of<ChatMessages>(context, listen: false)
                                  .addMessage(message);
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          )
                        : SizedBox(),
                    messageController.text.isNotEmpty
                        ? SizedBox(width: kDefaultPadding / 4)
                        : SizedBox(),
                    messageController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              final message = ChatMessage(
                                  messageType: ChatMessageType.text,
                                  messageStatus: MessageStatus.not_view,
                                  isSender: true,
                                  text: messageController.text);
                              Provider.of<ChatMessages>(context, listen: false)
                                  .addMessage(message);
                              final user = Provider.of<GoogleUser>(context,
                                      listen: false)
                                  .user;
                              final firestore = FirebaseFirestore.instance;
                              firestore.collection('messages').add({
                                'message': messageController.text,
                                'senderId': user.uid,
                                'senderName': user.displayName,
                                'senderImage': user.photoURL,
                                'type': 0,
                                'timestamp': DateTime.now(),
                              }).then((value) => print(value.id));
                              messageController.clear();
                            },
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
