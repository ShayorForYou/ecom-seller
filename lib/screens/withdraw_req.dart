import 'package:ecom_seller_app/custom/device_info.dart';
import 'package:ecom_seller_app/custom/input_decorations.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/custom/submitButton.dart';
import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/withdraw_repository.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';
import 'package:validators/validators.dart';

class SendAWithdrwRequest extends StatefulWidget {
  const SendAWithdrwRequest({super.key});

  @override
  State<SendAWithdrwRequest> createState() => _SendAWithdrwRequestState();
}

class _SendAWithdrwRequestState extends State<SendAWithdrwRequest> {
  sendRequest() async {
    var response =
        await WithdrawRepository().sendWithdrawReq(_message, _amount);
    if (response.result!) {
      ToastComponent.showDialog(response.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      cleanAll();
    } else {
      ToastComponent.showDialog(response.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  String? _message, _amount;
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  List<String> _errors = [];

  cleanAll() {
    _message = "";
    _amount = "";
    _messageTextController.text = "";
    _amountTextController.text = "";
    _errors = [];
    setState(() {});
  }

  checkData() {
    _errors = [];
    _message = _messageTextController.text.trim();
    _amount = _amountTextController.text.trim();

    if (!isNumeric(_amount!) || _amount!.isEmpty) {
      _errors.add(LangText(context: context).getLocal().amount_is_invalid);
    }
    if (_message!.isEmpty) {
      _errors.add(LangText(context: context).getLocal().message_is_invalid);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              context: context,
              title: LangText(context: context)
                  .getLocal()
                  .send_withdraw_request_ucf)
          .show(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LangText(context: context).getLocal().amount_ucf,
                    style: TextStyle(
                        fontSize: 12,
                        color: MyTheme.font_grey,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyWidget.customCardView(
                    backgroundColor: MyTheme.white,
                    width: DeviceInfo(context).getWidth(),
                    height: 45,
                    borderRadius: 10,
                    elevation: 5,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _amountTextController,
                      decoration: InputDecorations.buildInputDecoration_1(
                          hint_text:
                              LangText(context: context).getLocal().amount_ucf,
                          borderColor: MyTheme.noColor,
                          hintTextColor: MyTheme.grey_153),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LangText(context: context).getLocal().message_ucf,
                    style: TextStyle(
                        fontSize: 12,
                        color: MyTheme.font_grey,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyWidget.customCardView(
                    width: DeviceInfo(context).getWidth(),
                    backgroundColor: MyTheme.white,
                    borderRadius: 6,
                    elevation: 5,
                    height: 80,
                    padding: EdgeInsets.all(6),
                    borderColor: MyTheme.light_grey,
                    child: TextField(
                      controller: _messageTextController,
                      decoration: InputDecoration.collapsed(
                          hintText: LangText(context: OneContext().context)
                              .getLocal()
                              .type_your_message_here,
                          hintStyle:
                              TextStyle(color: MyTheme.grey_153, fontSize: 12)),
                      maxLines: 6,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    _errors.length,
                    (index) => Text(
                          _errors[index],
                          style: TextStyle(fontSize: 15, color: MyTheme.red),
                        )),
              ),
              Container(
                width: DeviceInfo(context).getWidth(),
                alignment: Alignment.topRight,
                child: SubmitBtn.show(
                    elevation: 10,
                    height: 30.0,
                    alignment: Alignment.center,
                    width: 120.0,
                    child: Text(
                      LangText(context: context).getLocal().submit_ucf,
                      style: TextStyle(color: MyTheme.white, fontSize: 13),
                    ),
                    backgroundColor: MyTheme.app_accent_color,
                    onTap: () {
                      checkData();
                      if (_errors.isEmpty) {
                        sendRequest();
                      }
                    },
                    radius: 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
