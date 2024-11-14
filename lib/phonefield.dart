library phonefield;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonefield/countries_model.dart';
import 'package:phonefield/extentions.dart';
import 'package:phonefield/phone_model.dart';

import 'country_code_picker.dart';
import 'custom_text_field.dart';

export './country_picker.dart';
export './state_picker.dart';

/// Custom phone field with country picker `PhoneField`
///
class PhoneField extends StatefulWidget {
  ///
  const PhoneField({
    super.key,
    this.hintText,
    this.labelText,
    this.initialPhoneNumber,
    this.isFilled = false,
    this.isEnabled = true,
    required this.onChanged,
    this.shouldExcludeInitialZero = false,
    this.isPickerEnabled = true,
    this.hintStyle,
    this.labelStyle,
    this.flagSize,
    this.style,
    this.countryCode,
    this.inputBorder,
    this.focusedBorderColor,
    this.leftPadding = 4,
    this.contentPadding,
    this.errorBorder,
    this.errorStyle,
    this.errorMaxlines,
    this.validator,
  });

  ///

  final String? countryCode;

  ///
  final String? hintText;

  ///
  final String? labelText;

  ///
  final String? initialPhoneNumber;

  ///
  final bool isFilled;

  ///
  final bool isEnabled;

  ///
  final Function(PhoneModel) onChanged;

  ///
  final bool shouldExcludeInitialZero;

  ///
  final bool isPickerEnabled;

  ///
  final TextStyle? hintStyle;

  ///
  final TextStyle? labelStyle;

  ///
  final TextStyle? style;

  ///
  final double? flagSize;

  ///
  final OutlineInputBorder? inputBorder;

  ///
  final Color? focusedBorderColor;

  ///
  final double leftPadding;

  ///
  final EdgeInsets? contentPadding;

  ///
  final OutlineInputBorder? errorBorder;

  ///
  final TextStyle? errorStyle;

  ///
  final int? errorMaxlines;

  ///
  final String? Function(String?)? validator;

  @override
  State<PhoneField> createState() => _PhoneFieldState();

  ///
  static Future<PhoneModel?> getPhoneNumber(String pp) async {
    try {
      print("Checking for phone number $pp");
      var dio = Dio();
      final resp = await dio.get(
        "https://phonenumberutils.gorkhacloud.com/phonenumberdetails",
        options: Options(
          receiveTimeout: const Duration(seconds: 2),
          sendTimeout: const Duration(seconds: 2),
        ),
        queryParameters: {
          "phoneNumber": pp,
        },
      );
      var data = resp.data["data"];
      print("object ${resp.statusCode}");

      if (resp.statusCode == 200) {
        print("\x1B[32m SUCCESSSSSS \x1B[0m");
        return PhoneModel(
          name: data["region"] ?? "",
          isValid: data["isValid"],
          flag: data["flag"] ?? "",
          countryCode: data["regionCode"] ?? "",
          dialCode: "+${data["countryCode"]}",
          phoneNumber: data["nationalMobileNumber"] ?? "",
          message: data["informationalMessage"] ?? "-",
        );
      }
      return null;
    } on DioException catch (e) {
      print("$e");
      return null;
    } on SocketException catch (e) {
      log("\x1B[31m $e \x1B[0m");
      return null;
    }
  }
}

class _PhoneFieldState extends State<PhoneField> {
  late FocusNode myFocusNode;

  TextEditingController controller = TextEditingController();
  ValueNotifier<CountriesModel> selectedCountry =
      ValueNotifier(CountriesModel.defaultCountry);

  List<CountriesModel> allCountriesList = [];

  bool isLoading = true;

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
    var dd = await PhoneField.getPhoneNumber(widget.initialPhoneNumber!);
    if (dd?.isValid ?? false) {
      selectedCountry.value = CountriesModel(
        id: "",
        name: dd!.name,
        flag: dd.flag,
        code: dd.countryCode,
        dialCode: dd.dialCode,
        pattern: "pattern",
        limit: 17,
      );
      log("\x1B[31m One \x1B[0m");
      controller.text = dd.phoneNumber;
      setState(() {});
    } else {
      var dd = widget.initialPhoneNumber!.countryCodeFromNumber;
      if (widget.countryCode != null) {
        selectedCountry.value =
            allCountriesList.getCountryFromCode(widget.countryCode!) ??
                allCountriesList.getCountry(dd.$1);
      } else {
        selectedCountry.value = allCountriesList.getCountry(dd.$1);
      }
      log("\x1B[31m Two \x1B[0m");

      controller.text = dd.$2;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    myFocusNode = FocusNode();

    allCountriesList = await countriesList;
    if (widget.initialPhoneNumber != null) {
      await phoneNumberAndCode();
    } else {
      isLoading = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      focusNode: myFocusNode,
      labelText: widget.labelText,
      controller: controller,
      isFilled: widget.isFilled,
      errorBorder: widget.errorBorder,
      readOnly: !widget.isEnabled,
      hintStyle: widget.hintStyle,
      labelStyle: widget.labelStyle,
      textStyle: widget.style,
      errorMaxlines: widget.errorMaxlines,
      errorStyle: widget.errorStyle,
      inputBorder: widget.inputBorder,
      contentPadding: widget.contentPadding,
      focusedBorderColor: widget.focusedBorderColor,
      hintText: widget.hintText ?? "Enter Your Phone Number",
      validator: widget.validator ??
          (String? input) {
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
          if (snapshot.data != null && !isLoading) {
            return CountryCodePicker(
              isEnabled: widget.isEnabled && widget.isPickerEnabled,
              selectedCountry: selectedCountry,
              flagSize: widget.flagSize ?? 24,
              leftPadding: widget.leftPadding,
              onPicked: (v) {
                myFocusNode.requestFocus();
                selectedCountry.value = v;
                setPhonenumber(controller.text);
                setState(() {});
              },
              countriesList: snapshot.data!,
            );
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: SizedBox(
                  width: widget.flagSize ?? 24,
                ),
              ),
              const SizedBox(
                width: 34,
              ),
              // const Icon(Icons.keyboard_arrow_down_rounded),
              Container(
                color: const Color(0xffCBD5E1),
                height: 32,
                width: 2,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          );
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
    // String phone = selectedCountry.value.dialCode + phoneNumber;
    widget.onChanged.call(PhoneModel(
      countryCode: selectedCountry.value.code,
      dialCode: selectedCountry.value.dialCode,
      flag: selectedCountry.value.flag,
      name: selectedCountry.value.name,
      phoneNumber: phoneNumber,
    ));
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
