import 'package:flutter/material.dart';
import 'package:sample_formatter/src/country/country_data.dart';
import 'package:sample_formatter/src/country/country_model.dart';

class CountryPicker {
  static Future<CountryModel?> show(BuildContext context) {
    return showModalBottomSheet<CountryModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return const _CountryPickerView();
      },
    );
  }
}

class _CountryPickerView extends StatefulWidget {
  const _CountryPickerView();

  @override
  State<_CountryPickerView> createState() => _CountryPickerViewState();
}

class _CountryPickerViewState extends State<_CountryPickerView> {
  final TextEditingController _searchController = TextEditingController();

  List<CountryModel> _filteredCountries = CountryData.countries;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredCountries = CountryData.countries.where((country) {
        return country.name.toLowerCase().contains(query) ||
            country.phoneCode.contains(query) ||
            country.language.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            /// Drag Indicator
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 16),

            /// Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search country",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Country List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];

                  return ListTile(
                    title: Text(country.name),
                    subtitle: Text(
                      "${country.language} • ${country.phoneCode}",
                    ),
                    onTap: () {
                      Navigator.pop(context, country);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
