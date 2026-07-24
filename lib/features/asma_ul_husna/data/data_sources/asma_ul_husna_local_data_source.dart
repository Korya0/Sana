import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/asma_ul_husna/data/models/asma_ul_husna_model.dart';

abstract interface class AsmaUlHusnaLocalDataSource {
  Future<List<AsmaUlHusnaModel>> getNames();
}

List<AsmaUlHusnaModel> _parseAsmaUlHusnaJson(String jsonString) {
  final decoded = json.decode(jsonString) as List<dynamic>;
  return decoded
      .map((e) => AsmaUlHusnaModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

class AsmaUlHusnaLocalDataSourceImpl implements AsmaUlHusnaLocalDataSource {
  AsmaUlHusnaLocalDataSourceImpl(this._assetBundle);

  final AssetBundle _assetBundle;
  List<AsmaUlHusnaModel>? _cachedNames;

  @override
  Future<List<AsmaUlHusnaModel>> getNames() async {
    if (_cachedNames != null) {
      return _cachedNames!;
    }

    final jsonString = await _assetBundle.loadString(
      AppAssets.asmaUlHusna,
    );

    _cachedNames = await compute<String, List<AsmaUlHusnaModel>>(
      _parseAsmaUlHusnaJson,
      jsonString,
    );

    return _cachedNames!;
  }
}
