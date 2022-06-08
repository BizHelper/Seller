import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/comments.dart';

class Post extends StatelessWidget {
  var shopName;
  var description;
  var image;
  var postID;

  Post({
    this.shopName,
    this.description,
    this.image,
    this.postID
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Hero(
          tag: Text(shopName),
          child: Material(
            child: InkWell(
              onTap: () {
              },
              child: GridTile(
                footer: Container(
                  color: Colors.white70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 4,
                            bottom: 4),
                        child: Text(
                          'by $shopName',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CommentsScreen(
                            postID: postID,
                          )));
                        },
                        child: const Text(
                          'Add Comment'
                        ),
                      ),
                    ],
                  ),
                ),
                child: (Uri.tryParse(image)?.hasAbsolutePath ?? false)
                    ? Image.network(image)
                    : Image.asset('images/noImage.jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}