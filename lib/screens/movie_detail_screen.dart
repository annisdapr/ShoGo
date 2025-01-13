import 'dart:convert';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatelessWidget {
  static const routeName = 'movie_detail_screen';
  const MovieDetailScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchDetails(String id) async {
    final response = await http.get(Uri.parse('https://www.episodate.com/api/show-details?q=$id'));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final list = result['tvShow'];

      final htmlDescription = list['description'];
      final document = parse(htmlDescription);
      final description = parse(document.body!.text).documentElement!.text;

      return {
        'id': list['id'],
        'title': list['name'],
        'description': description,
        'start': list['start_date'],
        'status': list['status'],
        'imageUrl': list['image_thumbnail_path'],
        'rating': list['rating'],
        'genres': list['genres'],
      };
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieId = ModalRoute.of(context)!.settings.arguments.toString();
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchDetails(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final data = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(data['title']),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster
                    Image.network(
                      data['imageUrl'],
                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rating
                          Row(
                            children: [
                              const Text(
                                'Rating',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              CircleAvatar(
                                backgroundColor: const Color(0xFFFFC400),
                                child: Text(
                                  double.parse(data['rating'].toString()).toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Genres
                          Text(
                            'Genres: ${data['genres'].join(', ')}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          // Release Date
                          Text(
                            'Release Date: ${data['start']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Status: ${data['status']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Description
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data['description'],
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
