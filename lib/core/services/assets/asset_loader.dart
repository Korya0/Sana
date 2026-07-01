import 'package:flutter/services.dart';

abstract interface class IAssetLoader {
  Future<String> loadString(String key);
}

class AssetLoaderImpl implements IAssetLoader {
  const AssetLoaderImpl();

  @override
  Future<String> loadString(String key) {
    return rootBundle.loadString(key);
  }
}
