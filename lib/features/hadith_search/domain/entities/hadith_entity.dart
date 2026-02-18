import 'package:equatable/equatable.dart';

class HadithEntity extends Equatable {
  final String
  hadithContent; // المحتوى الكامل (HTML) الذي يحتوي على الحديث ومعلوماته

  const HadithEntity({required this.hadithContent});

  @override
  List<Object?> get props => [hadithContent];
}
