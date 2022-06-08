import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({Key? key}) : super(key: key);

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categories = [
    'Bags & Wallets',
    'Women\'s Clothes',
    'Men\'s Clothes',
    'Food & Beverage',
    'Accessories',
    'Toys & Games',
    'Others'
  ];

  late String _sellerName;
  late String _currentDescription;
  late String _currentURL;

  Future<void> getName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    _sellerName = ds.get('Name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
        title: const Text(
          'Add Post',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Add Post',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Image URL',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange.shade600,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Please insert image URL' : null,
                onChanged: (val) => setState(() => _currentURL = val),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Description',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange.shade600,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
                onChanged: (val) => setState(() => _currentDescription = val),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final uid = AuthService().currentUser?.uid;
                    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
                    _sellerName = ds.get('Name');
                    DocumentReference dr = FirebaseFirestore.instance.collection('posts').doc();
                    Map<String, Object> post = new HashMap();
                    post.putIfAbsent('Image URL', () => _currentURL);
                    post.putIfAbsent('Description', () => _currentDescription);
                    post.putIfAbsent('Post ID', () => dr.id);
                    post.putIfAbsent('Seller Name', () => _sellerName);
                    dr.set(post);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
