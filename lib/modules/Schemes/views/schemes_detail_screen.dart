part of scheme_details_library;

class SchemeDetailScreen
    extends WidgetView<SchemeDetailScreen, SchemeDetailsControllerState> {
  SchemeDetailScreen(super.controllerState);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseScreen(
      title: "Scheme Detail",
      body: BlocConsumer<SchemeBloc, SchemeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is LoadSchemeDetailsSuccess) {
            Scheme scheme = state.response;
            return SingleChildScrollView(
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scheme Name & Type
                      Text(
                        scheme.schemeName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Type: ${scheme.type.toUpperCase()}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),

                      // Price & Date Range
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Price: ₹${scheme.value}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Start: ${scheme.startDate.toString().substring(0, 10)}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                "End: ${scheme.endDate.toString().substring(0, 10)}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),

                      // Main Product
                      _buildProductTile(scheme.product, "Main Product"),

                      const SizedBox(height: 10),
                      const Text("Bundle Products",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),

                      // Bundle Products List
                      Column(
                        children: (scheme.bundleProducts as List)
                            .map((product) => _buildProductTile(product))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),

      appBarActions: [
        IconButton(
          icon: Icon(
            Icons.remove_circle,
            color: Colors.white,
          ),
          onPressed: () {
            controllerState.deleteScheme();
            print("schemes clicked");
          },
        ),
      ],
    );
  }

  Widget _buildProductTile(Product product, [String? title]) {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Text(title,
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600)),
            Text("SKU: ${product.sku}",
                style: const TextStyle(color: Colors.black54)),
            Text("Price: ₹${product.productMrp}",
                style: const TextStyle(color: Colors.black87)),
          ],
        ),
        trailing: const Icon(Icons.shopping_cart, color: Colors.blue),
      ),
    );
  }
}
