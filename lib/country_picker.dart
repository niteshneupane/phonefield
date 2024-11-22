import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:phonefield/extentions.dart';

/// Country picker Class
class CountryPicker extends StatefulWidget {
  /// Constructor
  const CountryPicker({
    super.key,
    // required this.onSelect,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.validator,
    this.prefixText,
    this.isFilled = false,
    this.focusedBorderColor,
    this.inputBorder,
    this.borderRadius,
    this.contentPadding,
    this.suffixIcon,
    this.prefixIcon,
    this.errorBorder,
    this.errorStyle,
    this.hintStyle,
    required this.selectedCountry,
    this.onChanged,
  });

  ///
  final ValueNotifier<({String name, String code})?> selectedCountry;

  ///
  final Function(({String name, String code})?)? onChanged;

  ///
  final String? prefixText;

  ///
  final String? labelText;

  ///
  final String? hintText;

  ///
  final bool enabled;

  ///
  final String? Function(({String? code, String name})?)? validator;

  ///
  final bool isFilled;

  ///
  final Color? focusedBorderColor;

  ///
  final OutlineInputBorder? inputBorder;

  ///
  final double? borderRadius;

  ///
  final EdgeInsets? contentPadding;

  ///
  final Widget? suffixIcon;

  ///
  final Widget? prefixIcon;

  ///

  final OutlineInputBorder? errorBorder;

  ///

  final TextStyle? errorStyle;

  ///
  final TextStyle? hintStyle;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<({String name, String code})> dataList = [];

  Future<List<({String name, String code})>> get countriesList async {
    try {
      final String response = await rootBundle
          .loadString("packages/phonefield/data/countries_state.json");
      final data = await json.decode(response);
      var newData = List<({String name, String code})>.from(data.map((e) {
        return (
          name: e["name"],
          code: e["iso2"],
        );
      }).toList());
      return newData;
    } catch (e) {
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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = widget.inputBorder ??
        OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffCBD5E1)),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
        );
    var inputDecoration = InputDecoration(
      filled: widget.isFilled,
      fillColor: Colors.white,
      hoverColor: Colors.transparent,
      prefixText: widget.prefixText,
      prefixStyle: const TextStyle(fontSize: 16),
      border: outlineInputBorder,
      hintText: widget.hintText,
      hintStyle: widget.hintStyle ??
          const TextStyle(
            color: Color(0xff64748B),
            fontSize: 14,
          ),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder.copyWith(
        borderSide: BorderSide(
            color: widget.focusedBorderColor ?? const Color(0xffCBD5E1)),
      ),
      errorBorder: widget.errorBorder ??
          outlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Colors.red),
          ),
      errorStyle: widget.errorStyle,
      disabledBorder: outlineInputBorder,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      contentPadding: widget.contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
    );
    return DropdownSearch<({String code, String name})>(
      items: (f, cs) => dataList,
      selectedItem: widget.selectedCountry.value,
      compareFn: (item1, item2) => item1.code == item2.code,
      onChanged: (newValue) {
        widget.onChanged?.call(newValue);
        widget.selectedCountry.value = newValue;
      },
      validator: widget.validator,
      enabled: widget.enabled,
      dropdownBuilder: (context, selectedItem) =>
          selectedItem != null ? _buildText(selectedItem) : const SizedBox(),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchDelay: const Duration(milliseconds: 500),
        itemBuilder: (context, item, isDisabled, isSelected) => ListTile(
          leading: Text(
            item.code.emoji,
            style: const TextStyle(
              fontSize: 32,
            ),
          ),
          title: Text(item.name),
        ),
        searchFieldProps: TextFieldProps(
          decoration: inputDecoration.copyWith(
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(decoration: inputDecoration),
    );
  }

  Row _buildText(({String code, String name}) selectedItem) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          selectedItem.code.emoji,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            selectedItem.name,
          ),
        ),
      ],
    );
  }
}
