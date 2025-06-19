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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 10),
                  Text("Loading...", style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          } else if (state is LoadSalesDetailsSuccess) {
            var details = jsonDecode(state.response.orderDetails);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildOrderDetail("Order ID", state.response.orderId),
                          _buildOrderDetail(
                              "Order Date", state.response.orderDate),
                          _buildOrderDetail("Total Order Value",
                              state.response.totalOrderValue),
                          _buildOrderDetail("Total Order Discount",
                              state.response.totalOrderDiscount),
                          _buildOrderDetail(
                              "Net Order Value", state.response.netOrderValue),
                          _buildOrderDetail(
                              "Net Amount", state.response.netTotal),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Order Items",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  showDetail(details),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //controllerState.printInvoice();
                        controllerState.printInvoice(state.response.print_invoice);
                      },
                      icon: Icon(Icons.print),
                      label: Text("Print Invoice"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
          Text(label,
              style: const TextStyle(fontSize: 15, color: Colors.black87)),
          Text(
            "$value",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget showDetail(dynamic details) {
    var decoded = jsonDecode(details);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Items",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
            const SizedBox(height: 12),
            // Add horizontal and vertical scroll
            SizedBox(
              height: 300, // Adjust height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    columnWidths: const {
                      0: FixedColumnWidth(140), // Product Name
                      1: FixedColumnWidth(60),
                      2: FixedColumnWidth(80),
                      3: FixedColumnWidth(70),
                      4: FixedColumnWidth(80),
                      5: FixedColumnWidth(90),
                    },
                    border: TableBorder.symmetric(
                      inside:
                          BorderSide(width: 0.5, color: Colors.grey.shade300),
                      outside:
                          BorderSide(width: 1, color: Colors.grey.shade400),
                    ),
                    children: [
                      // Table Header
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
                      // Table Rows
                      ...decoded.map<TableRow>((item) {
                        return TableRow(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _tableCell(dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Text(
        "$value",
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
