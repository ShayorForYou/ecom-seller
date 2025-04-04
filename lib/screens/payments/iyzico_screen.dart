import 'package:ecom_seller_app/app_config.dart';
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

class IyzicoScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String? payment_method_key;
  String? package_id;

  IyzicoScreen(
      {super.key,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = "",
      this.package_id});

  @override
  _IyzicoScreenState createState() => _IyzicoScreenState();
}

class _IyzicoScreenState extends State<IyzicoScreen> {
  final int _combined_order_id = 0;
  final bool _order_init = false;
  String initial_url = "";
  late WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_url =
        "${AppConfig.BASE_URL}/iyzico/init?payment_type=${widget.payment_type}&combined_order_id=$_combined_order_id&amount=${widget.amount}&user_id=${seller_id.$}&package_id=${widget.package_id}";

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (page) {
            print(page.toString());
            getData();
          },
        ),
      )
      ..loadRequest(Uri.parse(initial_url), headers: commonHeader);
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
    print('called.........');
    String? paymentDetails = '';
    _webViewController
        .runJavaScriptReturningResult("document.body.innerText")
        .then((data) {
      var responseJSON = jsonDecode(data as String);
      if (responseJSON.runtimeType == String) {
        responseJSON = jsonDecode(responseJSON);
      }
      try {
        if (responseJSON["result"] == false) {
          ToastComponent.showDialog(responseJSON["message"],
              duration: Toast.lengthLong, gravity: Toast.center);

          Navigator.pop(context);
        } else if (responseJSON["result"] == true) {
          print("a");
          paymentDetails = responseJSON['payment_details'];
          onPaymentSuccess(paymentDetails);
        }
      } on Exception {
        print("error");
        // TODO
      }
    });
  }

  onPaymentSuccess(paymentDetails) async {
    print("b");

    var iyzicoPaymentSuccessResponse = await PaymentRepository()
        .getIyzicoPaymentSuccessResponse(widget.payment_type, widget.amount,
            _combined_order_id, paymentDetails);

    if (iyzicoPaymentSuccessResponse.result == false) {
      print("c");
      ToastComponent.showDialog(iyzicoPaymentSuccessResponse.message!,
          duration: Toast.lengthLong, gravity: Toast.center);
      Navigator.pop(context);
      return;
    }
    print("Success package Payment");

    ToastComponent.showDialog(iyzicoPaymentSuccessResponse.message!,
        duration: Toast.lengthLong, gravity: Toast.center);
    if (widget.payment_type == "cart_payment") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
            //return OrderList(from_checkout: true);
          } as Widget Function(BuildContext)));
    } else if (widget.payment_type == "wallet_payment") {
      print("d");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
            //return Wallet(from_recharge: true);
          } as Widget Function(BuildContext)));
    }
  }

  buildBody() {
    //print("init url");
    //print(initial_url);

    if (_order_init == false &&
        _combined_order_id == 0 &&
        widget.payment_type == "cart_payment") {
      return Container(
        child: Center(
          child: Text(AppLocalizations.of(context)!.no_ucf),
        ),
      );
    } else {
      return SizedBox.expand(
        child: Container(
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
        AppLocalizations.of(context)!.pay_with_iyzico,
        style: TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
