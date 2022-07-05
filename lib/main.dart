import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/src/app.dart';
import 'package:seller_app/src/providers/locationProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_)=> LocationProvider())],
      child: App()));
}
