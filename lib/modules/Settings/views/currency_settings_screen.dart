part of currency_settings_library;

class CurrencySettingsScreen
    extends
        WidgetView<CurrencySettingsScreen, CurrencySettingsControllerState> {
  CurrencySettingsScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Currency Settings",
      body: BlocConsumer<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is LoadingCurrencies || state is SettingsInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 12),
                  Text("Please wait..."),
                ],
              ),
            );
          } else if (state is LoadCurrenciesSuccess) {
            final filteredList =
                controllerState._currencies
                    .where(
                      (c) => c.name.toLowerCase().contains(
                        controllerState.searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();
            final selectedCurrency =
                controllerState.selectedCurrencyId != 0
                    ? controllerState._currencies.firstWhere(
                      (c) => c.id == controllerState.selectedCurrencyId,
                    )
                    : null;
            return Column(
              children: [
                selectedCurrency != null
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${selectedCurrency.code} ${selectedCurrency.name} ${selectedCurrency.country}",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                    : SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search currency name...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      controllerState.updateSearchQuery(value);
                    },
                  ),
                ),
                Expanded(
                  child:
                      filteredList.isEmpty
                          ? Center(child: Text("No currencies found"))
                          : ListView.separated(
                            itemCount: filteredList.length,
                            separatorBuilder: (_, __) => Divider(height: 1),
                            itemBuilder: (context, index) {
                              final currency = filteredList[index];
                              final id = currency.id;
                              final code = currency.code;
                              final symbol = currency.symbol ?? "";
                              final mCurrency = currency.name;
                              final mCountry = currency.country;
                              final selected =
                                  id == controllerState.selectedCurrencyId;
                              return ListTile(
                                leading: Icon(
                                  selected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: Colors.teal,
                                ),
                                title: Text(
                                  "$code ($symbol) - $mCurrency($mCountry)",
                                ),
                                onTap:
                                    () => controllerState._onCurrencySelected(
                                      currency,
                                    ),
                              );
                            },
                          ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controllerState.setCurrency();
                  },
                  child: Text("set Currency"),
                ),
              ],
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Colors.teal),
                SizedBox(height: 12),
                Text("Please wait..."),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is LoadCurrenciesSuccess) {
            controllerState.updateCurrencies(
              state.currencies,
              state.selectedCurrency,
            );
          }
          if (state is CurrencySetSuccessful) {
            controllerState.updated();
          }
        },
      ),
    );
  }
}
