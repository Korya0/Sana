class AsmaulHusnaModel {
  final int id;
  final String name;
  final String meaningBrief;
  final String meaningDetailed;

  const AsmaulHusnaModel({
    required this.id,
    required this.name,
    required this.meaningBrief,
    required this.meaningDetailed,
  });

  factory AsmaulHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaulHusnaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      meaningBrief: json['meaningBrief'] as String,
      meaningDetailed: json['meaningDetailed'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'meaningBrief': meaningBrief,
      'meaningDetailed': meaningDetailed,
    };
  }
}
