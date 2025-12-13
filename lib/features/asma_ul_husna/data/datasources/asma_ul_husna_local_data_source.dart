import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/asma_ul_husna_model.dart';
import '../../domain/entities/asma_ul_husna.dart';

abstract class AsmaUlHusnaLocalDataSource {
  Future<List<AsmaUlHusna>> getNames();
}

class AsmaUlHusnaLocalDataSourceImpl implements AsmaUlHusnaLocalDataSource {
  @override
  Future<List<AsmaUlHusna>> getNames() async {
    final String response = await rootBundle.loadString(
      'assets/json/asma_ul_husna.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => AsmaUlHusnaModel.fromJson(json)).toList();
  }
}
