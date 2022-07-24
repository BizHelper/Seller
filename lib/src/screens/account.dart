import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/screens/shopInfo.dart';
import 'package:seller_app/src/services/authService.dart';
import 'package:seller_app/src/widgets/navigateBar.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _sellerName = '';
  var _image = 'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';

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

  Future<String> getImageFile() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    setState(() {
      if ((ds.data() as Map<String, dynamic>).containsKey('Profile Pic')) {
        _image = ds.get('Profile Pic');
      }
    });
    return _image;
  }

  String getImage() {
    getImageFile();
    return _image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          'Account',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.network(getImage()).image,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    getName(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                        onPressed: () async {
                          final uid = AuthService().currentUser?.uid;
                          DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
                          String hasShop = ds.get('hasShop');
                          String name = ds.get('Name');
                          String address = '';
                          String description = '';
                          if (hasShop == 'true') {
                            address = ds.get('Address');
                            description = ds.get('Description');
                          }
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ShopInfoScreen(
                                hasShop: hasShop,
                                name: name,
                                address: address,
                                description: description,
                              )));
                        },
                        child: const Text(
                          'Update Shop Info',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                        onPressed: () async {
                          final uid = AuthService().currentUser?.uid;
                          DocumentReference dr = FirebaseFirestore.instance.collection('sellers').doc(uid);
                          final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (pickedFile == null) {
                            return;
                          }
                          final File image = (File(pickedFile.path));

                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference ref = storage.ref().child(pickedFile.path + DateTime.now().toString());
                          await ref.putFile(image);
                          String imageURL = await ref.getDownloadURL();
                          dr.update({
                            'Profile Pic': imageURL
                          });
                          setState(() => _image = imageURL);
                        },
                        child: const Text(
                          'Change Profile Picture',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          NavigateBar(),
        ],
      ),
    );
  }
}
