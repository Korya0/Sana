import 'package:equatable/equatable.dart';

class DailyHadith extends Equatable {
  final String text;
  final String subText;

  const DailyHadith({required this.text, required this.subText});

  factory DailyHadith.fromJson(Map<String, dynamic> json) {
    return DailyHadith(text: json['text'], subText: json['subText']);
  }

  @override
  List<Object?> get props => [text, subText];
}

class DailySunnah extends Equatable {
  final String title;
  final String subText;
  final String? source;

  const DailySunnah({required this.title, required this.subText, this.source});

  factory DailySunnah.fromJson(Map<String, dynamic> json) {
    return DailySunnah(
      title: json['title'],
      subText: json['subText'],
      source: json['source'],
    );
  }

  @override
  List<Object?> get props => [title, subText, source];
}
