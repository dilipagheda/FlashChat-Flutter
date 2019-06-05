import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String from;
  final String text;
  MessageBubble({this.from, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          from,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        Material(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(30),
          elevation: 5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
