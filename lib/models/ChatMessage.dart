import 'package:flutter/cupertino.dart';

enum ChatMessageType { text, audio, image, video }

enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus? messageStatus;
  final bool isSender;
  final String? sender;
  final String? senderImage;
  final String? imageUrl;

  ChatMessage({
    this.text = '',
    required this.messageType,
     this.messageStatus,
    required this.isSender,
    this.sender,
    this.senderImage,
    this.imageUrl,
  });
}
class ChatMessages with ChangeNotifier{
  List<ChatMessage> _chatMessages = [
    ChatMessage(
        text: "Hi Sajol,",
        messageType: ChatMessageType.text,
        messageStatus: MessageStatus.viewed,
        isSender: false,
        senderImage: 'assets/images/user.png',
        sender: "Jenny Wilson"
    ),
    ChatMessage(
      text: "Hello, How are you?",
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
      isSender: true,

    ),
    ChatMessage(
      text: "Hello, guys",
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
      isSender: false,
      senderImage: 'assets/images/user_2.png',
      sender: "Ralph Edwards",

    ),
    ChatMessage(
      text: "Error happend",
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
      isSender: false,
      senderImage: 'assets/images/user_3.png',
      sender: "Jacob Jones",

    ),
    ChatMessage(
        text: "This looks great man!!",
        messageType: ChatMessageType.text,
        messageStatus: MessageStatus.viewed,
        isSender: false,
        senderImage: 'assets/images/user_4.png',
        sender: "Albert Flores"
    ),
    ChatMessage(
      text: "Glad you like it",
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
      isSender: false,
      senderImage: 'assets/images/user_5.png',
      sender: "Esther Howard",

    ),
  ];

  void addMessage(ChatMessage message){
    _chatMessages.add(message);
    notifyListeners();
  }

  List<ChatMessage> get getMessageList =>
     _chatMessages;
}

