import 'package:ecom_seller_app/custom/buttons.dart';
import 'package:ecom_seller_app/custom/input_decorations.dart';
import 'package:ecom_seller_app/custom/intl_phone_input.dart';
import 'package:ecom_seller_app/custom/loading.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/helpers/main_helper.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/address_repository.dart';
import 'package:ecom_seller_app/repositories/auth_repository.dart';
import 'package:ecom_seller_app/screens/password_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:toast/toast.dart';

class PasswordForget extends StatefulWidget {
  const PasswordForget({super.key});

  @override
  _PasswordForgetState createState() => _PasswordForgetState();
}

class _PasswordForgetState extends State<PasswordForget> {
  String _send_code_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US');
  var countries_code = <String?>[];
  String? _phone = "";

  //controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  fetch_country() async {
    var data = await AddressRepository().getCountryList();
    data.countries!.forEach((c) => countries_code.add(c.code));
    phoneCode = PhoneNumber(isoCode: data.countries!.first.code);
    setState(() {});
  }

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    fetch_country();
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressSendCode() async {
    var email = _emailController.text.toString();

    var regEx = RegExp(r'^[A-Za-z0-9+_.-]+@(.+)+.(.+)$');

    print(regEx.hasMatch(email));
    if (_send_code_by == 'email' && (email == "" || !regEx.hasMatch(email))) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_email,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_send_code_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_phone_number_ucf,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    Loading.setInstance(context);
    Loading().show();
    var passwordForgetResponse = await AuthRepository()
        .getPasswordForgetResponse(
            _send_code_by == 'email' ? email : _phone, _send_code_by);

    Loading().hide();
    if (passwordForgetResponse.result == false) {
      ToastComponent.showDialog(passwordForgetResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(passwordForgetResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PasswordOtp(
          verify_by: _send_code_by,
          email: email,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: MyTheme.font_grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: MyTheme.white,
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset('assets/logo/seller.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  getLocal(context).forget_password_ucf,
                  style: TextStyle(
                      color: MyTheme.app_accent_color,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: screenWidth * (3 / 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        _send_code_by == "email"
                            ? getLocal(context).email_ucf
                            : getLocal(context).phone_ucf,
                        style: const TextStyle(
                            color: MyTheme.app_accent_color,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),
                    if (_send_code_by == "email")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 36,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(255, 255, 255, 0.5)),
                              child: TextField(
                                style: TextStyle(color: MyTheme.app_accent_color),
                                controller: _emailController,
                                autofocus: false,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        borderColor: MyTheme.noColor,
                                        fillColor: MyTheme.app_accent_color_extra_light,
                                        hint_text: LangText(context: context)
                                            .getLocal()
                                            .sellerexample,
                                        hintTextColor: MyTheme.dark_grey),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(255, 255, 255, 0.5)),
                              height: 36,
                              child: CustomInternationalPhoneNumberInput(
                                countries: countries_code,
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                  setState(() {
                                    _phone = number.phoneNumber;
                                  });
                                },
                                onInputValidated: (bool value) {
                                  print('on input validation $value');
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle:
                                    TextStyle(color: MyTheme.font_grey),
                                textStyle: TextStyle(color: MyTheme.app_accent_color),
                                initialValue: phoneCode,
                                textFieldController: _phoneNumberController,
                                formatInput: true,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                inputDecoration:
                                    InputDecorations.buildInputDecoration_phone(
                                        hint_text: "01XXX XXX XXX"),
                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (otp_addon_installed.$)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _send_code_by = _send_code_by == "email"
                                      ? "phone"
                                      : "email";
                                });
                              },
                              child: Text(
                                "or, Login with ${_send_code_by == "email" ? 'a phone' : 'an email'}",
                                style: TextStyle(
                                    color: MyTheme.app_accent_color,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      _send_code_by == "email"
                          ? LangText(context: context)
                              .getLocal()
                              .we_will_send_you_a_OTP_code_if_the_mail_id_is_correct_ucf
                          : LangText(context: context)
                              .getLocal()
                              .we_will_send_you_a_OTP_code_if_the_phone_no_is_correct_ucf,
                      style: TextStyle(
                        fontSize: 12,
                        color: MyTheme.grey_153,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      softWrap: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: MyTheme.textfield_grey, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        child: Buttons(
                          width: MediaQuery.of(context).size.width,
                          //height: 50,
                          color: MyTheme.app_accent_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: Text(
                            getLocal(context).send_code_ucf,
                            style: TextStyle(
                                color: MyTheme.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            onPressSendCode();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
