class CardTurt {
  String img;
  String name;
  String origin;
  String rarity;
  String species;
  String type;
  String conservationText;
  String vulnerable;

  CardTurt({
    required this.img,
    required this.name,
    required this.origin,
    required this.rarity,
    required this.species,
    required this.type,
    required this.conservationText,
    required this.vulnerable,
  });

  CardTurt.fromJson(Map<String, dynamic> json)
      : img = json['local_img'],
        name = json['name'],
        origin = json['origin'],
        rarity = json['rarity'],
        species = json['species'],
        type = json['type'],
        conservationText = json['conservationText'],
        vulnerable = json['vulnerable'];

  Map<String, dynamic> toJson() {
    return {
      'local_img': img,
      'name': name,
      'origin': origin,
      'rarity': rarity,
      'species': species,
      'type': type,
      'conservationText': conservationText,
      'vulnerable': vulnerable,
    };
  }
}
