import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/src/providers/locationProvider.dart';
import 'package:seller_app/src/screens/map.dart';

class ShopInfoScreen extends StatefulWidget {
  var hasShop;
  var name;
  var address;
  var description;

  ShopInfoScreen({required this.hasShop, required this.name, required this.address, required this.description});

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
          'Shop Info',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: widget.hasShop == 'true' ?
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'Address:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                widget.address,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'Shop Description:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
                    onPressed: () async {
                      await locationData.getCurrentPosition();
                      if (locationData.permissionALlowed == true) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => MapScreen(
                              hasShop: widget.hasShop,
                              name: widget.name,
                              address: widget.address,
                              description: widget.description,
                            )));
                      } else {
                        print('Permission not allowed');
                      }
                    },
                    child: const Text(
                      'Change Shop Details',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ) :
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
              onPressed: () async {
                await locationData.getCurrentPosition();
                if (locationData.permissionALlowed == true) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MapScreen(
                        hasShop: widget.hasShop,
                        name: widget.name,
                        address: widget.address,
                        description: widget.description,
                      )));
                } else {
                  print('Permission not allowed');
                }
              },
              child: const Text(
                'Add Shop Details',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
