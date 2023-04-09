import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.arguments}) : super(key: key);

  final ChatScreenArgs arguments;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatScreenArgs {
  final String peerId;
  final String peerAvatar;
  final String peerName;

  ChatScreenArgs({required this.peerId, required this.peerAvatar, required this.peerName});
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            Icon(Icons.arrow_back, color: Colors.white,),
            SizedBox(width: 3.w,),
            CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(widget.arguments.peerAvatar),
          )
          ],
        ),
      ),

    );
  }
}
