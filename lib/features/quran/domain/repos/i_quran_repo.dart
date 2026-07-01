import 'package:sana/core/networking/result.dart';

abstract interface class IQuranRepo {
  Future<Result<void>> initialize();
}
