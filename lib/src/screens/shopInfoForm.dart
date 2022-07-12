import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/account.dart';
import 'package:seller_app/src/screens/map.dart';
import 'package:seller_app/src/services/authService.dart';

class ShopInfoFormScreen extends StatefulWidget {
  var hasShop;
  var name;
  var address;
  var description;

  ShopInfoFormScreen({required this.hasShop, required this.name, required this.address, required this.description});

  @override
  State<ShopInfoFormScreen> createState() => _ShopInfoFormScreenState();
}

class _ShopInfoFormScreenState extends State<ShopInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _currentAddress;
  late String _currentDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
        title: const Text(
          'Add Shop Details',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MapScreen(
                hasShop: widget.hasShop,
                name: widget.name,
                address: widget.address,
                description: widget.description,
              ))),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Address',
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
                  validator: (val) => val!.isEmpty ? 'Please enter an address' : null,
                  onChanged: (val) => setState(() => _currentAddress = val),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Shop Description',
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
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final uid = AuthService().currentUser?.uid;
                      DocumentReference dr = FirebaseFirestore.instance.collection('sellers').doc(uid);
                      dr.update({'Address' : _currentAddress});
                      dr.update({'Description' : _currentDescription});
                      dr.update({'hasShop' : 'true'});
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AccountScreen()),
                            (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
