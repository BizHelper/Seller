import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:seller_app/src/screens/productDescription.dart';

import '../mock.dart';

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();

  testWidgets('product description', (widgetTester) async {
    await mockNetworkImagesFor(() => widgetTester.pumpWidget(MaterialApp(
        home: ProductDescriptionScreen(
          productDetailName: 'name',
          productDetailShopName: 'shop name',
          productDetailPrice: '1.00',
          productDetailCategory: 'category',
          productDetailDescription: 'description',
          productDetailImages: 'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
          productID: 'id',
          sellerID: 'seller id',
          deleted: 'false'
        )
    )));

    expect(find.text('name'), findsOneWidget);
    expect(find.text('\$1.00'), findsOneWidget);
    expect(find.text('by: shop name'), findsOneWidget);
    expect(find.text('description'), findsOneWidget);
    expect(find.text('Delete Listing'), findsOneWidget);
  });
}