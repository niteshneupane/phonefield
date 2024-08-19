import 'package:flutter/material.dart';
import 'countries_model.dart';
import 'country_list_picker_page.dart';

class CountryListPickerPageArgs {
  final ValueNotifier<CountriesModel> selectedCountry;
  final Function(CountriesModel p1) onPicked;
  final List<CountriesModel> countriesList;

  const CountryListPickerPageArgs({
    required this.selectedCountry,
    required this.onPicked,
    required this.countriesList,
  });
}

class CountryCodePicker extends StatefulWidget {
  const CountryCodePicker({
    super.key,
    required this.selectedCountry,
    required this.onPicked,
    this.isEnabled = true,
    required this.countriesList,
    required this.flagSize,
    required this.leftPadding,
    this.readOnly,
  });
  final ValueNotifier<CountriesModel> selectedCountry;
  final List<CountriesModel> countriesList;
  final Function(CountriesModel) onPicked;
  final bool isEnabled;
  final double flagSize;
  final double leftPadding;
  final bool? readOnly;

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isEnabled
          ? () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CountryListPickerPage(
                    args: CountryListPickerPageArgs(
                      selectedCountry: widget.selectedCountry,
                      onPicked: widget.onPicked,
                      countriesList: widget.countriesList,
                    ),
                  ),
                ),
              );
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: widget.leftPadding),
            child: Text(
              widget.selectedCountry.value.flag,
              style: TextStyle(fontSize: widget.flagSize),
            ),
          ),
          if (!widget.isEnabled)
            const SizedBox(
              width: 4,
            ),
          Text(
            widget.selectedCountry.value.dialCode,
            style: TextStyle(
                color: widget.readOnly == true ? Colors.grey : Colors.black),
          ),
          if (widget.isEnabled)
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: widget.readOnly == true ? Colors.grey : Colors.black,
            )
          else
            const SizedBox(
              width: 10,
            ),
          Container(
            color: const Color(0xffCBD5E1),
            height: 32,
            width: 2,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
