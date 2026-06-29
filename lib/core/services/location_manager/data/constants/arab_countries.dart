import 'package:sana/core/constants/constants.dart';

class ArabCountry {
  const ArabCountry({
    required this.name,
    required this.lat,
    required this.lng,
  });
  final String name;
  final double lat;
  final double lng;
}

const List<ArabCountry> arabCountries = [
  ArabCountry(name: AppStrings.egypt, lat: 30.0444, lng: 31.2357),
  ArabCountry(name: AppStrings.saudiArabia, lat: 24.7136, lng: 46.6753),
  ArabCountry(name: AppStrings.uae, lat: 24.4539, lng: 54.3773),
  ArabCountry(name: AppStrings.kuwait, lat: 29.3759, lng: 47.9774),
  ArabCountry(name: AppStrings.qatar, lat: 25.2854, lng: 51.5310),
  ArabCountry(name: AppStrings.oman, lat: 23.5859, lng: 58.4059),
  ArabCountry(name: AppStrings.jordan, lat: 31.9454, lng: 35.9284),
  ArabCountry(name: AppStrings.lebanon, lat: 33.8938, lng: 35.5018),
  ArabCountry(name: AppStrings.palestine, lat: 31.7683, lng: 35.2137),
  ArabCountry(name: AppStrings.morocco, lat: 34.0209, lng: -6.8416),
];
