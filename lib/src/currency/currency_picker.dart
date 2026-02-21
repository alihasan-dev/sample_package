import 'package:flutter/material.dart';
import 'package:sample_formatter/src/country/country_model.dart';
import 'package:sample_formatter/src/currency/currency_data.dart';

class CurrencyPicker {
  static Future<CountryModel?> show(BuildContext context) {
    return showModalBottomSheet<CountryModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CurrencyPickerView(
          onSelect: (currentModel) {
            Navigator.pop(context, currentModel);
          },
        );
      },
    );
  }
}

class CurrencyPickerView extends StatefulWidget {
  
  final Color? backgroundColor;
  final double? width;
  final Function(CurrencyModel?)? onSelect;
  final CurrencyModel? selectedCountryModel;
  
  const CurrencyPickerView({
    this.backgroundColor,
    this.width,
    this.onSelect,
    this.selectedCountryModel,
    super.key
  });

  @override
  State<CurrencyPickerView> createState() => _CurrencyPickerViewState();
}

class _CurrencyPickerViewState extends State<CurrencyPickerView> {

  final TextEditingController _searchController = TextEditingController();
  late ThemeData theme;

  List<CurrencyModel> filteredCurrencies = [];
  bool showCancelSymbol = false;

  @override
  void initState() {
    super.initState();
    filteredCurrencies.addAll(CurrencyModel.currencies);
    if (widget.selectedCountryModel != null && widget.selectedCountryModel!.country.trim().isNotEmpty) {
      filteredCurrencies.sort((a, b) {
        final selectedCode = widget.selectedCountryModel!.countryCode;
        if (a.countryCode == selectedCode) return -1;
        if (b.countryCode == selectedCode) return 1;
        return 0;
      });
    } 
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.trim().toLowerCase();
    showCancelSymbol = query.isNotEmpty;
    setState(() {
      if (query.isEmpty) return;
      filteredCurrencies = CurrencyModel.currencies.where((item) {
        return item.country.toLowerCase().contains(query) ||
            item.currencyCode.contains(query) ||
            item.currencySymbol.contains(query) ||
            item.currencyName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.search, 
                      color: Colors.grey, 
                      size: 20
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search by country, code or symbol...'
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: Duration(milliseconds: 250),
                      child: !showCancelSymbol
                      ? SizedBox.shrink()
                      : InkWell(
                        onTap: () => setState(() {
                          showCancelSymbol = false;
                          _searchController.clear();
                        }),
                        child: Icon(
                          Icons.close, 
                          color: Colors.grey, 
                          size: 20
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCurrencies.length,
                  itemBuilder: (context, index) {
                    final country = filteredCurrencies[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      ),
                      tileColor: widget.selectedCountryModel?.countryCode == country.countryCode
                      ? Colors.blue.withValues(alpha: 0.1)
                      : null,
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(country.flag)
                          ),
                          Expanded(
                            child: Text(
                              country.currencySymbol, 
                              style: theme.textTheme.bodySmall
                            ),
                          ),
                          Expanded(
                            child: Text(
                              country.currencyCode, 
                              style: theme.textTheme.bodySmall
                            ),
                          ),
                          Expanded(
                            flex: 2, 
                            child: Text(
                              country.country, 
                              style: theme.textTheme.bodySmall
                            ),
                          ),
                        ],
                      ),
                      onTap: () => widget.onSelect?.call(country),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
