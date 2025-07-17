part of create_organization_library;

class CreateOrganizationScreen
    extends
        WidgetView<
          CreateOrganizationScreen,
          CreateOrganizationControllerState
        > {
  CreateOrganizationScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: BlocConsumer<OrganizationBloc, OrganizationState>(
          listener: (context, state) {
            if (state is OrganizationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${state.message} Please wait for approval."),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushReplacementNamed(context, '/login');
              });
            } else if (state is OrganizationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrganizationLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.0005),

                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 5),

                  // Create Org Card
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: controllerState._formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Create Organization",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Org Name
                            TextFormField(
                              controller: controllerState._orgNameController,
                              decoration: _inputDecoration(
                                "Organization Name",
                                Icons.business,
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? "Name is required"
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextFormField(
                              controller: controllerState._orgEmailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(
                                "Email",
                                Icons.email,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email is required";
                                }
                                final emailRegEx = RegExp(
                                  r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                );
                                if (!emailRegEx.hasMatch(value)) {
                                  return "Invalid email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            TextFormField(
                              controller: controllerState._orgNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration(
                                "Phone Number",
                                Icons.phone,
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? "Phone number is required"
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Address
                            TextFormField(
                              controller: controllerState._orgAddressController,
                              maxLines: 3,
                              decoration: _inputDecoration(
                                "Address",
                                Icons.location_on,
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? "Address is required"
                                          : null,
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Create Organization",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: controllerState._submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                            // Back to Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/login',
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Footer
                  Column(
                    children: [
                      Text(
                        "Powered By Shiwkesh Schematics Private Limited",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "All Rights Reserved",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version: ${AppConstants.AppVersion ?? '1.0.0'}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB5A13F)),
      ),
    );
  }
}
