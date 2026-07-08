class Lieu {
  final String id;
  final String nom;
  final String description;
  final String categorie;
  final double latitude;
  final double longitude;
  final String adresse;
  final String? horaires;
  final List<String> imagesUrls;
  final double? noteMoyenne;

  Lieu({
    required this.id,
    required this.nom,
    required this.description,
    required this.categorie,
    required this.latitude,
    required this.longitude,
    required this.adresse,
    this.horaires,
    this.imagesUrls = const [],
    this.noteMoyenne,
  });

  factory Lieu.fromMap(Map<String, dynamic> map) {
    return Lieu(
      id: map['id'],
      nom: map['nom'],
      description: map['description'] ?? '',
      categorie: map['categorie'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      adresse: map['adresse'] ?? '',
      horaires: map['horaires'],
      imagesUrls: (map['imagesUrls'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      noteMoyenne: map['noteMoyenne']?.toDouble(),
    );
  }
}