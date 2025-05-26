part of create_organization_library;

class CreateOrganizationScreen extends WidgetView<CreateOrganizationScreen,
    CreateOrganizationControllerState> {
  CreateOrganizationScreen(super.controllerState, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OrganizationBloc, OrganizationState>(
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

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: controllerState._formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Organization Details",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller:
                                            controllerState._orgNameController,
                                        decoration: const InputDecoration(
                                          labelText: "Organization Name",
                                          prefixIcon: Icon(Icons.business),
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? "Name is required"
                                                : null,
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller:
                                            controllerState._orgEmailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: const InputDecoration(
                                          labelText: "Email",
                                          prefixIcon: Icon(Icons.email),
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Email is required";
                                          }
                                          final emailRegEx = RegExp(
                                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                                          if (!emailRegEx.hasMatch(value)) {
                                            return "Invalid email";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: controllerState
                                            ._orgNumberController,
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          labelText: "Phone Number",
                                          prefixIcon: Icon(Icons.phone),
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? "Phone number is required"
                                                : null,
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: controllerState
                                            ._orgAddressController,
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                          labelText: "Address",
                                          prefixIcon: Icon(Icons.location_on),
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? "Address is required"
                                                : null,
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 45,
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.check),
                                          label:
                                              const Text("Create Organization"),
                                          onPressed: controllerState._submit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            textStyle:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
