import 'package:simple_chat_app/screens/sign_in_screen.dart';
import 'package:simple_chat_app/services/AuthService.dart';
import 'package:simple_chat_app/services/MessageService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();

  bool _isComposing = false;
  FirebaseUser _user;

  Future _signOut() async {
    await AuthService.signOut();
    Navigator.pushReplacementNamed(context, SignInScreen.id);
  }

  Future _sendMessage() async {
    final message = _messageController.text.trim();
    setState(() {
      _messageController.clear();
      _isComposing = false;
    });
    await MessageService.sendMessage(
      message: message,
      senderId: _user.uid,
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              decoration: InputDecoration.collapsed(
                hintText: 'Your message here...',
              ),
              onChanged: (value) {
                setState(() {
                  _isComposing = value.isNotEmpty;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _isComposing && _user != null ? _sendMessage : null,
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Future _getUser() async {
    _user = await AuthService.currentUser();
    setState(() {});
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _user != null ? (_user.displayName ?? 'Anonymous') : 'Loading'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: MessageService.messageStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'No message here',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                final docs = snapshot.data.documents;
                return ListView(
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  children: List.generate(
                    docs.length,
                    (index) {
                      return Column(
                        crossAxisAlignment: docs[index]['senderId'] == _user.uid
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_user.displayName ?? 'Anonymous'),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(
                                    docs[index]['senderId'] == _user.uid
                                        ? 8.0
                                        : 0.0),
                                bottomRight: Radius.circular(
                                    docs[index]['senderId'] == _user.uid
                                        ? 0.0
                                        : 8.0),
                              ),
                            ),
                            color: docs[index]['senderId'] == _user.uid
                                ? Colors.blue
                                : Colors.blueGrey,
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                docs[index]['message'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.0),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Divider(),
          _buildComposer(),
        ],
      ),
    );
  }
}
