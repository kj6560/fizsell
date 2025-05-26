part of contact_us_response_library;

class ContactUsResponses extends WidgetView<ContactUsResponses, ContactUsResponsesControllerState> {
  const ContactUsResponses(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Admin Responses",
      body: BlocBuilder<ContactUsBloc, ContactUsState>(
        bloc: controllerState.contactUsBloc,
        builder: (context, state) {
          print("state contact us response: ${state}");

          if (state is FetchingContactResponses) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactUsResponsesLoaded) {
            return Column(
              children: [
                const SizedBox(height: 16),
                Expanded(child: _buildResponseList(state.contacts)),
              ],
            );
          } else if (state is ContactUsResponsesFailure) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(child: Text('No responses available.'));
        },
      ),
    );
  }

  Widget _buildResponseList(List<AppContact> contacts) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy - hh:mm a');

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isPending = contact.queryStatus == 1;

        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPending
                  ? [Colors.orange.shade200, Colors.deepOrange.shade400]
                  : [Colors.blueGrey.shade300, Colors.blueGrey.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        isPending ? Icons.pending : Icons.check_circle,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contact.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      backgroundColor: isPending ? Colors.orange.shade700 : Colors.green.shade700,
                      label: Text(
                        isPending ? "Pending" : "Answered",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Query Section
                Text(
                  "Query:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.query,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),

                const SizedBox(height: 12),

                /// Response Section
                Text(
                  "Response:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.response.isNotEmpty ? contact.response : "No response yet.",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),

                const SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.5)),
                const SizedBox(height: 8),

                /// Date Section with Multiline Support
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Query Date:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(contact.queryDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Answered On:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.answeredOn != null
                          ? formatter.format(contact.answeredOn!)
                          : 'N/A',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
