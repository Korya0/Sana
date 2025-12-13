import 'package:equatable/equatable.dart';

class DailyHadith extends Equatable {
  final int id;
  final String text;
  final String narrator;
  final String source;

  const DailyHadith({
    required this.id,
    required this.text,
    required this.narrator,
    required this.source,
  });

  factory DailyHadith.fromJson(Map<String, dynamic> json) {
    return DailyHadith(
      id: json['id'],
      text: json['text'],
      narrator: json['narrator'],
      source: json['source'],
    );
  }

  @override
  List<Object?> get props => [id, text, narrator, source];
}

class DailySunnah extends Equatable {
  final int id;
  final String text;
  final String description;

  const DailySunnah({
    required this.id,
    required this.text,
    required this.description,
  });

  factory DailySunnah.fromJson(Map<String, dynamic> json) {
    return DailySunnah(
      id: json['id'],
      text: json['text'],
      description: json['description'],
    );
  }

  @override
  List<Object?> get props => [id, text, description];
}

class DailyVerseReference extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final String surahName;

  const DailyVerseReference({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.surahName,
  });

  factory DailyVerseReference.fromJson(Map<String, dynamic> json) {
    return DailyVerseReference(
      surahNumber: json['surah_number'],
      ayahNumber: json['ayah_number'],
      text: json['text'],
      surahName: json['surah_name'],
    );
  }

  @override
  List<Object?> get props => [surahNumber, ayahNumber, text, surahName];
}
