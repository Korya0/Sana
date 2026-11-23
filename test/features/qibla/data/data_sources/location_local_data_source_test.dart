import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';

void main() {
  test('exposes current location and stream surface', () async {
    final LocationLocalDataSource source = _FakeLocationLocalDataSource();

    final current = await source.getCurrentLocation();
    final streamed = await source.onLocationChanged().first;

    expect(current.latitude, 30.0444);
    expect(current.longitude, 31.2357);
    expect(streamed.heading, 12.0);
  });
}

class _FakeLocationLocalDataSource implements LocationLocalDataSource {
  @override
  Future<LocationModel> getCurrentLocation() async =>
      const LocationModel(latitude: 30.0444, longitude: 31.2357);

  @override
  Stream<LocationModel> onLocationChanged() => Stream.value(
    const LocationModel(latitude: 21.4225, longitude: 39.8262, heading: 12),
  );
}
