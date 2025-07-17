part of sales_detail_library;

class SalesDetailScreen
    extends WidgetView<SalesDetailScreen, SalesDetailState> {
  SalesDetailScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Sales Detail",
      body: BlocConsumer<SalesBloc, SalesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingSalesDetail) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 10),
                  Text("Loading...", style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          } else if (state is LoadSalesDetailsSuccess) {
            var details = jsonDecode(state.response.orderDetails);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🔹 Order Summary Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildOrderDetail("Order ID", state.response.orderId),
                          _buildOrderDetail(
                            "Order Date",
                            state.response.orderDate,
                          ),
                          _buildOrderDetail(
                            "Total Value",
                            "₹${state.response.totalOrderValue}",
                          ),
                          _buildOrderDetail(
                            "Discount",
                            "₹${state.response.totalOrderDiscount}",
                          ),
                          _buildOrderDetail(
                            "Net Value",
                            "₹${state.response.netOrderValue}",
                          ),
                          _buildOrderDetail(
                            "Net Payable",
                            "₹${state.response.netTotal}",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Order Items
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Order Items",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          showDetail(details),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🖨 Print Invoice
                  ElevatedButton.icon(
                    onPressed: () {
                      controllerState.printInvoice(state.response.print_invoice);
                    },
                    icon: const Icon(Icons.print, color: Color(0xFF008080)), // Teal icon
                    label: const Text(
                      "Print Invoice",
                      style: TextStyle(color: Color(0xFF008080)), // Teal text
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      side: const BorderSide(color: Color(0xFF008080), width: 1.5), // Teal border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),

                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderDetail(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          Text(
            "$value",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget showDetail(dynamic details) {
    var decoded = jsonDecode(details);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(140), // Product
            1: FixedColumnWidth(60), // Qty
            2: FixedColumnWidth(80), // Price
            3: FixedColumnWidth(70), // Tax
            4: FixedColumnWidth(80), // Discount
            5: FixedColumnWidth(90), // Net
          },
          border: TableBorder.symmetric(
            inside: BorderSide(width: 0.5, color: Colors.grey.shade300),
            outside: BorderSide(width: 1, color: Colors.grey.shade400),
          ),
          children: [
            // Header
            TableRow(
              decoration: BoxDecoration(color: Colors.teal.shade50),
              children: [
                _tableHeader("Product"),
                _tableHeader("Qty"),
                _tableHeader("Price"),
                _tableHeader("Tax"),
                _tableHeader("Disc."),
                _tableHeader("Net"),
              ],
            ),
            // Data rows
            ...decoded.map<TableRow>((item) {
              return TableRow(
                decoration: const BoxDecoration(color: Colors.white),
                children: [
                  _tableCell(item['product_name']),
                  _tableCell(item['quantity']),
                  _tableCell("₹${item['base_price']}"),
                  _tableCell("₹${item['tax']}"),
                  _tableCell("₹${item['discount']}"),
                  _tableCell("₹${item['net_price']}"),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _tableCell(dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
      child: Text("$value", style: const TextStyle(fontSize: 13)),
    );
  }
}
