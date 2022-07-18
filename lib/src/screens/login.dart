import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/src/services/auth.dart';
import 'package:seller_app/src/screens/home.dart';
import 'package:seller_app/src/screens/reset.dart';
import 'package:seller_app/src/screens/signup.dart';
import 'package:seller_app/src/services/authService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _email;
  var _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
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
              "Seller Login",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                key: Key('enterEmail'),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() => _email = value.trim());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                key: Key('enterPassword'),
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() => _password = value.trim());
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  key: Key('signIn'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orange[600]),
                  ),
                  onPressed: () async {
                    String? result = await Auth(auth: AuthService().auth).signin(_email, _password);
                    if (result == 'Success') {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(
                        currentCategory: 'All Products',)));
                    } else {
                      Fluttertoast.showToast(msg: result ?? '', gravity: ToastGravity.TOP);
                    }
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange[600])),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Forgot Password?'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
