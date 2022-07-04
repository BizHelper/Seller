import 'package:flutter/material.dart';
import 'package:seller_app/src/services/authService.dart';
import 'package:seller_app/src/widgets/listingForm.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/widgets/navigateBar.dart';

class ListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
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
          'Listing',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: screenHeight - keyboardHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListingForm(),
                  ),
              ),
            ),
            NavigateBar(),
          ],
        ),
      ),
    );
  }
}
