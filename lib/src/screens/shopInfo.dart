import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/src/providers/locationProvider.dart';
import 'package:seller_app/src/screens/map.dart';

class ShopInfoScreen extends StatefulWidget {
  @override
  State<ShopInfoScreen> createState() => _ShopInfoScreenState();
}

class _ShopInfoScreenState extends State<ShopInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
        title: const Text(
          'Update Shop Info',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: Text('Set Your Location', style: TextStyle(fontSize: 16)),
            onPressed: () async {
              await locationData.getCurrentPosition();
              if (locationData.permissionALlowed == true) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MapScreen()));
              } else {
                print('Permission not allowed');
              }
            },
          ),
        ],
      ),
    );
  }
}
