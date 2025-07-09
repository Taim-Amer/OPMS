class Governorate {
  final int id;
  final String name;

  Governorate({required this.id, required this.name});

  factory Governorate.fromJson(Map<String, dynamic> json) => Governorate(
    id: json['id'],
    name: json['name'],
  );
}
