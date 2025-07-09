class District {
  final int id;
  final int governorateId;
  final String name;

  District({required this.id, required this.governorateId, required this.name});

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json['id'],
    governorateId: json['governorate_id'],
    name: json['name'],
  );
}
