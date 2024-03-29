import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/home.dart';

class ProductDescriptionScreen extends StatelessWidget {
  var productDetailName;
  var productDetailShopName;
  var productDetailPrice;
  var productDetailCategory;
  var productDetailDescription;
  var productDetailImages;
  var productID;
  var sellerID;
  var deleted;

  ProductDescriptionScreen({
      this.productDetailName,
      this.productDetailShopName,
      this.productDetailPrice,
      this.productDetailCategory,
      this.productDetailDescription,
      this.productDetailImages,
      this.productID,
      this.sellerID,
      required this.deleted
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade900,
        title: const Text(
          'Product Description',
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Image.network(this.productDetailImages),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        productDetailName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '\$$productDetailPrice',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'by: $productDetailShopName',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                        'Description:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        productDetailDescription,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              deleted == 'true'?
                  const Text(
                    '[DELETED]',
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ) :
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        DocumentReference dr = FirebaseFirestore.instance.collection('listings').doc(productID);
                        dr.update({'Deleted' : 'true'});
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(currentCategory: 'All Products',)));
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 28.0,
                            color: Colors.red[900],
                          ),
                          Text(
                            'Delete Listing',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
