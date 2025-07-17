import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fizsell/core/config/AppConstants.dart';
import 'package:fizsell/core/config/base_url.dart';
import '../../modules/auth/bloc/auth_bloc.dart';
import '../../modules/auth/models/User.dart';
import '../config/config.dart';
import '../config/endpoints.dart';
import '../local/hive_constants.dart';
import '../routes.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late User user;
  String? profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    String userJson = authBox.get(HiveKeys.userBox);
    user = User.fromJson(jsonDecode(userJson));
    profileImageUrl = "${user.profilePic}"  ?? "";
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        await _uploadProfilePic(imageFile);
      }
    } catch (e) {
      print('Image selection error: $e');
    }
  }

  Future<void> _uploadProfilePic(File imageFile) async {
    String token = authBox.get(HiveKeys.accessToken) ?? "";
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    String userId = user.id.toString();

    FormData formData = FormData.fromMap({
      "user_id": userId,
      "profile_picture": await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    try {
      Dio dio = Dio();
      Response response = await dio.post(
        EndPoints.updateProfilePicture,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        setState(() {
          User u = User.fromJson(response.data['user']);
          profileImageUrl = "${u.profilePic}";
        });
        user.profilePic = profileImageUrl;
        authBox.put(HiveKeys.userBox, jsonEncode(user.toJson()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile picture updated successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload profile picture")),
        );
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading profile picture")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF5F5F5), Colors.teal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    accountName: Text(user.name),
                    accountEmail: Text(user.email),
                    currentAccountPicture: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: CachedNetworkImage(
                        imageUrl: "${baseUrl}/storage/${profileImageUrl}" ?? "",
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: Colors.indigo),
                        ),
                        errorWidget: (context, url, error) => const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: Colors.indigo),
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.home,
                    text: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.shopping_bag,
                    text: 'Products',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/list_product');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.inventory,
                    text: 'Inventory',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/list_inventory');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.inventory,
                    text: 'Schemes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/list_schemes');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.receipt_long,
                    text: 'Orders',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/list_sales');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.people,
                    text: 'Customers',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/list_customers');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    text: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),

                  _buildDrawerItem(
                    icon: Icons.contact_mail_outlined,
                    text: 'Contact Us',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/contact_us');
                    },
                  ),

                  _buildDrawerItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Logout"),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            ElevatedButton(
                              child: const Text("Logout"),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      bool loggedOut = await logout();
                      Navigator.pop(context);

                      if (loggedOut) {
                        BlocProvider.of<AuthBloc>(context).add(LoginReset());
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                              (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logout failed. Please try again.")),
                        );
                      }
                    },
                    color: Colors.red,
                  ),
                  const Divider(color: Colors.black,),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                AppConstants.companyName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "App Version ${AppConstants.AppVersion}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> logout() async {
    String token = authBox.get(HiveKeys.accessToken) ?? "";
    String userId = user.id.toString();  // Assuming `user.id` is the user ID

    try {
      Dio dio = Dio();
      Response response = await dio.get(
        '${EndPoints.logoutUrl}?user_id=$userId',  // Add user_id as query parameter
        options: Options(
          headers: {
            "Authorization": "Bearer $token",  // Add token if required
            "Accept": "application/json",      // Make sure this is set
          },
        ),
      );
      if (response.statusCode == 200 && response.data['success']) {
        await authBox.clear();  // Clear authentication data from Hive
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }



  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87,size: 22,),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
