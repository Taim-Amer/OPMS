class AdminFor {
  final int id;
  final int subDistrictId;
  final String name;

  AdminFor({required this.id, required this.subDistrictId, required this.name});

  factory AdminFor.fromJson(Map<String, dynamic> json) => AdminFor(
    id: json['id'],
    subDistrictId: json['sub_district_id'],
    name: json['name'],
  );
}
