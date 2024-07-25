/// A model representing a country.
class CountriesModel {
  /// The unique identifier of the country.
  final String id;

  /// The name of the country.
  final String name;

  /// The flag emoji of the country.
  final String flag;

  /// The code of the country (e.g., US for the United States).
  final String code;

  /// The international dialing code of the country.
  final String dialCode;

  /// The phone number pattern for the country.
  final String pattern;

  /// The limit on the length of the phone number.
  final int limit;

  /// An optional phone number associated with the country.
  String? phoneNumber;

  /// Constructor for creating a [CountriesModel] instance.
  ///
  /// All parameters are required except for [phoneNumber].
  CountriesModel({
    required this.id,
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.pattern,
    required this.limit,
    this.phoneNumber,
  });

  /// Creates a [CountriesModel] instance from a JSON map.
  ///
  /// The [json] parameter must contain keys corresponding to the fields
  /// of the [CountriesModel].
  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
      id: json["id"],
      name: json["name"],
      flag: json["flag"],
      code: json["code"],
      dialCode: json["dial_code"],
      pattern: json["pattern"],
      limit: json["limit"],
    );
  }

  /// A static method to get a default country model.
  ///
  /// Returns a [CountriesModel] instance representing the default country,
  /// which is the USA.
  static CountriesModel get defaultCountry {
    return CountriesModel.fromJson({
      "id": "0235",
      "name": "USA",
      "flag": "🇺🇸",
      "code": "US",
      "dial_code": "+1",
      "pattern": "### ### ####",
      "limit": 17
    });
  }
}

/// An extension on a list of [CountriesModel] to provide additional functionalities.
extension CountryExt on List<CountriesModel> {
  /// Retrieves a [CountriesModel] by its [dialCode].
  ///
  /// If no country is found with the provided [dialCode], returns the default country.
  CountriesModel getCountry(String dialCode) {
    CountriesModel? dd = where((e) => e.dialCode == dialCode).firstOrNull;
    return dd ?? CountriesModel.defaultCountry;
  }

  /// Retrieves a [CountriesModel] by its [countryCode].
  ///
  /// If no country is found with the provided [countryCode], returns null.
  CountriesModel? getCountryFromCode(String countryCode) {
    CountriesModel? dd =
        where((e) => e.code.toLowerCase() == countryCode.toLowerCase())
            .firstOrNull;
    return dd;
  }

  /// Filters the list of [CountriesModel] based on a search value [v].
  ///
  /// Returns a list of countries whose name starts with the search value or whose
  /// dial code contains the search value.
  List<CountriesModel> filter(String v) {
    return where((e) {
      return e.name.trim().toLowerCase().startsWith(v.trim().toLowerCase()) ||
          e.dialCode.contains(v);
    }).toList();
  }
}
