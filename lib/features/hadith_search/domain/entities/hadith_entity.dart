import 'package:equatable/equatable.dart';

class HadithEntity extends Equatable {
  const HadithEntity({
    required this.hadithContent,
    this.narrator,
    this.scholar,
    this.source,
    this.page,
    this.judgment,
  });

  final String hadithContent;
  final String? narrator;
  final String? scholar;
  final String? source;
  final String? page;
  final String? judgment;

  @override
  List<Object?> get props => [
    hadithContent,
    narrator,
    scholar,
    source,
    page,
    judgment,
  ];
}
