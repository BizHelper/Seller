import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/widgets/post.dart';

final commentRef = FirebaseFirestore.instance.collection('comments');
late CollectionReference buyersRef =
    FirebaseFirestore.instance.collection('buyers');
final FirebaseAuth _auth = FirebaseAuth.instance;

class CommentsScreen extends StatefulWidget {
  final String postID;

  CommentsScreen({required this.postID});

  @override
  State<CommentsScreen> createState() => CommentsScreenState();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}

class CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  buildComments() {
    return StreamBuilder(
        stream:
            commentRef.doc(widget.postID).collection('comments').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          List<Comment> comments = [];
          snapshot.data!.docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView(children: comments);
        });
  }

  addComment() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    String sellerName = ds.get('Name');
    String profilePic = ds.get('Profile Pic');

    commentRef.doc(widget.postID).collection("comments").add(
      {
        "comment": commentController.text,
        "userId": _auth.currentUser!.uid,
        "name": sellerName,
        "profilePic": profilePic,
      },
    );
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => PostScreen()));
          },
        ),
        title: const Text(
          'Comment Section',
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: " Write a comment..."),
            ),
            trailing: OutlinedButton(
                onPressed: () => addComment(), child: Text("Post")),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userId;
  final String comment;
  final String name;
  final String profilePic;

  Comment({
    required this.userId,
    required this.comment,
    required this.name,
    required this.profilePic,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      userId: doc['userId'],
      comment: doc['comment'],
      name: doc['name'],
      profilePic: doc['profilePic'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Container(width: 50, child: Image.network(profilePic)),
          Text(
            "  " + name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text("  " + comment, style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
