import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
class StatePicker extends StatefulWidget {
  ///
  const StatePicker({
    super.key,
    required this.countryCode,
    required this.selectedState,
    this.prefixText,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.validator,
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
  });

  /// country code for required state
  final String? countryCode;

  ///
  final ValueNotifier<String?> selectedState;

  ///
  final String? prefixText;

  ///
  final String? labelText;

  ///
  final String? hintText;

  ///
  final bool enabled;

  ///
  final String? Function(String?)? validator;

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
  State<StatePicker> createState() => _StatePickerState();
}

class _StatePickerState extends State<StatePicker> {
  List<String> dataList = [];

  Future<List<String>> get stateList async {
    try {
      final String response = await rootBundle
          .loadString("packages/phonefield/data/countries_state.json");
      final data = await json.decode(response);

      var states = List.from(data).where((e) {
        return e["iso2"] == widget.countryCode;
      }).firstOrNull;

      return states != null
          ? List<String>.from(states["states"].map((e) {
              return e["name"];
            }).toList())
          : [];
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.countryCode != null) init();
  }

  init() async {
    dataList = await stateList;
    log("OLA ${dataList.length}");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant StatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryCode != widget.countryCode) {
      init();
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
          color: widget.focusedBorderColor ?? const Color(0xffCBD5E1),
        ),
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
    return DropdownSearch<String>(
      items: (f, cs) => dataList,
      selectedItem: widget.selectedState.value,
      onChanged: (newValue) {
        widget.selectedState.value = newValue;
      },
      validator: widget.validator,
      enabled: widget.enabled,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchDelay: const Duration(milliseconds: 500),
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
}
