import 'package:flutter/services.dart';

abstract interface class AssetLoader {
  Future<String> loadString(String key);
}

class AssetLoaderImpl implements AssetLoader {
  const AssetLoaderImpl();

  @override
  Future<String> loadString(String key) {
    return rootBundle.loadString(key);
  }
}
