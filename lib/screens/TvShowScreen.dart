import 'dart:ffi';

import 'package:flutter/material.dart';

class TvShow extends StatefulWidget {
  const TvShow({Key? key}) : super(key: key);

  @override
  State<TvShow> createState() => _TvShowState();
}

class _TvShowState extends State<TvShow> {


  List<TVshow> _TVShows =[
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
          title: Text('Tv Show'),
          backgroundColor: Colors.purple,
        ),
        body: ListView.builder(
          itemCount: _TVShows.length,
            itemBuilder: (context, index){
              return Dismissible(
                key: Key(_TVShows[index].toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  print('BORRAR');
                },
                child: ListTile(
                  onTap: (){
                    print(_TVShows[index].name);
                },
                  
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_TVShows[index].ImageLink),
                  ),
                  title: Text(_TVShows[index].name),
                  subtitle: Text(_TVShows[index].IMDb),
                  trailing:
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 5),
                      Text(_TVShows[index].Rating.toString()),
                    ],
                  ),


                ),
              );
            },
        ),
      ),

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
