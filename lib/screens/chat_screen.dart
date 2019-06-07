import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/MessageBubble.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "CHAT_SCREEN";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser;
  Firestore _firestore = Firestore.instance;
  String messageText;
  TextEditingController messageTextController = TextEditingController();

  void getCurrentUser() async {
    this._currentUser = await _auth.currentUser();
    print(_currentUser);
  }

  void getMessages() {
    Stream<QuerySnapshot> snapshot =
        _firestore.collection('messages').snapshots();

    snapshot.listen((onData) {
      List<DocumentSnapshot> docs = onData.documents;
      for (DocumentSnapshot doc in docs) {
        print(doc.data['text']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                  } else {
                    List<DocumentSnapshot> docs = snapshot.data.documents;
                    List<MessageBubble> textItems = List<MessageBubble>();
                    for (DocumentSnapshot doc in docs) {
                      textItems.add(MessageBubble(
                        from: doc.data['from'],
                        text: doc.data['text'],
                        fromMe: _currentUser.email == doc.data['from'],
                      ));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: textItems,
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      controller: messageTextController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      //Implement send functionality.
                      print(messageTextController.text);
                      if (messageTextController.text.length > 0) {
                        await _firestore.collection('messages').add({
                          'text': messageTextController.text,
                          'from': _currentUser.email
                        });
                        messageTextController.clear();
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
