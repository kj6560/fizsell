part of contact_us_library;

class ContactUsScreen extends WidgetView<ContactUsScreen, ContactUsControllerState> {
  const ContactUsScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactUsBloc, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsSubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request submitted successfully.')),
          );
        } else if (state is ContactUsSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: BaseScreen(
        title: "Contact Us",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Need Help?", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("Fill the form below or call us directly.", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              Form(
                key: controllerState._formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controllerState.nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Change this to your desired color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5A13F),
                          ), // Color when focused
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controllerState.emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Change this to your desired color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5A13F),
                          ), // Color when focused
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
                        return emailRegex.hasMatch(value) ? null : 'Enter a valid email';
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controllerState.messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Change this to your desired color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFB5A13F),
                          ), // Color when focused
                        ),
                      ),
                      maxLines: 4,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your message' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (controllerState._formKey.currentState!.validate()) {
                          controllerState.submitRequest();
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text("Submit Request"),
                    ),
                    const SizedBox(height: 24),
                    // Add the Call Button
                    ElevatedButton.icon(
                      onPressed: _makePhoneCall,
                      icon: const Icon(Icons.call),
                      label: const Text("Call Us"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBarActions: [
          IconButton(
            icon: Icon(Icons.list, color: Colors.teal),
            onPressed: () {
              Navigator.popAndPushNamed(context, AppRoutes.contactUsResponses);
              print("Contact responses");
            },
          ),
        ],
      ),
    );
  }

  // Function to make the phone call

  Future<void> _makePhoneCall() async {
    const String phoneNumber = 'tel:+916202288651';
    final Uri url = Uri.parse(phoneNumber);

    // Request CALL_PHONE permission
    PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          print("❌ Could not launch $url");
        }
      } catch (e) {
        print("❌ Error while trying to call: $e");
      }
    } else {
      print("❌ Permission denied");
    }
  }
}
