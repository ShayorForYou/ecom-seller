
import 'package:ecom_seller_app/custom/buttons.dart';
import 'package:ecom_seller_app/custom/dialog_box.dart';
import 'package:ecom_seller_app/custom/input_decorations.dart';
import 'package:ecom_seller_app/custom/intl_phone_input.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/helpers/aiz_route.dart';
import 'package:ecom_seller_app/helpers/auth_helper.dart';
import 'package:ecom_seller_app/middlewares/mail_verification_route_middleware.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/address_repository.dart';
import 'package:ecom_seller_app/repositories/auth_repository.dart';
import 'package:ecom_seller_app/screens/login.dart';
import 'package:ecom_seller_app/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String _phone = "";
  late BuildContext loadingContext;
  var countries_code = <String>[];

  //controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  MyWidget? myWidget;
  final bool _isCaptchaShowing = false;
  String googleRecaptchaKey = "";

  onPressReg() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPassController.text.trim();
    String shopName = shopNameController.text.trim();
    String address = addressController.text.trim();
    loading();

    var response = await AuthRepository().getRegResponse(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      shopName: shopName,
      address: address,
      // capchaKey: googleRecaptchaKey
    );
    Navigator.pop(loadingContext);

    if (response.result!) {
      if (response.result != null && response.result!) {
        AuthHelper().setUserData(response);
        AIZRoute.pushAndRemoveAll(context, Main(),
            middleware: MailVerificationRouteMiddleware());
      } else {
        AIZRoute.pushAndRemoveAll(context, Login());
      }
    } else {
      if (context.mounted) {
        DialogBox.warningShow(context, response.message);
      }
    }
  }

  fetch_country() async {
    var data = await AddressRepository().getCountryList();
    data.countries!.forEach((c) => countries_code.add(c.code));
    phoneCode = PhoneNumber(isoCode: data.countries!.first.code);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyTheme.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: MyTheme.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: MyTheme.white,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              LangText(context: context).getLocal().registration,
              style: const TextStyle(
                  color: MyTheme.app_accent_color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            spacer(height: 24),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: MyTheme.noColor)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: Text(
                      LangText(context: context).getLocal().personal_info_ucf,
                      style: const TextStyle(
                          color: MyTheme.app_accent_color,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Container(height: 1,color: MyTheme.medium_grey,),
                  spacer(height: 14),
                  inputFieldModel(
                      LangText(context: context).getLocal().name_ucf,
                      "Mr. Jhon",
                      nameController),
                  spacer(height: 14),

                  if (_login_by == "email")
                    inputFieldModel(
                        LangText(context: context).getLocal().email_ucf,
                        "seller@example.com",
                        emailController)
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phone',
                            style: TextStyle(
                                color: MyTheme.app_accent_color,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromRGBO(255, 255, 255, 0.5)),
                            height: 36,
                            child: CustomInternationalPhoneNumberInput(
                              countries: countries_code,
                              onInputChanged: (PhoneNumber number) {
                                print(number.phoneNumber);
                                setState(() {
                                  _phone = number.phoneNumber!;
                                });
                              },
                              onInputValidated: (bool value) {
                                print('on input validation $value');
                              },
                              selectorConfig: const SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle:
                                  const TextStyle(color: MyTheme.font_grey, backgroundColor: Colors.white),
                              textStyle: const TextStyle(
                                  color: MyTheme.app_accent_color),
                              initialValue: phoneCode,
                              textFieldController: _phoneNumberController,
                              formatInput: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              inputDecoration:
                                  InputDecorations.buildInputDecoration_phone(
                                hint_text: "01XXX XXX XXX",
                              ),
                              onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  spacer(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _login_by =
                                  _login_by == "email" ? "phone" : "email";
                            });
                          },
                          child: Text(
                            "or, Login with ${_login_by == "email" ? 'a phone' : 'an email'}",
                            style: const TextStyle(
                                color: MyTheme.app_accent_color,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spacer(height: 14),
                  inputFieldModel(
                      LangText(context: context).getLocal().password_ucf,
                      "● ● ● ● ●",
                      passwordController,
                      isPassword: true),
                  spacer(height: 14),
                  inputFieldModel(
                      LangText(context: context)
                          .getLocal()
                          .confirm_your_password,
                      "● ● ● ● ●",
                      confirmPassController,
                      isPassword: true),
                  spacer(height: 14),
                ],
              ),
            ),
            spacer(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: MyTheme.noColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: Text(
                      LangText(context: context).getLocal().basic_info_ucf,
                      style: const TextStyle(
                          color: MyTheme.app_accent_color,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //Container(height: 1,color: MyTheme.medium_grey,),
                  spacer(height: 14),
                  inputFieldModel(
                      LangText(context: context).getLocal().shop_name,
                      "Shop",
                      shopNameController),
                  spacer(height: 14),
                  inputFieldModel(
                      LangText(context: context).getLocal().address_ucf,
                      "Dhaka",
                      addressController),
                  spacer(height: 14),
                ],
              ),
            ),
            // if (google_recaptcha.$)
            //   Container(
            //     padding: EdgeInsets.only(left: 0, right: 0, top: 14),
            //     height: _isCaptchaShowing ? 360 : 60,
            //     width: 300,
            //     child: Captcha(
            //       (keyValue) {
            //         googleRecaptchaKey = keyValue;
            //       },
            //       handleCaptcha: (data) {
            //         if (_isCaptchaShowing.toString() != data) {
            //           _isCaptchaShowing = data;
            //           setState(() {});
            //         }
            //       },
            //       isIOS: Platform.isIOS,
            //     ),
            //   ),
            spacer(height: 20),
            Buttons(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              color: MyTheme.app_accent_color,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(11.0),
                ),
              ),
              child: Text(
                LangText(context: context).getLocal().registration,
                style: TextStyle(
                    color: MyTheme.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                onPressReg();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetch_country();
  }

  Widget inputFieldModel(
      String title, String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: MyTheme.app_accent_color,
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(255, 255, 255, 0.5)),
            child: TextField(
              style: const TextStyle(color: MyTheme.app_accent_color),
              controller: controller,
              autofocus: false,
              obscureText: isPassword,
              decoration: InputDecorations.buildInputDecoration_1(
                  borderColor: MyTheme.noColor,
                  fillColor: MyTheme.app_accent_color_extra_light,
                  hint_text: hint,
                  hintTextColor: MyTheme.dark_grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget spacer({height = 24}) {
    return SizedBox(
      height: double.parse(height.toString()),
    );
  }

  loading() {
    return showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                width: 10,
              ),
              Text(AppLocalizations.of(context)!.please_wait_ucf),
            ],
          ));
        });
  }
}
