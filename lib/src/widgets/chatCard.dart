import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/chatConversation.dart';
import 'package:seller_app/src/screens/productDescription.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;
  ChatCard(this.chatData);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  String deleted = '';

  Future<String> del() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('listings').doc(widget.chatData['product']['productDetailId']).get();
    setState(() => deleted = ds.get('Deleted'));
    return deleted;
  }

  String getDeleted() {
    del();
    return deleted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ChatConversations(
                  chatRoomId: widget.chatData['chatRoomId'], type: 'listings'),
            ),
          );
        },
        leading: SizedBox(
          child: Image.network(
            widget.chatData['product']['productDetailImages'],
            height: 50,
            width: 50
          ),
        ),
        title: Text(widget.chatData['product']['buyerName']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatData['product']['productDetailName']),
            Text(
              '\$' + widget.chatData['product']['productDetailPrice'],
              maxLines: 1
            ),
            getDeleted() == 'true' ?
            const Text(
              '[DELETED]',
              style: TextStyle(
                color: Colors.red,
              ),
            ) :
            Container(),
          ],
        ),
        trailing: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDescriptionScreen(
                      productDetailName: widget.chatData['product']['productDetailName'],
                      productDetailShopName: widget.chatData['product']['productDetailShopName'],
                      productDetailPrice: widget.chatData['product']['productDetailPrice'],
                      productDetailCategory: widget.chatData['product']['productDetailCategory'],
                      productDetailDescription: widget.chatData['product']['productDetailDescription'],
                      productDetailImages: widget.chatData['product']['productDetailImages'],
                      productID: widget.chatData['product']['productDetailId'],
                      sellerID: widget.chatData['product']['sellerId'],
                      deleted: getDeleted(),
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
