class PhoneModel {
  final String name;
  final bool? isValid;
  final String flag;
  final String countryCode;
  final String dialCode;
  final String phoneNumber;
  final String? message;

  PhoneModel({
    required this.name,
    required this.flag,
    this.isValid,
    required this.countryCode,
    required this.dialCode,
    required this.phoneNumber,
    this.message,
  });
}
