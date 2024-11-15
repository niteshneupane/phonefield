import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonefield/custom_drop_down.dart';
import 'dart:convert';

/// Country picker Class
class CountryPicker extends StatefulWidget {
  /// Constructor
  const CountryPicker({
    super.key,
    required this.onSelect,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.validator,
  });

  ///
  final void Function(({String name, String? code})) onSelect;

  ///
  final String? labelText;

  ///
  final String? hintText;

  ///
  final bool enabled;

  ///
  final String? Function(String?)? validator;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<({String name, String? code})> dataList = [];

  Future<List<({String name, String? code})>> get countriesList async {
    try {
      final String response = await rootBundle
          .loadString("packages/phonefield/data/countries_state.json");
      final data = await json.decode(response);
      var newData = List<({String name, String? code})>.from(data.map((e) {
        return (
          name: e["name"],
          code: e["iso2"],
        );
      }).toList());
      return newData;
    } catch (e) {
      print("$e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    dataList = await countriesList;
    print(dataList.length);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropDownField(
      topOverlayPadding: widget.labelText != null ? 68 : 48,
      leftOverlayPadding: 0,
      validator: widget.validator,
      isEnabled: widget.enabled,
      hintText: widget.hintText,
      labelText: widget.labelText,
      dataList: dataList,
      onSelect: widget.onSelect,
    );
  }
}
