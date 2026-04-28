import 'dart:typed_data';
import 'package:sana/core/networking/api_result.dart';

abstract class IShareService {
  Future<ApiResult<bool>> shareImage(
    Uint8List imageBytes, {
    required String imageName,
    String? text,
  });
}
