import 'package:flutter/cupertino.dart';
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

// class CountryCodePicker extends HookConsumerWidget {
// const CountryCodePicker({
//   super.key,
//   this.initialCountry,
//   required this.onPicked,
//   this.isEnabled = true,
//   required this.countriesList,
// });
// final CountriesModel? initialCountry;
// final List<CountriesModel> countriesList;
// final Function(CountriesModel) onPicked;
// final bool isEnabled;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final selectedCountry = useState<CountriesModel>(
//     //     initialCountry ?? CountriesModel.defaultCountry);

//   }
// }

class CountryCodePicker extends StatefulWidget {
  const CountryCodePicker({
    super.key,
    this.initialCountry,
    required this.onPicked,
    this.isEnabled = true,
    required this.countriesList,
  });
  final CountriesModel? initialCountry;
  final List<CountriesModel> countriesList;
  final Function(CountriesModel) onPicked;
  final bool isEnabled;

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  late ValueNotifier<CountriesModel> selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry =
        ValueNotifier(widget.initialCountry ?? CountriesModel.defaultCountry);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isEnabled
          ? () async {
              // context.push(
              //   CountryListPickerPage.routeName,
              // extra: CountryListPickerPageArgs(
              //   selectedCountry: selectedCountry,
              //   onPicked: widget.onPicked,
              //   countriesList: widget.countriesList,
              // ),
              // );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CountryListPickerPage(
                    args: CountryListPickerPageArgs(
                      selectedCountry: selectedCountry,
                      onPicked: widget.onPicked,
                      countriesList: widget.countriesList,
                    ),
                  ),
                ),
              );
              // showDialog(
              //   context: context,
              //   builder: (builder) {
              //     return CountryListDialog(
              //       countriesList: countriesList,
              //       selectedCountry: selectedCountry,
              //       onPicked: onPicked,
              //     );
              //   },
              // );
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              selectedCountry.value.flag,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Text(selectedCountry.value.dialCode),
          const Icon(Icons.keyboard_arrow_down_rounded),
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
