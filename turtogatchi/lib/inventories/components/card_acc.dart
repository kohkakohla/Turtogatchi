class CardAcc {
  String img;
  String name;
  String id;
  String description;

  CardAcc({
    required this.img,
    required this.name,
    required this.description,
    required this.id,
  });

  CardAcc.fromJson(Map<String, dynamic> json)
      : img = json['local_img'],
        name = json['name'],
        id = json['id'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    return {
      'local_img': img,
      'name': name,
      'id': id,
      'description': description,
    };
  }
}
