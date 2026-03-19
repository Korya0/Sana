import 'package:quran_library/quran_library.dart';

abstract class IQuranRepo {
  Future<void> initialize();
}

class QuranRepoImpl implements IQuranRepo {
  @override
  Future<void> initialize() async {
    await QuranLibrary.init();
  }
}
