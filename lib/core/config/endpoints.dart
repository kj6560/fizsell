import 'base_url.dart';

class EndPoints {
  static const String appName = "Dukaandar";
  static const String login = '${baseUrl}/api/login';
  static const String logoutUrl = "$baseUrl/api/logout";

  static const String fetchKpi = '${baseUrl}/api/fetchKpi';

  static const String fetchProducts = '${baseUrl}/api/fetchProducts';
  static const String fetchProductUom = '${baseUrl}/api/fetchProductUoms';
  static const String addProduct = '${baseUrl}/api/addProduct';
  static const String deleteProduct = '${baseUrl}/api/deleteProduct';

  static const String fetchSchemes = '${baseUrl}/api/fetchSchemes';
  static const String updateScheme = '${baseUrl}/api/updateScheme';
  static const String deleteScheme = '${baseUrl}/api/deleteScheme';
  static const String allSchemes = '${baseUrl}/api/allSchemes';

  static const String fetchInventory = '${baseUrl}/api/fetchInventory';
  static const String updateInventory = '${baseUrl}/api/updateInventory';

  static const String fetchSales = '${baseUrl}/api/fetchOrders';
  static const String newSales = '${baseUrl}/api/updateOrder';

  static const String fetchCustomers = '${baseUrl}/api/fetchCustomers';
  static const String newCustomer = '${baseUrl}/api/createCustomer';

  static const String generateBarcode = '${baseUrl}/api/generateBarcode';

  static const String createOrganization = '${baseUrl}/api/registerOrg';

  static const String fetchContactResponses =
      '${baseUrl}/api/fetchContactResponses';
  static const String createContactFromApp =
      '${baseUrl}/api/createContactFromApp';

  static const String updateProfilePicture =
      '${baseUrl}/api/updateProfilePicture';
  static const String fetchUsersByOrg = '${baseUrl}/api/fetchUsersByOrg';
  static const String createNewUser = '${baseUrl}/api/createNewUser';
  static const String deleteUser = '${baseUrl}/api/deleteUser';
  static const String fetchCurrencies = '${baseUrl}/api/fetchCurrencies';
  static const String setCurrency = '${baseUrl}/api/setCurrency';
}
