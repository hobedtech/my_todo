import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/provider/BottomNavBarProvider.dart';
import 'package:my_todo/provider/PageProvider.dart';
import 'package:my_todo/view/TodoPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planlarım',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.pink[700]),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedIconTheme: IconThemeData(color: Colors.pink[700]),
            unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
            selectedLabelStyle: TextStyle(color: Colors.black),
            unselectedLabelStyle: TextStyle(color: Colors.black)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<ItemStateProvider>(
              create: (_) => ItemStateProvider()),
          ChangeNotifierProvider<BottomNavBarProvider>(
              create: (_) => BottomNavBarProvider())
        ],
        child: TodoPage(),
      ),
    );
  }
}
