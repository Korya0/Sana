import 'package:equatable/equatable.dart';

class HadithEntity extends Equatable { // المحتوى الكامل (HTML) الذي يحتوي على الحديث ومعلوماته

  const HadithEntity({required this.hadithContent});
  final String
  hadithContent;

  @override
  List<Object?> get props => [hadithContent];
}
