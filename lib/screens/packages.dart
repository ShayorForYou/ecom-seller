import 'package:ecom_seller_app/const/app_style.dart';
import 'package:ecom_seller_app/custom/device_info.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/custom/route_transaction.dart';
import 'package:ecom_seller_app/custom/select_payment_list.dart';
import 'package:ecom_seller_app/custom/submitButton.dart';
import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/data_model/payment_type_response.dart';
import 'package:ecom_seller_app/data_model/seller_package_response.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/helpers/shimmer_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/payment_repository.dart';
import 'package:ecom_seller_app/repositories/shop_repository.dart';
import 'package:ecom_seller_app/screens/payments/bkash_screen.dart';
import 'package:ecom_seller_app/screens/payments/flutterwave_screen.dart';
import 'package:ecom_seller_app/screens/payments/iyzico_screen.dart';
import 'package:ecom_seller_app/screens/payments/nagad_screen.dart';
import 'package:ecom_seller_app/screens/payments/offline_payment_screen.dart';
import 'package:ecom_seller_app/screens/payments/paypal_screen.dart';
import 'package:ecom_seller_app/screens/payments/paystack_screen.dart';
import 'package:ecom_seller_app/screens/payments/paytm_screen.dart';
import 'package:ecom_seller_app/screens/payments/razorpay_screen.dart';
import 'package:ecom_seller_app/screens/payments/sslcommerz_screen.dart';
import 'package:ecom_seller_app/screens/payments/stripe_screen.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Packages extends StatefulWidget {
  const Packages({super.key});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  List<Package> _packages = [];
  bool _isFetchAllData = false;

  List<PaymentTypeResponse> _onlinePaymentList = [];
  final List<PaymentTypeResponse> _offlinePaymentList = [];
 final List<PaymentType> _paymentOptions = PaymentOption.getList();

  PaymentTypeResponse? _selectedOnlinePaymentTypeValue;
  PaymentTypeResponse? _selectedOfflinePaymentTypeValue;
  PaymentType? _selectedPaymentOption;

  Future<bool> getPackageList() async {
    var response = await ShopRepository().getSellerPackageRequest();
    _packages.addAll(response.data!);
    setState(() {});
    return true;
  }

  Future<bool> getOnlinePaymentList() async {
    var response = await PaymentRepository().getPaymentResponseList(list: "online",mode: "seller_package");

      _onlinePaymentList.addAll(response);
      print(response.length);


    if (_onlinePaymentList.isNotEmpty) {
      _selectedOnlinePaymentTypeValue = _onlinePaymentList.first;
    }
    setState(() {});
    return true;
  }


  Future<bool> getOfflinePaymentList() async {
    var response = await PaymentRepository().getPaymentResponseList(list: "offline",mode: "seller_package");

      _offlinePaymentList.addAll(response);


    if (_offlinePaymentList.isNotEmpty) {
      _selectedOfflinePaymentTypeValue = _offlinePaymentList.first;
    }
    setState(() {});
    return true;
  }

  Future<bool> sendFreePackageReq(id) async {
    var response = await ShopRepository().purchaseFreePackageRequest(id);
    ToastComponent.showDialog(response.message,
        gravity: Toast.center, duration: Toast.lengthLong);
    setState(() {});
    return true;
  }



  Future<bool> fetchData() async {
    getOnlinePaymentList();
    if (offline_payment_addon.$) {
      getOfflinePaymentList();
    }
    await getPackageList();
    _isFetchAllData = true;
    setState(() {});
    return true;
  }

  clearData() {
    _onlinePaymentList = [];
    _isFetchAllData = false;
    _packages = [];
    setState(() {});
  }

  Future<bool> resetData() {
    clearData();
    return fetchData();
  }

  Future<void> refresh() async {
    await resetData();
    return Future.delayed(const Duration(seconds: 0));
  }

  sendPaymentPage({int? package_id,String? payment_method_key, amount}) {
    switch (payment_method_key) {
      case "stripe":
        MyTransaction(context: context).push(
            StripeScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
          package_id: package_id.toString(),
        ));
        break;

      case "iyzico":
        MyTransaction(context: context).push(
            IyzicoScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
              package_id: package_id.toString(),
        ));
        break;

      case "bkash":
        MyTransaction(context: context).push(
            BkashScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
              package_id: package_id.toString(),
        ));
        break;

      case "nagad":
        MyTransaction(context: context).push(
            NagadScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
              package_id: package_id.toString(),
        ));
        break;

      case "paytm":
        MyTransaction(context: context).push(
            PaytmScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
              package_id: package_id.toString(),
        ));
        break;
      case "paypal":
        MyTransaction(context: context).push(PaypalScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
          package_id: package_id.toString(),
        ));
        break;
      case "sslcommerz":
        MyTransaction(context: context).push(SslCommerzScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
          package_id: package_id.toString(),
        ));
        break;
      case "flutterwave":
        MyTransaction(context: context).push(FlutterwaveScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
          package_id: package_id.toString(),
        ));
        break;
      case "paystack":
        MyTransaction(context: context).push(PaystackScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
          package_id: package_id.toString(),
        ));
        break;
      case "razorpay":
        MyTransaction(context: context).push(RazorpayScreen(
          amount: double.parse(amount.toString()),
          payment_method_key: payment_method_key,
          payment_type: "seller_package_payment",
          package_id: package_id.toString(),
        ));
        break;

      default:
        print("Die ");
        print("$payment_method_key ");
        break;
    }
  }

  @override
  void initState() {
    _selectedPaymentOption = _paymentOptions.first;
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              context: context,
              title: LangText(context: context)
                  .getLocal()
                  .premium_package_for_seller_ucf)
          .show(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
            child: buildList(),
          ),
        ),
      ),
    );
  }

  ListView buildList() {
    return _isFetchAllData
        ? ListView.builder(
            itemCount: _packages.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return packageItem(
                index,
                context,
                _packages[index].logo,
                _packages[index].name!,
                _packages[index].amount!,
                _packages[index].duration.toString(),
                _packages[index].productUploadLimit.toString(),
                _packages[index].price,
                _packages[index].id,
              );
            })
        : loadingShimmer() as ListView;
  }

  Widget loadingShimmer() {
    return ShimmerHelper().buildListShimmer(item_count: 10, item_height: 170.0);
  }

  Widget packageItem(int index,BuildContext context, String? url, String packageName,
      String packagePrice, String packageDate, String packageProduct, price,packageId) {
    print(url);
    return MyWidget.customCardView(
      elevation: 5,
        margin: EdgeInsets.only(bottom: 20,top: index==0?20:0),
        padding: EdgeInsets.symmetric(vertical: 15),
        borderWidth: 1,

        height: 170.0,
        borderRadius: 6,
        width: DeviceInfo(context).getWidth(),
        borderColor: MyTheme.app_accent_border,
        backgroundColor: MyTheme.app_accent_color_extra_light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FadeInImage.assetNetwork(
            //   placeholder: "assets/logo/placeholder.png",
            //   image: url,
            //   height: 30,
            //   imageErrorBuilder: (context, object, stackTrace) {
            //     return Container(
            //       height: 30,
            //       width: 30,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           image:const DecorationImage(
            //               image: AssetImage("assets/logo/placeholder.png"),
            //               fit: BoxFit.cover
            //           )
            //       ),
            //     );
            //   },
            //   width: 30,
            //   fit: BoxFit.cover,
            // ),

            MyWidget.imageWithPlaceholder(width: 30.0, height: 30.0, url: url,backgroundColor: MyTheme.noColor),
            Text(
              packageName,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              width: DeviceInfo(context).getWidth() / 2,
              child: SubmitBtn.show(
                  height: 30,
                  width: DeviceInfo(context).getWidth() / 3,
                  onTap: () {
                    if(double.parse(price.toString())<=0){
                      sendFreePackageReq(packageId);
                      return;
                    }
                    if (offline_payment_addon.$) {
                      selectPaymentOption(price,packageId);
                    } else {
                      selectOnlinePaymentType(price,packageId);
                    }
                  },
                  backgroundColor: MyTheme.app_accent_color,
                  radius: 3.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        packagePrice,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.white),
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        "/",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.white),
                      ),
                      Text(
                        '$packageDate${LangText(context: context)
                                .getLocal()
                                .days_ucf}',
                        style: TextStyle(
                            fontSize: 10, color: MyTheme.light_grey),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  )),
            ),
            SizedBox(
              width: DeviceInfo(context).getWidth() / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: MyTheme.app_accent_color,
                    size: 11,
                  ),
                  Text(
                    "$packageProduct ${LangText(context: context)
                            .getLocal()
                            .product_upload_limit_ucf}",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  selectOnlinePaymentType(amount,packageId) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: AlertDialog(
                title: Text(LangText(context: context)
                    .getLocal()
                    .select_payment_type_ucf),
                content: DropdownButton<PaymentTypeResponse>(
                  underline: Container(),
                  elevation: 2,
                  isExpanded: true,
                  items: _onlinePaymentList
                      .map<DropdownMenuItem<PaymentTypeResponse>>(
                          (paymentType) => DropdownMenuItem(
                                value: paymentType,
                                child: Text(paymentType.name!),
                              ))
                      .toList(),
                  value: _selectedOnlinePaymentTypeValue,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedOnlinePaymentTypeValue = newValue;
                    });
                  },
                ),
                actions: [
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.red,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LangText(context: context).getLocal().cancel_ucf,
                        style: TextStyle(color: MyTheme.white, fontSize: 12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.green,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                        sendPaymentPage(
                          payment_method_key: _selectedOnlinePaymentTypeValue!.payment_type_key,
                          amount: amount,
                          package_id: packageId
                        );
                      },
                      child: Text(
                          LangText(context: context).getLocal().continue_ucf,
                          style: TextStyle(color: MyTheme.white, fontSize: 12)),
                      padding: EdgeInsets.symmetric(horizontal: 5))
                ],
              ),
            );
          });
        });
  }

  selectOfflinePaymentType(amount,packageId) {

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: AlertDialog(
                title: Text(LangText(context: context)
                    .getLocal()
                    .select_payment_type_ucf),
                content: DropdownButton<PaymentTypeResponse>(
                  underline: Container(),
                  elevation: 2,
                  isExpanded: true,
                  items: _offlinePaymentList
                      .map<DropdownMenuItem<PaymentTypeResponse>>(
                          (paymentType) => DropdownMenuItem(
                                value: paymentType,
                                child: Text(paymentType.name!),
                              ))
                      .toList(),
                  value: _selectedOfflinePaymentTypeValue,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedOfflinePaymentTypeValue = newValue;
                    });
                  },
                ),
                actions: [
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.red,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LangText(context: context).getLocal().cancel_ucf,
                        style: TextStyle(color: MyTheme.white, fontSize: 12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.green,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                        MyTransaction(context: context).push(
                            OfflineScreen(details:_selectedOfflinePaymentTypeValue!.details, offline_payment_id:_selectedOfflinePaymentTypeValue!.offline_payment_id,rechargeAmount:double.parse(amount.toString()),
                            package_id: packageId,
                            ));
                        // sendPaymentPage(
                        //   payment_method_key: _selectedOnlinePaymentTypeValue.key,
                        //   amount: amount,
                        // );
                      },
                      child: Text(
                          LangText(context: context).getLocal().continue_ucf,
                          style: TextStyle(color: MyTheme.white, fontSize: 12)),
                      padding: EdgeInsets.symmetric(horizontal: 5))
                ],
              ),
            );
          });
        });
  }

  selectPaymentOption(amount,packageId) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: AlertDialog(
                title: Text(LangText(context: context)
                    .getLocal().select_payment_option_ucf),
                content: DropdownButton<PaymentType>(
                  underline: Container(),
                  elevation: 2,
                  isExpanded: true,
                  items: _paymentOptions
                      .map<DropdownMenuItem<PaymentType>>(
                          (paymentType) => DropdownMenuItem(
                                value: paymentType,
                                child: Text(paymentType.value),
                              ))
                      .toList(),
                  value: _selectedPaymentOption,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPaymentOption = newValue;
                    });
                    Navigator.pop(context);
                    if (_selectedPaymentOption!.key == "online") {
                      selectOnlinePaymentType(amount,packageId);
                    }
                    if (_selectedPaymentOption!.key == "offline") {
                      selectOfflinePaymentType(amount,packageId);
                     // MyTransaction(context: context).push(OfflineScreen());
                    }

                  },
                ),
                actions: [
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.red,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LangText(context: context).getLocal().cancel_ucf,
                        style: TextStyle(color: MyTheme.white, fontSize: 12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                ],
              ),
            );
          });
        });
  }
}
