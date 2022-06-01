import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/products.dart';
import 'package:seller_app/src/screens/account.dart';
import 'package:seller_app/src/screens/listing.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/screens/post.dart';
import 'package:seller_app/src/screens/request.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 11.0, top: 12),
            child: Text(
              'My Products',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: Colors.amber,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'All Products',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: Colors.orange,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'Bags & Wallets',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: Colors.orange,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'Female Clothing',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: Colors.orange,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'Male Clothing',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: Colors.orange,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'Food & Beverage',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: Colors.orange,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'Accessories',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: Colors.orange,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      'Toys & Games',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  color: Colors.orange,
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      '   Others   ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Flexible(
            child: Products(),
          ),
          Column(
            children: [
              const Divider(
                color: Colors.black,
                height: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 52.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ListingScreen()));
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.add_to_photos),
                            Text('Listing'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 52.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RequestScreen()));
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.sticky_note_2),
                            Text('Request'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 52.0,
                      child: InkWell(
                        onTap: () {

                        },
                        child: Column(
                          children: const [
                            Icon(Icons.home),
                            Text('Home'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 52.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PostScreen()));
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.camera_alt),
                            Text('Post'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 52.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AccountScreen()));
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.account_box),
                            Text('Account'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
