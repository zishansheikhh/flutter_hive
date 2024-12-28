import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/splash_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('formData');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form and List App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
