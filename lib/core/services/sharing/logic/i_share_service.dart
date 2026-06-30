import 'dart:typed_data';
import 'package:sana/core/networking/result.dart';

abstract class IShareService {
  Future<Result<bool>> shareImage(
    Uint8List imageBytes, {
    required String imageName,
    String? text,
  });
}
