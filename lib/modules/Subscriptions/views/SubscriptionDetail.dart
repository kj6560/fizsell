part of subscription_detail;

class Subscriptiondetail
    extends WidgetView<Subscriptiondetail, SubscriptiondetailcontrollerState> {
  const Subscriptiondetail(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionDetailLoaded) {
          final plan = state.response;
          final planName = plan.featureName;
          final price = plan.featurePrice ?? 0;

          // Parse features from JSON string as List<Map>
          List<dynamic> features = [];
          try {
            final decoded = jsonDecode(plan.details ?? '[]');
            if (decoded is List) {
              features = decoded;
            }
          } catch (e) {
            debugPrint("Invalid JSON in plan.details: $e");
          }
          return Scaffold(
            appBar: AppBar(title: Text("${state.response.featureName} Detail")),
            body: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top Row: Plan icon, name, and price
                    Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          color: Colors.teal,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            planName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      "What's included:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Feature list
                    if (features.isEmpty)
                      const Text("No details available.")
                    else
                      ...features.map((item) {
                        final title = item['title'] ?? '';
                        final description = item['description'] ?? '';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("• "),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                    children: [TextSpan(text: description)],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                    const SizedBox(height: 16),
                    Text(
                      "Total Price: ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text("₹ $price"),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          controllerState.createOrder(plan);
                        },
                        child: const Text(
                          "Pay",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Plan Detail")),
            body: Container(child: Text("Not Found")),
          );
        }
      },
      listener: (context, state) {
        if(state is SubscriptionCreatedSuccessfuly){
          controllerState.openCheckout(state.order);
        }
      },
    );
  }
}
