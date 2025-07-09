class SubDistrict {
  final int id;
  final int districtId;
  final String name;

  SubDistrict({required this.id, required this.districtId, required this.name});

  factory SubDistrict.fromJson(Map<String, dynamic> json) => SubDistrict(
    id: json['id'],
    districtId: json['district_id'],
    name: json['name'],
  );
}
