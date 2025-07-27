part of subscription_list_library;

class SubscriptionListScreen
    extends
        WidgetView<SubscriptionListScreen, SubscriptionlistcontrollerState> {
  SubscriptionListScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Plans")),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionsLoaded) {
            return ListView.builder(
              itemCount: state.response.length,
              itemBuilder: (context, index) {
                final plan = state.response[index];
                final planName = plan.featureName ?? "Plan ${index + 1}";
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

                return InkWell(
                  onTap: () => debugPrint("Plan tapped: $planName"),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(
                                "₹ $price",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• "),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "$title: ",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(text: description),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                          const SizedBox(height: 16),

                          Align(
                            alignment: Alignment.centerRight,
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
                                controllerState.purchase(plan.featureId);
                              },
                              child: const Text(
                                "Subscribe",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is SubscriptionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SubscriptionsLoadFailure) {
            return const Center(child: Text("Failed to load subscriptions."));
          } else {
            return const Center(child: Text("Loading subscriptions..."));
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
