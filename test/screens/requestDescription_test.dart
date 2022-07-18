import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seller_app/src/screens/requestDescription.dart';

import '../mock.dart';

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();

  testWidgets('available request', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: RequestDescriptionScreen(
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
        iconButton: true,
      )
    ));

    expect(find.text('title'), findsOneWidget);
    expect(find.text('\$1.00'), findsOneWidget);
    expect(find.text('by buyer name'), findsOneWidget);
    expect(find.text('Deadline: deadline'), findsOneWidget);
    expect(find.text('description'), findsOneWidget);
    expect(find.text('Accept Request'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Mark Completed'), findsNothing);
  });

  testWidgets('my request', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: RequestDescriptionScreen(
          accepted: 'true',
          buyerID: 'buyer id',
          buyerName: 'buyer name',
          category: 'category',
          deadline: 'deadline',
          deleted: 'false',
          description: 'description',
          price: '1.00',
          requestID: 'request id',
          sellerName: 'seller name',
          title: 'title',
          iconButton: true,
        )
    ));

    expect(find.text('title'), findsOneWidget);
    expect(find.text('\$1.00'), findsOneWidget);
    expect(find.text('by buyer name'), findsOneWidget);
    expect(find.text('Deadline: deadline'), findsOneWidget);
    expect(find.text('description'), findsOneWidget);
    expect(find.text('Accept Request'), findsNothing);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Mark Completed'), findsOneWidget);
  });

  testWidgets('completed request', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: RequestDescriptionScreen(
          accepted: 'true',
          buyerID: 'buyer id',
          buyerName: 'buyer name',
          category: 'category',
          deadline: 'deadline',
          deleted: 'false',
          description: 'description',
          price: '1.00',
          requestID: 'request id',
          sellerName: 'seller name',
          title: 'title',
          iconButton: false,
        )
    ));

    expect(find.text('title'), findsOneWidget);
    expect(find.text('\$1.00'), findsOneWidget);
    expect(find.text('by buyer name'), findsOneWidget);
    expect(find.text('Deadline: deadline'), findsOneWidget);
    expect(find.text('description'), findsOneWidget);
    expect(find.text('Accept Request'), findsNothing);
    expect(find.text('Chat'), findsNothing);
    expect(find.text('Mark Completed'), findsNothing);
  });
}

