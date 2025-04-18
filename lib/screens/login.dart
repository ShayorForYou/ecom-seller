import 'package:ecom_seller_app/custom/buttons.dart';
import 'package:ecom_seller_app/custom/input_decorations.dart';
import 'package:ecom_seller_app/custom/intl_phone_input.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/helpers/auth_helper.dart';
import 'package:ecom_seller_app/helpers/main_helper.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/address_repository.dart';
import 'package:ecom_seller_app/repositories/auth_repository.dart';
import 'package:ecom_seller_app/screens/main.dart';
import 'package:ecom_seller_app/screens/password_forget.dart';
import 'package:ecom_seller_app/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String? _phone = "";
  late BuildContext loadingContext;
  var countries_code = <String?>[];

  //controllers
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  MyWidget? myWidget;

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
    super.initState();
    if (otp_addon_installed.$) {
      fetch_country();
    }
    /*if (is_logged_in.value == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }*/
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog(
          LangText(context: OneContext().context).getLocal().enter_email,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          LangText(context: OneContext().context).getLocal().enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog(
          LangText(context: OneContext().context).getLocal().enter_password,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    loading();
    var loginResponse = await AuthRepository().getLoginResponse(
        _login_by == 'email' ? email : _phone, password, _login_by);
    print('email ${_login_by == 'email' ? email : _phone}');
    Navigator.pop(loadingContext);

    if (loginResponse.result == true) {
      if (loginResponse.message.runtimeType == List) {
        ToastComponent.showDialog(loginResponse.message!.join("\n"),
            gravity: Toast.center, duration: 3);
        return;
      }

      ToastComponent.showDialog(loginResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(loginResponse);

      access_token.load().whenComplete(() {
        if (access_token.$!.isNotEmpty) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return Main();
            },
          ), (route) => false);
        }
      });
    } else {
      ToastComponent.showDialog(loginResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  @override
  Widget build(BuildContext context) {
    myWidget = MyWidget(myContext: context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: MyTheme.white,
        body: buildBody(context),
      ),
    );
  }

  buildBody(context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            // Text(
            //   LangText(context: context).getLocal().hi_welcome_to_all_lower,
            //   style: const TextStyle(
            //       color: MyTheme.app_accent_border,
            //       fontSize: 20,
            //       fontWeight: FontWeight.w300),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: MyTheme.app_accent_border),
                    //     borderRadius: BorderRadius.circular(10)),
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      "assets/logo/seller.png",
                      height: 48,
                      width: 36,
                    )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 40,
                bottom: 30.0,
              ),
              // child: Text(
              //   LangText(context: context)
              //       .getLocal().login_to_your_account_all_lower,
              //   style: const TextStyle(
              //       color: MyTheme.app_accent_color,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w300),
              // ),
            ),

            // login form container
            SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      _login_by == "email"
                          ? LangText(context: context).getLocal().email_ucf
                          : LangText(context: context)
                              .getLocal()
                              .login_screen_phone,
                      style: const TextStyle(
                          color: MyTheme.app_accent_color,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ),
                  if (_login_by == "email")
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    const Color.fromRGBO(255, 255, 255, 0.5)),
                            child: TextField(
                              style: const TextStyle(
                                  color: MyTheme.app_accent_color),
                              controller: _emailController,
                              autofocus: false,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      borderColor: MyTheme.noColor,
                                      fillColor:
                                          MyTheme.app_accent_color_extra_light,
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
                                color:
                                    const Color.fromRGBO(255, 255, 255, 0.5)),
                            height: 36,
                            child: CustomInternationalPhoneNumberInput(
                              countries: countries_code,
                              onInputChanged: (PhoneNumber number) {
                                if (countries_code.contains('BD')) {
                                  setState(() {
                                    _phone = number.parseNumber();
                                  });
                                }
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
                                  const TextStyle(color: MyTheme.font_grey),
                              textStyle:
                                  TextStyle(color: MyTheme.app_accent_color),
                              initialValue: phoneCode,
                              textFieldController: _phoneNumberController,
                              formatInput: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                    Row(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      getLocal(context).password_ucf,
                      style: const TextStyle(
                          color: MyTheme.app_accent_color,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(255, 255, 255, 0.5)),
                          height: 36,
                          child: TextField(
                            controller: _passwordController,
                            autofocus: false,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: const TextStyle(
                                color: MyTheme.app_accent_color),
                            decoration: InputDecorations.buildInputDecoration_1(
                                borderColor: MyTheme.noColor,
                                hint_text: "• • • • • • • •",
                                fillColor: MyTheme.app_accent_color_extra_light,
                                hintTextColor: MyTheme.dark_grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PasswordForget();
                              }));
                            },
                            child: Text(
                              getLocal(context).forget_password_ucf,
                              style: const TextStyle(
                                  color: MyTheme.app_accent_color,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.app_accent_border, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: Buttons(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: MyTheme.app_accent_color.withOpacity(0.8),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(11.0),
                          ),
                        ),
                        child: Text(
                          getLocal(context).log_in,
                          style: TextStyle(
                              color: MyTheme.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          onPressedLogin();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Registration();
                    }));
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                          fontSize: 12, color: MyTheme.app_accent_color),
                      children: [
                        TextSpan(
                          text: 'Register here',
                          style: TextStyle(
                              fontSize: 12,
                              color: MyTheme.app_accent_color,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   LangText(context: context)
                  //       .getLocal().in_case_of_any_difficulties_contact_with_admin,
                  //   style:
                  //       const TextStyle(fontSize: 12, color: MyTheme.app_accent_color),
                  // ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     top: 20,
            //   ),
            //   child: Container(
            //     alignment: Alignment.center,
            //     child: Text(
            //       LangText(context: context).getLocal()!.or,
            //       style:
            //           TextStyle(fontSize: 12, color: MyTheme.app_accent_border),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: Container(
            //     alignment: Alignment.center,
            //     height: 45,
            //     child: Buttons(
            //       alignment: Alignment.center,
            //       //width: MediaQuery.of(context).size.width,
            //       height: 50,
            //       //color: Colors.white.withOpacity(0.8),
            //       child: Text(
            //         LangText(context: context).getLocal()!.registration,
            //         style: TextStyle(
            //             color: MyTheme.white,
            //             fontSize: 17,
            //             fontWeight: FontWeight.w500,
            //             decoration: TextDecoration.underline),
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => Registration()));
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  loading() {
    showDialog(
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
