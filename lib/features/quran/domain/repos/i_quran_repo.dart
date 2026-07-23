import 'package:sana/core/network/result.dart';

abstract interface class IQuranRepo {
  Future<Result<void>> initialize();
}
