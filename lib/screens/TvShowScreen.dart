import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:tv_show/screens/Favorites.dart';
import 'package:tv_show/api/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode, utf8;

class TvShow extends StatefulWidget {
  const TvShow({Key? key}) : super(key: key);
    @override
  State<TvShow> createState() => _TvShowState();
}

class _TvShowState extends State<TvShow> {
  String urlString = "https://api.giphy.com/v1/gifs/trending?api_key=GbT1BcYH7nEBK6r9bcmLwWIXLQKB1kTc&limit=10&rating=g";
  
  late Future<List<Gif>?> _listadoGifs;

  Future <List<Gif>?> getGifs() async {
    final response = await http.get(Uri.parse(urlString));

    List<Gif> gifs = [];

    if (response.statusCode == 200){

      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);
      for (var item in jsonData["data"]){
        gifs.add(
          Gif(item["title"], item["images"]["downsized"]["url"])
        );
      }
    return gifs;
    } else {
      throw Exception("F en el chat");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listadoGifs = getGifs();
  }

  final List<TVshow> TVShows =[
    TVshow('The Last of Us', 'tt3581920', 9.3, 'https://m.media-amazon.com/images/M/MV5BZGUzYTI3M2EtZmM0Yy00NGUyLWI4ODEtN2Q3ZGJlYzhhZjU3XkEyXkFqcGdeQXVyNTM0OTY1OQ@@._V1_UX67_CR0,0,67,98_AL_.jpg'),
    TVshow('El menu', 'tt9764362', 7.2,'https://m.media-amazon.com/images/M/MV5BMzdjNjI5MmYtODhiNS00NTcyLWEzZmUtYzVmODM5YzExNDE3XkEyXkFqcGdeQXVyMTAyMjQ3NzQ1._V1_QL75_UX280_CR0,3,280,414_.jpg'),
    TVshow('TOP GUN MAVERICK', 'tt1745960', 8.3,'https://m.media-amazon.com/images/M/MV5BZWYzOGEwNTgtNWU3NS00ZTQ0LWJkODUtMmVhMjIwMjA1ZmQwXkEyXkFqcGdeQXVyMjkwOTAyMDU@._V1_QL75_UX280_CR0,0,280,414_.jpg'),
    TVshow('Avatar: El sentido del agua', 'tt1630029', 7.8,'https://m.media-amazon.com/images/M/MV5BYjhiNjBlODctY2ZiOC00YjVlLWFlNzAtNTVhNzM1YjI1NzMxXkEyXkFqcGdeQXVyMjQxNTE1MDA@._V1_QL75_UY414_CR5,0,280,414_.jpg'),
    TVshow('Miercoles', 'tt13443470', 8.2,'https://m.media-amazon.com/images/M/MV5BMjllNDU5YjAtOGM1Zi00ZTRiLWI0OWItYjc5ZmUxODBiYTJmXkEyXkFqcGdeQXVyMTU2Mjg2NjE2._V1_QL75_UX280_CR0,0,280,414_.jpg'),
    TVshow('Mission Majnu', 'tt13131232', 7.9,'https://m.media-amazon.com/images/M/MV5BYTYwYmI0NGItYmFkYi00NzViLWIwMGEtNGNjYjQwYjY1NTQ1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_QL75_UY414_CR26,0,280,414_.jpg'),
  ];



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Tv Show's 🖥"),
          backgroundColor: Colors.purple,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.purple,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TvShow()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.tv),
                      SizedBox(width: 10,height: 50,),
                      Text("TV Show's"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Favorites()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.favorite),
                      SizedBox(width: 10,height: 50,),
                      Text("Favoritos"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: TVShows.length,
          itemBuilder: (context, index){
              return Slidable(
                key: Key(TVShows[index].toString()),
                endActionPane: const ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: doNothing,
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      icon: Icons.save,
                      label: 'Añadir a Favoritos',
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Mensaje"),
                          content: Text("desplegar pantalla de detalles"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Cerrar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );

                  },
                  leading: Image(
                     image: NetworkImage(TVShows[index].ImageLink),
                  ),
                  title: Text(TVShows[index].name),
                  subtitle: Text(TVShows[index].IMDb),
                  trailing:
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                ),
              );
            },
        ),
      ),

    );
  }
  void deleteTVshow(BuildContext context, TVshow){
    showDialog(
      context: context,
      builder: ( BuildContext context)  {
        return AlertDialog(
          title: Text("Eliminar Show"),
          content:  Text('${"¿Esta seguro de querer eliminar a " + TVshow.name}?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child:Text('Cancelar',),),
            TextButton(onPressed: (){
              if (mounted) {
                setState(() {
                  TVShows.remove(TVshow);
                });
              }
              Navigator.pop(context);
            }, child:Text('Borrar', style: TextStyle(color: Colors.red),),),
          ],
        );
      },
    );
  }
}


class TVshow{
  late String name;
  late String IMDb;
  late double Rating;
  late String ImageLink;

  TVshow(name, IMDb, Rating, ImageLink){
    this.name = name;
    this.IMDb = IMDb;
    this.Rating = Rating;
    this.ImageLink = ImageLink;

    }
}


void doNothing(BuildContext context) {}

