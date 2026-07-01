import 'package:sana/features/home/data/datasources/i_features_local_data_source.dart';

class FeaturesLocalDataSource implements IFeaturesLocalDataSource {
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
