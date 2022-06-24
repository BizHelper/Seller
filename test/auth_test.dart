// import 'package:buyer_app/src/auth.dart';
// import 'package:buyer_app/src/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:seller_app/src/services/auth.dart';

import 'auth_test.mocks.dart';
//import 'package:mocktail/mocktail.dart';


class UserMock extends Mock implements User {}
@GenerateMocks([FirebaseAuth])
void main() {
  @GenerateMocks([UserMock])
  // final UserMock _mockUser = UserMock();
  // @override
  // Stream<User> authStateChanges() {
  //   return Stream.fromIterable([
  //     _mockUser,
  //   ]);
  // }
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  //final Auth userAuth = Auth(auth: mockFirebaseAuth);
  //tearDown(() {});

  group('Sign in', () {
    // test("valid sign in", () async {
    //   when(
    //     mockFirebaseAuth.signInWithEmailAndPassword(
    //         email: "abc@gmail.com", password: "bizhelper00"),
    //   ).thenAnswer((_) async => "Success";
    //   expect(await Auth(auth: mockFirebaseAuth).signin("abc@gmail.com", "bizhelper00"),
    //       "Success");
    // });

    test("no email address", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "", password: "bizhelper00"),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "Please enter your email address", code: "No email"),);
      expect(await Auth(auth: mockFirebaseAuth).signin("", "bizhelper00"),
          "Please enter your email address");
    });

    test("no password", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "abc@gmail.com", password: ""),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "Please enter your password", code: "No password"),);
      expect(await Auth(auth: mockFirebaseAuth).signin("abc@gmail.com", ""),
          "Please enter your password");
    });

    test("invalid email", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "abc", password: "bizhelper00"),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "The email address is badly formatted",
          code: "Invalid email"),);
      expect(await Auth(auth: mockFirebaseAuth).signin("abc", "bizhelper00"),
          "The email address is badly formatted");
    });

    test("incorrect password", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "abc@gmail.com", password: "bizhelper"),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "Password is invalid", code: "Incorrect password"),);
      expect(await Auth(auth: mockFirebaseAuth).signin(
          "abc@gmail.com", "bizhelper"),
          "Password is invalid");
    });

    test("email not registered", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "abc@gmail.com", password: "bizhelper"),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "Email is not registered", code: "Email not registered"),);
      expect(await Auth(auth: mockFirebaseAuth).signin(
          "abc@gmail.com", "bizhelper"),
          "Email is not registered");
    });
  });
  
  group('Sign up', () {
    // test("valid sign in", () async {
    //   when(
    //     mockFirebaseAuth.signInWithEmailAndPassword(
    //         email: "abc@gmail.com", password: "bizhelper00"),
    //   ).thenAnswer((_) async => "Success";
    //   expect(await Auth(auth: mockFirebaseAuth).signin("abc@gmail.com", "bizhelper00"),
    //       "Success");
    // });

    test("no email address", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "", password: "bizhelper00"),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "Please enter your email address", code: "No email"),);
      expect(await Auth(auth: mockFirebaseAuth).signup("", "bizhelper00"),
          "Please enter your email address");
    });

    test("no password", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "abc@gmail.com", password: ""),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "Please enter your password", code: "No password"),);
      expect(await Auth(auth: mockFirebaseAuth).signup("abc@gmail.com", ""),
          "Please enter your password");
    });

    test("invalid email", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "abc", password: "bizhelper00"),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "The email address is badly formatted", code: "Invalid email"),);
      expect(await Auth(auth: mockFirebaseAuth).signup("abc", "bizhelper00"),
          "The email address is badly formatted");
    });

    test("incorrect password", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "abc@gmail.com", password: "bizhelper"),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "Password is invalid", code: "Incorrect password"),);
      expect(await Auth(auth: mockFirebaseAuth).signup("abc@gmail.com", "bizhelper"),
          "Password is invalid");
    });

    test("email not registered", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "abc@gmail.com", password: "bizhelper"),
      ).thenAnswer((_) async =>
      throw FirebaseAuthException(
          message: "Email is not registered", code: "Email not registered"),);
      expect(await Auth(auth: mockFirebaseAuth).signup("abc@gmail.com", "bizhelper"),
          "Email is not registered");
    });
  });
}