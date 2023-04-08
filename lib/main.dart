import 'package:flutter/material.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'package:tv_show/sql/sql_helper.dart';
import 'screens/TvShowScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await SQLHelper.db();
  bool isDatabaseCreated = await SQLHelper.isDatabaseCreated();
  if (!isDatabaseCreated) {
    await SQLHelper.createTables(database);
    await SQLHelper.populateDatabase();
    await SQLHelper.setDatabaseCreated();
  }
  int initialIndex = 0; // aquí puedes definir el índice inicial deseado
  runApp(MyApp(initialIndex: initialIndex));
}

class MyApp extends StatefulWidget {
  final int initialIndex; // aquí agregamos una propiedad para el índice inicial

  MyApp(
      {required this.initialIndex}); // aquí definimos el constructor personalizado

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget
        .initialIndex; // aquí establecemos el índice inicial desde el constructor
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: PageView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _selectedIndex == 0 ? TvShow() : Favorites(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.live_tv_outlined),
                label: 'TV Shows',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorites'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.purple[800],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
