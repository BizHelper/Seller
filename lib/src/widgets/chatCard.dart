import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/firebaseService.dart';
import 'package:seller_app/src/screens/chatConversation.dart';
import 'package:seller_app/src/screens/productDescription.dart';

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
        leading: SizedBox(child: Image.network(doc!['Image URL'], height: 50, width: 50)),
        title: Text(doc!['Name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$' + doc!['Price'], maxLines: 1),
          ],
        ),
        trailing: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProductDescriptionScreen(
              productDetailName: widget.chatData['product']['productDetailName'],
              productDetailShopName: widget.chatData['product']['productDetailShopName'],
              productDetailPrice: widget.chatData['product']['productDetailPrice'],
              productDetailCategory: widget.chatData['product']['productDetailCategory'],
              productDetailDescription: widget.chatData['product']['productDetailDescription'],
              productDetailImages: widget.chatData['product']['productDetailImages'],
              productID: widget.chatData['product']['productID'],
              sellerID: widget.chatData['product']['sellerID'],
            )));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  Icons.visibility,
                  size: 22.0,
                  color: Colors.red[900],
                ),
                Text(
                  'View Listing',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.red[900],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}