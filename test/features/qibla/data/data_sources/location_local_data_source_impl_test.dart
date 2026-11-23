import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source_impl.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter.baseflow.com/geolocator');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    messenger.setMockStreamHandler(
      const EventChannel('flutter.baseflow.com/geolocator_updates'),
      null,
    );
  });

  test('getCurrentLocation throws LocationFailure when service disabled',
      () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'isLocationServiceEnabled') return false;
      return null;
    });
    final dataSource = LocationLocalDataSourceImpl();

    expect(
      dataSource.getCurrentLocation,
      throwsA(
        isA<LocationFailure>().having(
          (failure) => failure.message,
          'message',
          AppStrings.qiblaFailedTitle,
        ),
      ),
    );
  });

  test('getCurrentLocation maps position values', () async {
    final methods = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      methods.add(call.method);
      switch (call.method) {
        case 'isLocationServiceEnabled':
          return true;
        case 'getCurrentPosition':
          return <String, dynamic>{
            'latitude': 30.0444,
            'longitude': 31.2357,
            'heading': 45.0,
          };
        default:
          return null;
      }
    });
    final dataSource = LocationLocalDataSourceImpl();

    final location = await dataSource.getCurrentLocation();

    expect(location, isA<LocationModel>());
    expect(location.latitude, 30.0444);
    expect(location.longitude, 31.2357);
    expect(location.heading, 45.0);
    expect(methods, contains('getCurrentPosition'));
  });

  test('onLocationChanged maps streamed positions', () async {
    messenger.setMockStreamHandler(
      const EventChannel('flutter.baseflow.com/geolocator_updates'),
      MockStreamHandler.inline(
        onListen: (arguments, events) {
          events.success(<String, dynamic>{
            'latitude': 21.4225,
            'longitude': 39.8262,
            'heading': 90.0,
          });
        },
      ),
    );
    final dataSource = LocationLocalDataSourceImpl();

    final location = await dataSource.onLocationChanged().first;

    expect(location.latitude, 21.4225);
    expect(location.longitude, 39.8262);
    expect(location.heading, 90.0);
  });
}
