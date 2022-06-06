import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListingForm extends StatefulWidget {
  const ListingForm({Key? key}) : super(key: key);

  @override
  State<ListingForm> createState() => _ListingFormState();
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}

class _ListingFormState extends State<ListingForm> {
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
  late String _currentName;
  late String _currentURL;
  late String _currentPrice;
  late String _currentCategory;
  late String _currentDescription;

  Future<void> getName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    _sellerName = ds.get('Name');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Add Listing',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Product Name',
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
            validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
            onChanged: (val) => setState(() => _currentName = val),
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
              hintText: 'Price',
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
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
            validator: (val) => val!.isEmpty ? 'Please enter a price' : null,
            onChanged: (val) => setState(() => _currentPrice = double.parse(val).toStringAsFixed(2)),
          ),
          const SizedBox(
            height: 20.0,
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              hintText: 'Category',
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
            validator: (val) => val == null ? 'Please select category' : null,
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text('$category'),
              );
            }).toList(),
            onChanged: (val) => setState(() => _currentCategory = val.toString()),
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
                  DocumentReference dr = FirebaseFirestore.instance.collection('listings').doc();
                  Map<String, Object> listing = new HashMap();
                  listing.putIfAbsent('Name', () => _currentName);
                  listing.putIfAbsent('Image URL', () => _currentURL);
                  listing.putIfAbsent('Price', () => _currentPrice);
                  listing.putIfAbsent('Category', () => _currentCategory);
                  listing.putIfAbsent('Description', () => _currentDescription);
                  listing.putIfAbsent('Seller Name', () => _sellerName);
                  dr.set(listing);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
