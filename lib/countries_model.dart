class CountriesModel {
  final String id;
  final String name;
  final String flag;
  final String code;
  final String dialCode;
  final String pattern;
  final int limit;

  String? phoneNumber;

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

extension CountryExt on List<CountriesModel> {
  CountriesModel getCountry(String dialCode) {
    CountriesModel? dd = where((e) => e.dialCode == dialCode).firstOrNull;
    return dd ?? CountriesModel.defaultCountry;
  }

  CountriesModel? getCountryFromCode(String countryCode) {
    CountriesModel? dd =
        where((e) => e.code.toLowerCase() == countryCode.toLowerCase())
            .firstOrNull;
    return dd;
  }

  List<CountriesModel> filter(String v) {
    return where((e) {
      return e.name.trim().toLowerCase().startsWith(v.trim().toLowerCase()) ||
          e.dialCode.contains(v);
    }).toList();
  }
}
