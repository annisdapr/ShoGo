class Movie {
  final int id;
  final String image;
  final String title;

  Movie({
    required this.id,
    required this.image,
    required this.title,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      image: json['image_thumbnail_path'],
      title: json['name'],
    );
  }
}