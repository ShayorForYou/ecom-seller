import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/helpers/main_helper.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SslCommerzScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String? payment_method_key;
  String package_id;

  SslCommerzScreen(
      {super.key,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = "",
      this.package_id = "0"});

  @override
  _SslCommerzScreenState createState() => _SslCommerzScreenState();
}

class _SslCommerzScreenState extends State<SslCommerzScreen> {
  final int _combined_order_id = 0;
  final bool _order_init = false;

  String? _initial_url = "";
  bool _initial_url_fetched = false;

  late WebViewController _webViewController;

  @override
  void initState() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (page) {
            //print(page.toString());

            if (page.contains("/sslcommerz/success")) {
              getData();
            } else if (page.contains("/sslcommerz/cancel") ||
                page.contains("/sslcommerz/fail")) {
              ToastComponent.showDialog("Payment cancelled or failed",
                  gravity: Toast.center, duration: Toast.lengthLong);
              Navigator.of(context).pop();
              return;
            }
          },
        ),
      );
    super.initState();

    getSetInitialUrl();
  }

  getSetInitialUrl() async {
    var sslcommerzUrlResponse = await PaymentRepository()
        .getSslcommerzBeginResponse(widget.payment_type, _combined_order_id,
            widget.package_id, widget.amount);

    if (sslcommerzUrlResponse.result == false) {
      ToastComponent.showDialog(sslcommerzUrlResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }

    _initial_url = sslcommerzUrlResponse.url;
    _initial_url_fetched = true;
    _webViewController.loadRequest(Uri.parse(_initial_url!),
        headers: commonHeader);

    setState(() {});

    //print(_initial_url);
    //print(_initial_url_fetched);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  void getData() {
    _webViewController
        .runJavaScriptReturningResult("document.body.innerText")
        .then((data) {
      var responseJSON = jsonDecode(data as String);
      if (responseJSON.runtimeType == String) {
        responseJSON = jsonDecode(responseJSON);
      }
      //print(data.toString());

      ToastComponent.showDialog(responseJSON["message"],
          duration: Toast.lengthLong, gravity: Toast.center);
      Navigator.pop(context);
    });
  }

  buildBody() {
/*    String initial_url =
        "${AppConfig.BASE_URL}/sslcommerz/begin?payment_type=${widget.payment_type}&combined_order_id=${_combined_order_id}&amount=${widget.amount}&user_id=${user_id.$}";*/

    //print("init url");
    //print(initial_url);

    if (_initial_url_fetched == false) {
      return Container(
        child: Center(
          child: Text(AppLocalizations.of(context)!.fetching_sslcommerz_url),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebViewWidget(
            controller: _webViewController,
          ),
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.pay_with_sslcommerz,
        style: TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
