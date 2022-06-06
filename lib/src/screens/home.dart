import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/screens/productDescription.dart';
import 'package:seller_app/src/widgets/categories.dart';
import 'package:seller_app/src/widgets/navigateBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}

class _HomeScreenState extends State<HomeScreen> {

// class HomeScreen extends StatelessWidget {
  //const HomeScreen({Key? key}) : super(key: key);

  final FirebaseAuth auth = FirebaseAuth.instance;
  late var prodName = '';
  late var prodShopName='';
  late var prodPrice= '';
  late var prodDescription = '';
  late var prodCategory = '';
  late var prodImage = '';
  late String sellerName;
  //String _sellerName = (getName());

  // Future<String> getName() async {
  //   final uid = AuthService().currentUser?.uid;
  //   DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
  //   sellerName = ds.get('Name');
  //   return sellerName;
  // }

  Future<String> getName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    sellerName = ds.get('Name');
    return sellerName;
  }

  String get(Future<String> name) {
    // String seller = 'test';
    // name.then((String result) {
    //   //setState(() {
    //     seller = result.toString();
    //     print('result: ' + result);
    //     print('seller2: ' + seller);
    //   //});
    // });
    // print('seller1: ' + seller);
    // return seller;
    return 'Modern Times';
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
          'Home',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('listings')
            .where('Seller Name', isEqualTo: get(getName()))
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(
                  'My Products',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Categories(
                currentCategory: 'All Products',
              ),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: snapshot.data!.docs.map(
                    (listings) {
                      return Center(
                        child: Card(
                          child: Hero(
                            tag: Text(listings['Name']),
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  prodName = listings['Name'];
                                  prodShopName = listings['Seller Name'];
                                  prodPrice = listings['Price'];
                                  prodCategory = listings['Category'];
                                  prodDescription = listings['Description'];
                                  prodImage = listings['Image URL'];
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProductDescriptionScreen(
                                    productDetailName: prodName,
                                    productDetailShopName: prodShopName,
                                    productDetailPrice:  prodPrice,
                                    productDetailCategory: prodCategory,
                                    productDetailDescription: prodDescription,
                                    productDetailImages: prodImage,
                                  )));
                                },
                                child: GridTile(
                                  footer: Container(
                                    color: Colors.white70,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  top: 4,
                                                  bottom: 4),
                                              child: Text(
                                                listings['Name'],
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16,
                                                  top: 4,
                                                  bottom: 4),
                                              child: Text(
                                                listings['Price'],
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 4,
                                              bottom: 4),
                                          child: Text(
                                            (listings['Seller Name']),
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: (Uri.tryParse(listings['Image URL'])?.hasAbsolutePath ?? false)
                                      ? Image.network(listings['Image URL'])
                                      : Image.asset('images/noImage.jpg'),
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
