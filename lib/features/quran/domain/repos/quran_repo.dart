import 'package:sana/core/network/result.dart';

abstract interface class QuranRepo {
  Future<Result<void>> initialize();
}
