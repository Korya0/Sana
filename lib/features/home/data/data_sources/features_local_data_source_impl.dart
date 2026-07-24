import 'package:sana/features/home/data/data_sources/features_local_data_source.dart';

class FeaturesLocalDataSourceImpl implements FeaturesLocalDataSource {
  @override
  List<String> getFeatures() {
    return [
      'salawat',
      'asma_ul_husna',
      'teaching_prayer',
      'qibla',
    ];
  }
}
