import 'package:flutter/material.dart';

import '../custom/device_info.dart';
import '../custom/input_decorations.dart';
import '../custom/my_app_bar.dart';
import '../custom/my_widget.dart';
import '../my_theme.dart';

class VendorPayment extends StatefulWidget {
  const VendorPayment({super.key});

  @override
  State<VendorPayment> createState() => _VendorPaymentState();
}

class _VendorPaymentState extends State<VendorPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        bottom: null,
        title: 'Manage Vendors',
        centerTitle: true,
      ).show(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                "Vendor Name",
                style: TextStyle(
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MyWidget.customCardView(
                backgroundColor: MyTheme.white,
                width: DeviceInfo(context).getWidth(),
                height: 45,
                borderRadius: 10,
                elevation: 5,
                child: TextField(
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "John Doe",
                      borderColor: MyTheme.light_grey,
                      hintTextColor: MyTheme.grey_153),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                "Due Amount",
                style: TextStyle(
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MyWidget.customCardView(
                backgroundColor: MyTheme.white,
                width: DeviceInfo(context).getWidth(),
                height: 45,
                borderRadius: 10,
                elevation: 5,
                child: TextField(
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "Payment amount",
                      borderColor: MyTheme.light_grey,
                      hintTextColor: MyTheme.grey_153),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
