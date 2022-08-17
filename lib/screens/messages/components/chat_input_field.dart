import 'dart:convert';

import 'package:chat/models/ChatMessage.dart';
import 'package:chat/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

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
                              uploadImage();
                              XFile? file = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              print(file!.path);
                              final image = Image.file(File(file.path));
                              print('width:${image.width}');
                              print('height:${image.height}');
                              final message = ChatMessage(
                                  messageType: ChatMessageType.image,
                                  messageStatus: MessageStatus.viewed,
                                  isSender: false,
                                  sender: 'Jenny Wilson',
                                  senderImage: 'assets/images/user.png',
                                  imageUrl: file.path);
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
                            onPressed: () async{
                              final message = ChatMessage(
                                  messageType: ChatMessageType.text,
                                  messageStatus: MessageStatus.not_view,
                                  isSender: true,
                                  text: messageController.text);
                              messageController.clear();
                              Provider.of<ChatMessages>(context, listen: false)
                                  .addMessage(message);
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
  uploadImage() async{

    var request = http.MultipartRequest("POST",Uri.parse("https://10.0.2.2:3000/post-image"));

    request.fields['title'] = "dummyImage";
    request.headers['Authorization'] = "Client-ID " +"f7........";

    var picture = http.MultipartFile.fromBytes('image',
        (await rootBundle.load('assets/images/user.png')).buffer.asUint8List(),
        filename: 'testimage.png');

    request.files.add(picture);

    var response = await request.send();

    var responseData = await response.stream.toBytes();

    var result = String.fromCharCodes(responseData);

    print(result);



  }
}
