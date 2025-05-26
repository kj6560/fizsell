class HomeResponse {
  final SalesData salesData;
  final InventoryData inventoryData;
  final ProductsData productsData;

  HomeResponse({
    required this.salesData,
    required this.inventoryData,
    required this.productsData,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      salesData: SalesData.fromJson(json['sales_data']),
      inventoryData: InventoryData.fromJson(json['inventory_data']),
      productsData: ProductsData.fromJson(json['products_data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales_data': salesData.toJson(),
      'inventory_data': inventoryData.toJson(),
      'products_data': productsData.toJson(),
    };
  }
}

class SalesData {
  final String salesToday;
  final String salesThisMonth;
  final String salesTotal;

  SalesData({
    required this.salesToday,
    required this.salesThisMonth,
    required this.salesTotal,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      salesToday: json['sales_today'].toString(),
      salesThisMonth: json['sales_this_month'].toString(),
      salesTotal: json['sales_total'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales_today': salesToday,
      'sales_this_month': salesThisMonth,
      'sales_total': salesTotal,
    };
  }
}

class InventoryData {
  final String inventoryAddedToday;
  final String inventoryAddedThisMonth;
  final String inventoryAddedTotal;

  InventoryData({
    required this.inventoryAddedToday,
    required this.inventoryAddedThisMonth,
    required this.inventoryAddedTotal,
  });

  factory InventoryData.fromJson(Map<String, dynamic> json) {
    return InventoryData(
      inventoryAddedToday: json['inventory_added_today'].toString(),
      inventoryAddedThisMonth: json['inventory_added_this_month'].toString(),
      inventoryAddedTotal: json['inventory_added_total'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventory_added_today': inventoryAddedToday,
      'inventory_added_this_month': inventoryAddedThisMonth,
      'inventory_added_total': inventoryAddedTotal,
    };
  }
}

class ProductsData {
  final String productsAddedToday;
  final String productsAddedThisMonth;
  final String productsAddedTotal;

  ProductsData({
    required this.productsAddedToday,
    required this.productsAddedThisMonth,
    required this.productsAddedTotal,
  });

  factory ProductsData.fromJson(Map<String, dynamic> json) {
    return ProductsData(
      productsAddedToday: json['products_added_today'].toString(),
      productsAddedThisMonth: json['products_added_this_month'].toString(),
      productsAddedTotal: json['products_added_total'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products_added_today': productsAddedToday,
      'products_added_this_month': productsAddedThisMonth,
      'products_added_total': productsAddedTotal,
    };
  }
}
