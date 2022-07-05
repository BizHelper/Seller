import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/src/screens/listing.dart';
import 'package:seller_app/src/services/authService.dart';

class ListingForm extends StatefulWidget {
  @override
  State<ListingForm> createState() => _ListingFormState();
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

  PlatformFile? pickedImageFile;
  UploadTask? uploadTaskImage;

  late String _sellerName;
  late String _sellerID;
  late String _currentName;
  late String _currentURL;
  late String _currentPrice;
  late String _currentCategory;
  late String _currentDescription;
  bool imageSelected = false;

  showAlertDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: const Text(
        'Photo has not been selected',
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        }
    );
  }

  Future<void> getName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    _sellerName = ds.get('Name');
  }

  Future selectImageFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedImageFile = result.files.first;
      imageSelected = true;
    });
  }

  Future uploadImageFile() async {
    final path = 'files/${pickedImageFile!.name}';
    final file = File(pickedImageFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTaskImage = ref.putFile(file);
    });
    ref.putFile(file);
    uploadTaskImage = ref.putFile(file);
    final snapshot = await uploadTaskImage!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      _currentURL = urlDownload;
      uploadTaskImage = null;
      imageSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                'Add Listing',
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
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                onPressed: () async {
                  selectImageFile();
                },
                child: const Text(
                  'Select Image',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              imageSelected ?
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await uploadImageFile();

                    final uid = AuthService().currentUser?.uid;
                    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
                    _sellerName = ds.get('Name');
                    _sellerID = ds.get('Seller ID');
                    DocumentReference dr = FirebaseFirestore.instance.collection('listings').doc();
                    Map<String, Object> listing = new HashMap();
                    listing.putIfAbsent('Name', () => _currentName);
                    listing.putIfAbsent('Image URL', () => _currentURL);
                    listing.putIfAbsent('Price', () => _currentPrice);
                    listing.putIfAbsent('Category', () => _currentCategory);
                    listing.putIfAbsent('Description', () => _currentDescription);
                    listing.putIfAbsent('Listing ID', () => dr.id);
                    listing.putIfAbsent('Seller Name', () => _sellerName);
                    listing.putIfAbsent('Seller Id', () => _sellerID);
                    listing.putIfAbsent('Deleted', () => 'false');
                    listing.putIfAbsent('Price Double', () => double.parse(_currentPrice));
                    dr.set(listing);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ListingScreen()));
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.black),
                ),
              ) :
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber[600])),
                onPressed: () {
                  showAlertDialog(context);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
