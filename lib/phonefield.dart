library phonefield;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonefield/countries_model.dart';
import 'package:phonefield/extentions.dart';

import 'country_code_picker.dart';
import 'custom_text_field.dart';

/// Custom phone field with country picker `PhoneField`
///
class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    this.hintText,
    this.labelText,
    this.initialPhoneNumber,
    this.isFilled = false,
    this.isEnabled = true,
    required this.phoneNumber,
    this.shouldExcludeInitialZero = false,
    this.isPickerEnabled = true,
    this.hintStyle,
    this.labelStyle,
    this.flagSize,
    this.style,
    this.countryCode,
  });
  final String? countryCode;
  final String? hintText;
  final String? labelText;
  final String? initialPhoneNumber;
  final bool isFilled;
  final bool isEnabled;
  final Function(String) phoneNumber;
  final bool shouldExcludeInitialZero;
  final bool isPickerEnabled;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final double? flagSize;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  bool isFocused = false;
  TextEditingController controller = TextEditingController();
  CountriesModel pickedCountry = CountriesModel.defaultCountry;

  List<CountriesModel> allCountriesList = [];

  Future<List<CountriesModel>> get countriesList async {
    try {
      final String response = await rootBundle
          .loadString("packages/phonefield/data/countries.json");
      final data = await json.decode(response);
      var newData = List<CountriesModel>.from(data.map((e) {
        return CountriesModel.fromJson(e);
      }).toList());
      return newData;
    } catch (e) {
      print("$e");
      return [];
    }
  }

  Future<void> phoneNumberAndCode() async {
    var dd = widget.initialPhoneNumber!.countryCodeFromNumber;
    if (widget.countryCode != null) {
      pickedCountry =
          allCountriesList.getCountryFromCode(widget.countryCode!) ??
              allCountriesList.getCountry(dd.$1);
    } else {
      pickedCountry = allCountriesList.getCountry(dd.$1);
    }
    controller.text = dd.$2;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    allCountriesList = await countriesList;
    if (widget.initialPhoneNumber != null) {
      await phoneNumberAndCode();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: widget.labelText,
      controller: controller,
      isFilled: widget.isFilled,
      readOnly: !widget.isEnabled,
      hintStyle: widget.hintStyle,
      labelStyle: widget.labelStyle,
      textStyle: widget.style,
      hintText: widget.hintText ?? "Enter Your Phone Number",
      validator: (String? input) {
        if (input!.isEmpty) {
          return "Enter a phone number";
        }
        bool isValid = _isNumeric(input);
        if (!isValid) {
          return "Enter a valid phone number";
        }
        return null;
      },
      onChanged: (v) {
        setPhonenumber(v);
      },
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      prefixIcon: FutureBuilder<List<CountriesModel>>(
        future: countriesList,
        builder: (ctx, snapshot) {
          if (snapshot.data != null) {
            return CountryCodePicker(
              isEnabled: widget.isEnabled && widget.isPickerEnabled,
              initialCountry: pickedCountry,
              flagSize: widget.flagSize ?? 24,
              onPicked: (v) {
                pickedCountry = v;
                setPhonenumber(controller.text);
                setState(() {});
              },
              countriesList: snapshot.data!,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void setPhonenumber(String v) {
    String phoneNumber = v;
    if (widget.shouldExcludeInitialZero) {
      if (phoneNumber.startsWith("0")) {
        phoneNumber = phoneNumber.replaceFirst("0", "");
      }
    }
    String phone = pickedCountry.dialCode + phoneNumber;
    widget.phoneNumber.call(phone);
  }

  bool _isNumeric(String? str) {
    try {
      var input = int.parse(str!);
      log("$input");
      return true;
    } on FormatException {
      return false;
    }
  }
}
