import 'package:equatable/equatable.dart';

class AsmaUlHusna extends Equatable {
  final int id;
  final String name;
  final String meaningBrief;
  final String meaningDetailed;

  const AsmaUlHusna({
    required this.id,
    required this.name,
    required this.meaningBrief,
    required this.meaningDetailed,
  });

  @override
  List<Object?> get props => [id, name, meaningBrief, meaningDetailed];
}
