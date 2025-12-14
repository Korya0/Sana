import 'package:equatable/equatable.dart';

class DailyHadith extends Equatable {
  final String text;
  final String narrator;

  const DailyHadith({required this.text, required this.narrator});

  factory DailyHadith.fromJson(Map<String, dynamic> json) {
    return DailyHadith(text: json['text'], narrator: json['narrator']);
  }

  @override
  List<Object?> get props => [text, narrator];
}

class DailySunnah extends Equatable {
  final String text;
  final String description;

  const DailySunnah({required this.text, required this.description});

  factory DailySunnah.fromJson(Map<String, dynamic> json) {
    return DailySunnah(text: json['text'], description: json['description']);
  }

  @override
  List<Object?> get props => [text, description];
}

class DailyVerseReference extends Equatable {
  final String text;
  final String surahName;

  const DailyVerseReference({required this.text, required this.surahName});

  factory DailyVerseReference.fromJson(Map<String, dynamic> json) {
    return DailyVerseReference(
      text: json['text'],
      surahName: json['surah_name'],
    );
  }

  @override
  List<Object?> get props => [text, surahName];
}
