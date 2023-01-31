import 'package:flutter/material.dart';

class TvShow extends StatelessWidget {
  const TvShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tv Show'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
