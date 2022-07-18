import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seller_app/src/widgets/singleRequest.dart';

import '../mock.dart';

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();

  testWidgets('single request', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: SingleRequest(
          accepted: 'false',
          buyerID: 'buyer id',
          buyerName: 'buyer name',
          category: 'category',
          deadline: 'deadline',
          deleted: 'false',
          description: 'description',
          price: '1.00',
          requestID: 'request id',
          sellerName: 'null',
          title: 'title',
        )
    ));

    expect(find.text('title'), findsOneWidget);
    expect(find.text('Price: \$1.00'), findsOneWidget);
    expect(find.text('By: buyer name'), findsOneWidget);
    expect(find.text('Deadline: deadline'), findsOneWidget);
    expect(find.text('Find out more!'), findsOneWidget);
  });
}