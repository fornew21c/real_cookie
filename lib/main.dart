import 'package:flutter/material.dart';
import 'package:real_cookie/constants.dart';
import 'package:real_cookie/item_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeSharedPreferences();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      home: ItemListPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}