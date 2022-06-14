import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_chat_bubble/bubble_type.dart';
// import 'package:flutter_chat_bubble/chat_bubble.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:seller_app/src/firebaseService.dart';
import 'package:seller_app/src/screens/home.dart';
import 'package:seller_app/src/widgets/chatCard.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            elevation: 0.0,
            backgroundColor: Colors.cyan.shade900,
            title: const Text('Chats', style: TextStyle(color: Colors.white)),
            bottom: const TabBar(
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorWeight: 6,
                tabs: [
                  Tab(text: 'All Chats'),
                ])),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _service.messages
                  .where('users', arrayContains: _auth.currentUser!.uid)
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
                    return ChatCard(data);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
