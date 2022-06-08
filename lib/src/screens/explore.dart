import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/screens/postForm.dart';
import 'package:seller_app/src/widgets/navigateBar.dart';
import 'package:seller_app/src/widgets/post.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}

class _ExploreScreenState extends State<ExploreScreen> {

  final auth = FirebaseAuth.instance;
  String _sellerName = '';

  Future<String> getSellerName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
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
      backgroundColor: Colors.blueGrey[100],
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
          stream: FirebaseFirestore.instance.collection('posts')
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
                            backgroundColor:
                            MaterialStateProperty.all(Colors.orange[600])),
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
                        return Post(
                          shopName: posts['Seller Name'],
                          description: posts['Description'],
                          image: posts['Image URL'],
                          postID: posts['Post ID'],
                        );
                      },
                    ).toList(),
                  ),
                ),
                NavigateBar(),
              ],
            );
          }
      ),
    );
  }
}
