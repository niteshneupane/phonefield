<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Phonefield

## Features

Custom phone field with picker

## Getting started

To use this package, add `phonefield` to your `pubspec.yaml` file:

```yaml
dependencies:
  phonefield: ^1.0.0
```


## Usage


Check out the [example](https://github.com/niteshneupane/phonefield/tree/main/example) directory for detailed examples:



```dart
PhoneField(
    initialPhoneNumber: "+977",
    onChanged: (p0) {
        phoneNumber = p0;
        setState(() {});
        },
    )
```
Country Picker
```dart
CountryPicker(
  labelText: "Country",
  hintText: "Select a country",
  selectedCountry: selectedCountry,
  onChanged: (p0) {
    selectedState.value = null;
  },
  validator: (p0) {
    if (p0 == null) {
      return "Please select country ";
    }
    return null;
  },
),
```


State Picker
```dart
StatePicker(
    enabled: selectedCountry.value != null,
    hintText: "Select a state",
    countryCode: selectedCountry.value?.code,
    selectedState: selectedState,
    validator: (p0) {
      if (p0 == null || p0.isEmpty) {
        return selectedCountry.value != null
            ? "Please select state"
            : "Please select country first and select state";
      }
      return null;
    },
  ),
```


