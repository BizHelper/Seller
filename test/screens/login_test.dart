import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seller_app/src/screens/login.dart';

import '../mock.dart';

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();

  final enterEmail = find.byKey(ValueKey("enterEmail"));
  final enterPassword = find.byKey(ValueKey("enterPassword"));

  Widget makeTestableWidget({required Widget child}){
    return MaterialApp(
      home: child,
    );
  }
  testWidgets('testing', (WidgetTester tester) async{
    LoginScreen loginScreen = LoginScreen();
    await tester.pumpWidget(makeTestableWidget(child:loginScreen));
    await tester.enterText(enterEmail, "hioksurebye@gmail.com");
    await tester.enterText(enterPassword, "bizhelper00");

    expect(find.text("hioksurebye@gmail.com"),findsOneWidget);
    expect(find.text("bizhelper00"),findsOneWidget);
    expect(find.text("Seller Login"), findsOneWidget);
  });
}