import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/services/authService.dart';
import 'package:seller_app/src/services/firebaseService.dart';
import 'package:seller_app/src/screens/request.dart';
import 'package:seller_app/src/widgets/requestChatCard.dart';

class RequestChatScreen extends StatefulWidget {
  @override
  State<RequestChatScreen> createState() => _RequestChatScreenState();
}

class _RequestChatScreenState extends State<RequestChatScreen> {
  FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => RequestScreen(
                  type: 'Available Requests',
                  currentCategory: 'All Requests',
                  sort: 'Default (Newest)',)));
          },
        ),
        backgroundColor: Colors.cyan.shade900,
        title: const Text('All Chats', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.requestMessages
            .where('users', arrayContains: AuthService().auth.currentUser!.uid)
            .orderBy('lastChatTime', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return ListView(
            children:
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              return RequestChatCard(data);
            }).toList(),
          );
        },
      ),
    );
  }
}
