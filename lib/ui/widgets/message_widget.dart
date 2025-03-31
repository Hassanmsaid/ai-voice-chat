import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message});

  final String message;

  bool _messageFromMe(String message) => message.startsWith('You');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _messageFromMe(message) ? Color(0xFF6CB2FF) : Colors.green.shade200,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_messageFromMe(message) ? 15 : 0),
          topRight: Radius.circular(_messageFromMe(message) ? 0 : 15),
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: ListTile(
        title: Text(message),
      ),
    );
  }
}
