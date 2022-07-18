import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seller_app/src/screens/home.dart';
import 'package:seller_app/src/screens/login.dart';

import '../mock.dart';

// class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  // NavigatorObserver mockObserver = MockNavigatorObserver();

  final enterEmail = find.byKey(ValueKey("enterEmail"));
  final enterPassword = find.byKey(ValueKey("enterPassword"));
  // final signInButton = find.byKey(ValueKey("signInButton"));


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
    // await tester.tap(signInButton);

    // verify(mockObserver.didPush(, any));

    // await tester.pump;
    // await tester.pump;
    //
    // expect(find.byType(HomeScreen), findsOneWidget);

    expect(find.text("hioksurebye@gmail.com"),findsOneWidget);
    expect(find.text("bizhelper00"),findsOneWidget);
    expect(find.text("Seller Login"), findsOneWidget);
  });
}