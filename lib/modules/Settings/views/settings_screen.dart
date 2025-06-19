part of settings_library;

class SettingsScreen
    extends WidgetView<SettingsScreen, SettingsControllerState> {
  SettingsScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Settings",
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          BluetoothInfo? printer;
          if (state is PrintersLoaded) {
            printer = state.selectedPrinter;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              ExpansionTile(
                leading: Icon(Icons.people, color: Colors.teal),
                title: Text("Users"),
                children: [
                  ListTile(
                    title: Text("All Users"),
                    onTap: () {
                      Navigator.pushNamed(context, '/user_list');
                    },
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.currency_exchange, color: Colors.teal),
                title: Text("Currency"),
                subtitle: Text("INR ₹"), // You can dynamically show current currency
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/currencySettings"
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
