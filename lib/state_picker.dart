import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonefield/custom_drop_down.dart';

///
class StatePicker extends StatefulWidget {
  ///
  const StatePicker({
    super.key,
    required this.countryCode,
    required this.onSelect,
    this.hintText,
    this.labelText,
    this.controller,
    this.enabled = true,
    this.validator,
  });

  /// country code for required state
  final String? countryCode;

  /// callback
  final void Function(String) onSelect;

  ///
  final TextEditingController? controller;

  ///
  final String? labelText;

  ///
  final String? hintText;

  ///
  final bool enabled;

  ///
  final String? Function(String?)? validator;

  @override
  State<StatePicker> createState() => _StatePickerState();
}

class _StatePickerState extends State<StatePicker> {
  List<({String name, String? code})> dataList = [];

  Future<List<({String name, String? code})>> get stateList async {
    try {
      final String response = await rootBundle
          .loadString("packages/phonefield/data/countries_state.json");
      final data = await json.decode(response);

      var states = List.from(data).where((e) {
        return e["iso2"] == widget.countryCode;
      }).firstOrNull;

      return states != null
          ? List<({String name, String? code})>.from(states["states"].map((e) {
              return (name: e["name"], code: null);
            }).toList())
          : [];
    } catch (e) {
      print("$e");
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
    print("OLA ${dataList.length}");
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
    return CustomDropDownField(
      topOverlayPadding: widget.labelText != null ? 68 : 48,
      leftOverlayPadding: 0,
      isEnabled: widget.enabled,
      dataList: dataList,
      validator: widget.validator,
      initialController: widget.controller,
      hintText: widget.hintText,
      labelText: widget.labelText,
      onSelect: (p0) {
        print("Selected Selcet $p0");
        widget.onSelect.call(p0.name);
      },
    );
  }
}
