import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/account.dart';
import 'package:seller_app/src/screens/home.dart';
import 'package:seller_app/src/screens/listing.dart';
import 'package:seller_app/src/screens/request.dart';
import 'package:seller_app/src/screens/post.dart';

class NavigateBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.black),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 52.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => ListingScreen()));
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
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => RequestScreen(type: 'Available Requests', currentCategory: 'All Requests',)));
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
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(currentCategory: 'All Products',)));
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
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => PostScreen()));
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
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => AccountScreen()));
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
    );
  }
}
