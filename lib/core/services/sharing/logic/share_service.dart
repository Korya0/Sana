import 'dart:typed_data';
import 'package:sana/core/network/result.dart';

abstract interface class ShareService {
  Future<Result<bool>> shareImage(
    Uint8List imageBytes, {
    required String imageName,
    String? text,
  });

  /// Shares plain text content.
  Future<Result<bool>> shareText(String text);
}
