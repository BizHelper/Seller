import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/home.dart';
import 'package:seller_app/src/services/authService.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  var user;
  var timer;

  @override
  void initState() {
    user = AuthService().auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() { //?
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('An email has been sent to ${user.email}. Please verify. (check spam folder)'),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = AuthService().auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(currentCategory: 'All Products',)), (Route<dynamic> route) => false);
    }
  }
}
