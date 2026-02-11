import 'package:sample_formatter/src/country/country_model.dart';

class CountryData {
  static const List<CountryModel> countries = [
    CountryModel(
      name: "India",
      isoCode: "IN",
      phoneCode: "+91",
      language: "Hindi",
    ),
    CountryModel(
      name: "United States",
      isoCode: "US",
      phoneCode: "+1",
      language: "English",
    ),
    CountryModel(
      name: "United Kingdom",
      isoCode: "GB",
      phoneCode: "+44",
      language: "English",
    ),
    CountryModel(
      name: "Canada",
      isoCode: "CA",
      phoneCode: "+1",
      language: "English/French",
    ),
    CountryModel(
      name: "Germany",
      isoCode: "DE",
      phoneCode: "+49",
      language: "German",
    ),
  ];
}
