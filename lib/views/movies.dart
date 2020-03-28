import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'movie.dart';

class Movies extends StatelessWidget {
  Future getMovies() async {
    http.Response data = await http.get(
        "http://api.themoviedb.org/3/movie/popular?api_key=802b2c4b88ea1183e50e6b285a27696e");
    var moviesList = jsonDecode(data.body);
    print(moviesList);
    return moviesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Movies"),
        ),
        body: FutureBuilder(
          future: getMovies(), // async work
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return Center(child: Text('No Internet'));
                else
                  return ListView.builder(
                      itemCount: snapshot.data["results"].length,
                      itemBuilder: (context, index) {
                        var moviesData = snapshot.data["results"][index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Movie(movieData: moviesData))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Hero(
                                tag: moviesData["id"],
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("assets/logo.png"),
                                          fit: BoxFit.fill)),
                                  margin: EdgeInsets.all(10),
                                  height: 100,
                                  width: 100,
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w1280${moviesData['poster_path']}",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    child: Text(
                                      moviesData["title"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                          "${moviesData['vote_average']} / 10 ( ${moviesData['vote_count']} )")
                                    ],
                                  )
                                ],
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        );
                      });
            }
          },
        ));
  }
}
