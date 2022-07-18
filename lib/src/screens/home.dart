import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/chat.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/services/authService.dart';
import 'package:seller_app/src/widgets/categories.dart';
import 'package:seller_app/src/widgets/navigateBar.dart';
import 'package:seller_app/src/widgets/product.dart';

class HomeScreen extends StatefulWidget {
  var currentCategory;

  HomeScreen({required this.currentCategory});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _sellerName = '';
  List allResults = [];
  late Future resultsLoaded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getListingList();
  }

  getListingList() async {
    await getSellerName();
    var data = widget.currentCategory == 'All Products'
        ? FirebaseFirestore.instance
            .collection('listings')
            .where('Seller Name', isEqualTo: _sellerName)
            .where('Deleted', isEqualTo: 'false')
        : FirebaseFirestore.instance
            .collection('listings')
            .where('Category', isEqualTo: widget.currentCategory)
            .where('Seller Name', isEqualTo: _sellerName)
            .where('Deleted', isEqualTo: 'false');
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
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ChatScreen()));
            },
          ),
          IconButton(
            key: Key('signOut'),
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().auth.signOut();
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
      body: Column(
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
            currentCategory: widget.currentCategory,
            currentPage: 'Home',
          ),
          Flexible(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: allResults.length,
              itemBuilder: (BuildContext context, int index) => Product(
                prodName: allResults[index]['Name'],
                prodShopName: allResults[index]['Seller Name'],
                prodPrice: allResults[index]['Price'],
                prodCategory: allResults[index]['Category'],
                prodDescription: allResults[index]['Description'],
                prodImage: allResults[index]['Image URL'],
                prodID: allResults[index]['Listing ID'],
                sellerID: allResults[index]['Seller Id'],
                deleted: allResults[index]['Deleted'],
              ),
            ),
          ),
          NavigateBar(),
        ],
      ),
    );
  }
}
