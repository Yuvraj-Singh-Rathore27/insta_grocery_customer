import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  // Optional reference number to display
  final String? referenceNumber;
  // A function to call when "Go Back to Home" is pressed
  final VoidCallback? onGoHome;
  // A function to call when "View My Enquiries" is pressed
  final VoidCallback? onViewEnquiries;

  const SuccessDialog({
    super.key,
    this.referenceNumber,
    this.onGoHome,
    this.onViewEnquiries,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          // Success Icon
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 64,
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            "Enquiry Submitted Successfully!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Message
          Text(
                "Your enquiry has been received. We’ll get back to you shortly.",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          const Divider(height: 1),
          const SizedBox(height: 16),

          // Go Back to Home Button
          SizedBox(
            width: double.infinity, // Make button full width
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onGoHome?.call(); // Call the optional callback
              },
              child: const Text(
                "Go Back to Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // View My Enquiries Button
          SizedBox(
            width: double.infinity, // Make button full width
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onViewEnquiries?.call(); // Call the optional callback
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text(
                "View My Enquiries",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}