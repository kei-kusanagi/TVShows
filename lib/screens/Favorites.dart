import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'TvShowScreen.dart';


class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final List<TVshow> TVShows =[
    TVshow('The Last of Us', 'tt3581920', 9.3, 'https://m.media-amazon.com/images/M/MV5BZGUzYTI3M2EtZmM0Yy00NGUyLWI4ODEtN2Q3ZGJlYzhhZjU3XkEyXkFqcGdeQXVyNTM0OTY1OQ@@._V1_UX67_CR0,0,67,98_AL_.jpg'),
    TVshow('TOP GUN MAVERICK', 'tt1745960', 8.3,'https://m.media-amazon.com/images/M/MV5BZWYzOGEwNTgtNWU3NS00ZTQ0LWJkODUtMmVhMjIwMjA1ZmQwXkEyXkFqcGdeQXVyMjkwOTAyMDU@._V1_QL75_UX280_CR0,0,280,414_.jpg'),
    TVshow('Avatar: El sentido del agua', 'tt1630029', 7.8,'https://m.media-amazon.com/images/M/MV5BYjhiNjBlODctY2ZiOC00YjVlLWFlNzAtNTVhNzM1YjI1NzMxXkEyXkFqcGdeQXVyMjQxNTE1MDA@._V1_QL75_UY414_CR5,0,280,414_.jpg'),
    TVshow('Miercoles', 'tt13443470', 8.2,'https://m.media-amazon.com/images/M/MV5BMjllNDU5YjAtOGM1Zi00ZTRiLWI0OWItYjc5ZmUxODBiYTJmXkEyXkFqcGdeQXVyMTU2Mjg2NjE2._V1_QL75_UX280_CR0,0,280,414_.jpg'),

  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tv Show'),
          backgroundColor: Colors.purple,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.purple,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple),
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
                      SizedBox(width: 10),
                      Text("TV Show's"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple),
                  onPressed: () {
                    // acción del segundo botón
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.favorite),
                      SizedBox(width: 10),
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
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(TVShows[index].toString()),
              startActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      deleteTVshow(context, TVShows[index]);
                    },
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
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
                onTap: () {
                  // print(TVShows[index].name);
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(TVShows[index].ImageLink),
                ),
                title: Text(TVShows[index].name),
                subtitle: Text(TVShows[index].IMDb),
                trailing:
                // const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.yellow),
                    const SizedBox(width: 5),
                    Text(TVShows[index].Rating.toString()),
                  ],
                ),
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
          content:  Text("¿Esta seguro de querer eliminar a " + TVshow.name + '?'),
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