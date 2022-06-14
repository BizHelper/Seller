import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/firebaseService.dart';
import 'package:seller_app/src/screens/chatConversation.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;
  ChatCard(this.chatData);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  FirebaseService _service = FirebaseService();
  DocumentSnapshot? doc;
  getProductDetails() {
    _service.getProductDetails(widget.chatData['product']['productDetailId']).then((value){
      setState((){
        doc = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    getProductDetails();
    return doc == null?
    Container(): Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey), )
      ),
      child: ListTile(
        onTap: (){
          Navigator.push (
            context,
            MaterialPageRoute (
              builder: (BuildContext context) =>  ChatConversations(chatRoomId: widget.chatData['chatRoomId']),
            ),
          );
        },
        leading: Image.network(doc!['Image URL']),
        title: Text(doc!['Name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doc!['Description'], maxLines: 1),
          ],
        ),
      ),
    );
  }
}