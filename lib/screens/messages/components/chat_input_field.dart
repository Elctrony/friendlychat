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
                              final storage = FirebaseStorage.instance;
                              final firestore = FirebaseFirestore.instance;
                              final user = Provider.of<GoogleUser>(context,listen: false).user;
                              final ref = storage.ref().child('images').child(
                                  DateTime.now().toIso8601String() + file.name);
                              FormData formData = new FormData.fromMap({
                              "image":            await MultipartFile.fromFile(file.path),
                                "text":"Welcome Body"
                              });
                            //  final respone = await Dio().post('http://10.0.2.2:3000/post-image',
                             //     data: formData,
                              //    options:Options(headers: {'Content-Type':'multipart/form-data',"Accept":'*/*'}),);
                              //print(respone.data);
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
                                  isSender: true,
                                  imageUrl: file.path);

                              final storage = FirebaseStorage.instance;
                              final firestore = FirebaseFirestore.instance;
                              final user = Provider.of<GoogleUser>(context,listen: false).user;
                              final ref = storage.ref().child('images').child(
                                  DateTime.now().toIso8601String() + file.name);
                              FormData formData = new FormData.fromMap({
                                "image": new File(file.path),
                                'text':'Welcome Darling'
                              });
                              final link = Uri.http('10.0.2.2:3000','/post-image');
                             // await ref.putFile(File(file!.path));
                              //final url = await ref.getDownloadURL();
                              //print(url);
                             /*await firestore.collection('messages').add({
                                'image': url,
                                'senderId': user.uid,
                                'senderName': user.displayName,
                                'senderImage': user.photoURL,
                                'type': 1,
                                'timestamp': DateTime.now(),
                              }).then((value) => print(value.id));*/
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
                              Provider.of<ChatMessages>(context, listen: false)
                                  .addMessage(message);
                              final user = Provider.of<GoogleUser>(context,
                                      listen: false)
                                  .user;
                              final firestore = FirebaseFirestore.instance;
                              final googleUser = Provider.of<GoogleUser>(context,listen: false).googleUser;
                              final link = Uri.http('10.0.2.2:3000','/save-message');
                              final messageText = messageController.text;
                              messageController.clear();
                              final respone = await http.post(link,headers: {
                                "content-type":"application/json",
                                'id':googleUser.id
                              },body: jsonEncode({
                                'message':messageText,
                                'type':'text',
                              }));
                              print(jsonDecode(respone.body));
                              firestore.collection('messages').add({
                                'message': messageText,
                                'senderId': user.uid,
                                'senderName': user.displayName,
                                'senderImage': user.photoURL,
                                'type': 0,
                                'timestamp': DateTime.now(),
                              }).then((value) => print(value.id));
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
