class Housing {
  final String id;
  final String title;
  final double price;
  final double lat;
  final double lng;
  final double rating;
  final List<String> photos;
  final String providerName;
  final String providerEmail;
  final String? description;
  final String? gender; // 'M' for Male, 'F' for Female, null for both

  Housing({
    required this.id,
    required this.title,
    required this.price,
    required this.lat,
    required this.lng,
    this.rating = 0.0,
    this.photos = const [],
    required this.providerName,
    required this.providerEmail,
    this.description,
    this.gender,
  });
}

