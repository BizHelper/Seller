import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/comments.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/screens/postForm.dart';
import 'package:seller_app/src/screens/video.dart';
import 'package:seller_app/src/widgets/navigateBar.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  String _sellerName = '';

  Future<String> getSellerName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    setState(() => _sellerName = ds.get('Name'));
    return _sellerName;
  }

  String getName() {
    getSellerName();
    return _sellerName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
        title: const Text(
          'Post',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('Seller Name', isEqualTo: getName())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Posts',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostFormScreen()));
                      },
                      child: const Text(
                        'Add New Post',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 1,
                  children: snapshot.data!.docs.map(
                    (posts) {
                      return Center(
                        child: Card(
                          child: Hero(
                            tag: Text(posts['Seller Name']),
                            child: Material(
                              child: InkWell(
                                onTap: () {},
                                child: GridTile(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Image.network(posts['Thumbnail'])
                                      ),
                                      Divider(thickness: 1.5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  posts['Title'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8, right: 16, top: 4, bottom: 4),
                                                child: Text(
                                                  'by ' + posts['Seller Name'],
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CommentsScreen(
                                                    postID: posts['Post ID'],
                                                  )));
                                                },
                                                child: const Text('Add Comment'),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VideoScreen(
                                                  videoURL: posts['URL'],
                                                  description: posts['Description'],
                                                  postID: posts['Post ID'],
                                                )));
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.info,
                                                    size: 28.0,
                                                    color: Colors.red[900],
                                                  ),
                                                  Text(
                                                    'Find out more!',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red[900],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              NavigateBar(),
            ],
          );
        },
      ),
    );
  }
}
