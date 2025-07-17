part of edit_customer_library;

class EditCustomerScreen
    extends WidgetView<EditCustomerScreen, EditCustomerControllerState> {
  EditCustomerScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseScreen(
      title: "Editing Customer",

      body: BlocConsumer<CustomersBloc, CustomersState>(
        listener: (context, state) {
          print("Current State: $state");
          if (state is UpdateCustomerSuccess ||
              state is NewCustomerCreateSuccess) {
            controllerState.hasApiResponse(state);
          }
          if (state is CustomerLoaded) {
            controllerState.customerUpdate(state.customer);
          } else if (state is NewCustomerCreateFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("${state.error}")));
          }
        },
        builder: (context, state) {
          if (state is CustomerLoaded) {
            return Container(
              child: Column(
                children: [
                  Form(
                    key: controllerState.formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllerState.customerNameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Customer Name',
                              border: OutlineInputBorder(),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller:
                                controllerState.customerAddressController,
                            decoration: InputDecoration(
                              labelText: 'Enter Customer Address',
                              border: OutlineInputBorder(),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter customer address';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller:
                                controllerState.customerPhoneNumberController,
                            decoration: InputDecoration(
                              labelText: 'Enter Customer Phone Number',
                              border: OutlineInputBorder(),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter customer phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Select Customer Type',
                              border: OutlineInputBorder(),
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
                            value: controllerState.selectedCustomerType,
                            items:
                                controllerState.customerTypeItems.map((
                                  String type,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(
                                      type == '1' ? 'Retailer' : 'Distributor',
                                    ), // Optional display
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              controllerState.updateCustomerType(newValue);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select customer type';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Select Customer Active',
                              border: OutlineInputBorder(),
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
                            value: controllerState.selectedValue,
                            items:
                                controllerState.dropdownItems.map((
                                  String item,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              controllerState.updatePaymentMode(newValue);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 30,
                            child: ElevatedButton.icon(
                              onPressed: controllerState._takePicture,
                              icon: Icon(Icons.camera),
                              label: Text("Capture Image"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              controllerState.updateCustomer();
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator(color: Colors.teal)),
                Center(child: Text("Editing Customer...")),
              ],
            ),
          );
        },
      ),
    );
  }
}
