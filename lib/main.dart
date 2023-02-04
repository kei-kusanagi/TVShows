import 'package:flutter/material.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'screens/TvShowScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: TvShow(),
      home: Scaffold(
        body: PageView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            TvShow(),
            Favorites(),
          ]
        )
      )
    );
  }
}
