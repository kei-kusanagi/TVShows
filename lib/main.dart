import 'package:flutter/material.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'screens/TvShowScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TvShow(),
      // home: Scaffold(
      //   body: PageView(
      //     children: <Widget>[
      //       TvShow(),
      //       Favorites(),
      //     ]
      //   )
      // )
    );
  }
}
