import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/src/screens/verify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _email;
  var _password;
  var _shopName;
  var userID;
  final auth = FirebaseAuth.instance;
  FirebaseFirestore fstore = FirebaseFirestore.instance;

  Future<bool> checkUsername(String username) async {
    final result = await FirebaseFirestore.instance.collection('sellers')
        .where('Name', isEqualTo: _shopName)
        .get();
    return result.docs.isEmpty;
  }

  showAlertDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: Text(
        'Shop Name has been taken',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
        title: const Text(
          'BizHelper',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Icon(
              Icons.store_rounded,
              size: 120,
              color: Colors.black,
            ),
            const Text(
              "Seller Sign Up",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Shop Name'),
                onChanged: (value) {
                  setState(() {
                    _shopName = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.orange[600])),
                  onPressed: () async {
                    final isUnique = await checkUsername(_shopName);
                    print(isUnique);
                    if (!isUnique) {
                      showAlertDialog(context);
                    } else {
                      _signup(_email, _password);
                    }
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _signup(String _email, String _password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(
          email: _email, password: _password);

      userID = auth.currentUser!.uid;
      DocumentReference documentReference = fstore.collection("sellers").doc(userID);
      Map<String, Object> user = new HashMap();
      user.putIfAbsent('Name', () => _shopName);
      documentReference.set(user);

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyScreen()));
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message!, gravity: ToastGravity.TOP);
    }
  }

}
