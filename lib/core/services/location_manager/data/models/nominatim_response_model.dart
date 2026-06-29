class NominatimResponseModel {
  const NominatimResponseModel({this.address});

  factory NominatimResponseModel.fromJson(Map<String, dynamic> json) {
    return NominatimResponseModel(
      address: json['address'] != null
          ? NominatimAddressModel.fromJson(
              json['address'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final NominatimAddressModel? address;

  String get formattedAddress {
    if (address == null) return '';
    final city = address!.effectiveCity;
    final country = address!.country;

    if (city != null && country != null) {
      return '$city, $country';
    } else if (country != null) {
      return country;
    }
    return '';
  }
}

class NominatimAddressModel {
  const NominatimAddressModel({
    this.city,
    this.town,
    this.village,
    this.suburb,
    this.state,
    this.country,
  });

  factory NominatimAddressModel.fromJson(Map<String, dynamic> json) {
    return NominatimAddressModel(
      city: json['city'] as String?,
      town: json['town'] as String?,
      village: json['village'] as String?,
      suburb: json['suburb'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );
  }

  final String? city;
  final String? town;
  final String? village;
  final String? suburb;
  final String? state;
  final String? country;

  String? get effectiveCity => city ?? town ?? village ?? suburb ?? state;
}
