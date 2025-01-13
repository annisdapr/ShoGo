import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shogo/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:shogo/widgets/movie_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Movie> _movies = [];
  int _page = 1;
  void initState(){
    super.initState();
    populateMovies(_page);
  }

  Future<List<Movie>> _fetchMovies(int page) async{
    final response = await http.get(Uri.parse('https://www.episodate.com/api/most-popular?page=1'));
    if(response.statusCode ==200){
      final result = jsonDecode(response.body);
      Iterable list = result['tv_shows'];
      return list.map((e) => Movie.fromJson(e)).toList();
    }
    else{
      throw Exception('failed');
    }
  }

  void populateMovies(int page) async{
    final myMovies = await _fetchMovies(page);
    setState(() {
      _movies.addAll(myMovies);
    });
    _page+=1;
    print("populating"+ page.toString());
  }

  @override
  Widget build(BuildContext context) {

    final ScrollController _controller = ScrollController();
    _controller.addListener((){
      if(_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange){
        setState(() {
          populateMovies(_page);
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('ShoGo'),
      ), // AppBar
      body: _movies.isEmpty? const Center(child: CircularProgressIndicator(),)
          :GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 30,
        ),
        itemBuilder: (ctx, i)=> MovieItem(
            _movies[i].id,
            _movies[i].image,
            _movies[i].title
        ),
        itemCount: _movies.length,
        padding: const EdgeInsets.all(10),
        controller: _controller,
      ),
      // Center
    ); // Scaffold
  }
}