import 'package:flutter/material.dart';

class ChatUserError extends StatefulWidget {
  const ChatUserError({Key? key}) : super(key: key);

  @override
  State<ChatUserError> createState() => _ChatUserErrorState();
}

class _ChatUserErrorState extends State<ChatUserError> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.black87,
        child: const Center(child: Text("Nothing found"),),),);
  }
}
