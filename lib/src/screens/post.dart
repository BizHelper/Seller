import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/screens/postForm.dart';
import 'package:seller_app/src/screens/video.dart';
import 'package:seller_app/src/services/authService.dart';
import 'package:seller_app/src/widgets/navigateBar.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String _sellerName = '';
  List allResults = [];
  late Future resultsLoaded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getPostList();
  }

  getPostList() async {
    await getSellerName();
    var data = FirebaseFirestore.instance
        .collection('posts')
        .where('Seller Name', isEqualTo: _sellerName);
    var sortedData = await data.orderBy('Time', descending: true).get();
    setState(() => allResults = sortedData.docs);
    return sortedData.docs;
  }

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
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().auth.signOut();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PostFormScreen()));
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
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              itemCount: allResults.length,
              itemBuilder: (BuildContext context, int index) => Center(
                child: Card(
                  child: Hero(
                    tag: Text(allResults[index]['Seller Name']),
                    child: Material(
                      child: InkWell(
                        onTap: () {},
                        child: GridTile(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Image.network(allResults[index]['Thumbnail']),
                              ),
                              Divider(thickness: 1.5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            allResults[index]['Title'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 16,
                                              top: 4,
                                              bottom: 8
                                          ),
                                          child: Text(
                                            'by ' + allResults[index]['Seller Name'],
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, bottom: 16.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoScreen(
                                                      videoURL: allResults[index]['URL'],
                                                      description: allResults[index]['Description'],
                                                      postID: allResults[index]['Post ID'],
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
              ),
            ),
          ),
          NavigateBar(),
        ],
      ),
    );
  }
}
