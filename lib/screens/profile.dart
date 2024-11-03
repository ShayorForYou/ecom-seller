import 'package:ecom_seller_app/custom/buttons.dart';
import 'package:ecom_seller_app/custom/input_decorations.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/helpers/file_helper.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../custom/device_info.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final ScrollController _mainScrollController = ScrollController();

  String? avatar_original = "";

  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  sellerInfo() async {
    var response = await ProfileRepository().getSellerInfo();
    _nameController.text = response.name.toString();
    avatar_original = response.avatarOriginal;
    setState(() {});
  }

  chooseAndUploadImage(context) async {
    try {
      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      _file = await _picker.pickImage(source: ImageSource.gallery);

      if (_file == null) {
        ToastComponent.showDialog(AppLocalizations.of(context)!.no_file_is_chosen,
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      //return;
      String base64Image = FileHelper.getBase64FormateFile(_file!.path);
      String fileName = _file!.path.split("/").last;

      var profileImageUpdateResponse =
      await ProfileRepository().getProfileImageUpdateResponse(
        base64Image,
        fileName,
      );

      if (profileImageUpdateResponse.result == false) {
        ToastComponent.showDialog(profileImageUpdateResponse.message!,
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      } else {
        ToastComponent.showDialog(profileImageUpdateResponse.message!,
            gravity: Toast.center, duration: Toast.lengthLong);
        avatar_original = profileImageUpdateResponse.path;

        setState(() {});
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> _onPageRefresh() async {}

  onPressUpdate() async {
    var name = _nameController.text.toString();
    var password = _passwordController.text.toString();
    var passwordConfirm = _passwordConfirmController.text.toString();

    var changePassword = password != "" ||
        passwordConfirm !=
            ""; // if both fields are empty we will not change user's password

    if (name == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_your_name,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (changePassword && password == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_password,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    if (changePassword && passwordConfirm == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.confirm_your_password,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (changePassword && password.length < 6) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!
              .password_must_contain_at_least_6_characters,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (changePassword && password != passwordConfirm) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.passwords_do_not_match,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    var profileUpdateResponse =
        await ProfileRepository().getProfileUpdateResponse(
      name,
      changePassword ? password : "",
    );

    if (profileUpdateResponse.result == false) {
      ToastComponent.showDialog(profileUpdateResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(profileUpdateResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
      setState(() {});
    }
  }

  @override
  void initState() {
    sellerInfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          context: context,
          title: AppLocalizations.of(context)!.edit_profile_ucf,
        ).show(),
        body: buildBody(context),
      ),
    );
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
        AppLocalizations.of(context)!.edit_profile_ucf,
        style: const TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildBody(context) {
    // return Center(
    //   child: OrgChart<Map>(
    //     cornerRadius: 10,
    //     curve: Curves.easeInOut,
    //     controller: orgChartController,
    //     isDraggable: false,
    //     linePaint: Paint()
    //       ..color = Colors.black
    //       ..strokeWidth = 5
    //       ..style = PaintingStyle.stroke,
    //     // onTap: (item) {
    //     //   orgChartController.addItem({
    //     //     "id": orgChartController.uniqueNodeId,
    //     //     "text": 'New Block',
    //     //     "to": item["id"],
    //     //   });
    //     //   setState(() {});
    //     // },
    //     // onDoubleTap: (item) async {
    //     // String? text = await getBlockText(context, item);
    //     // if (text != null) setState(() => item["text"] = text);
    //     // },
    //     builder: (details) {
    //       print(details.item);
    //       return GestureDetector(
    //         child: Card(
    //           elevation: 5,
    //           // color: details.isBeingDragged
    //           //     ? Colors.green.shade100
    //           //     : details.isOverlapped
    //           //         ? Colors.red.shade200
    //           //         : Colors.teal.shade50,
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 16.0),
    //             child: Center(
    //                 child: Column(
    //               children: [
    //                 Text(
    //                   details.item["text"],
    //                   textAlign: TextAlign.center,
    //                   style: const TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //                 const SizedBox(height: 8),
    //                 Text("Responsibility: ${details.item["role"]}",
    //                     textAlign: TextAlign.center,
    //                     style: const TextStyle(color: Colors.black)),
    //               ],
    //             )),
    //           ),
    //         ),
    //       );
    //     },
        // optionsBuilder: (item) {
        //   return [
        //     const PopupMenuItem(value: 'Remove', child: Text('Remove')),
        //   ];
        // },
        // onOptionSelect: (item, value) {
        //   if (value == 'Remove') {
        //     orgChartController.removeItem(
        //         item["id"], ActionOnNodeRemoval.unlink);
        //   }
        // },
        // onDrop: (dragged, target, isTargetSubnode) {
        //   if (isTargetSubnode) {
        //     showDialog(
        //         context: context,
        //         builder: (_) {
        //           return AlertDialog(
        //               title: const Text('Error'),
        //               content:
        //                   const Text('You cannot drop a node on a subnode'),
        //               actions: [
        //                 TextButton(
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                   },
        //                   child: const Text('OK'),
        //                 ),
        //               ]);
        //         });
        //     orgChartController.calculatePosition();
        //
        //     return;
        //   }
        //   dragged["to"] = target["id"];
        //   orgChartController.calculatePosition();
        // },
    //   ),
    // );
    if (!is_logged_in.$) {
      return SizedBox(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.please_log_in_to_see_the_profile,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      return RefreshIndicator(
        color: MyTheme.app_accent_color,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        displacement: 10,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                buildTopSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 24,
                  ),
                ),
                buildProfileForm(context)
              ]),
            )
          ],
        ),
      );
    }
  }

  buildTopSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Stack(
            children: [
              MyWidget.roundImageWithPlaceholder(
                  height: 120.0,
                  width: 120.0,
                  borderRadius: 60,
                  url: avatar_original),
              /* Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: Color.fromRGBO(112, 112, 112, .3), width: 2),
                  //shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image:  "${avatar_original.$}",
                      fit: BoxFit.fill,
                    )),
              ),*/
              Positioned(
                right: 8,
                bottom: 8,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Buttons(
                    padding: const EdgeInsets.all(0),
                    shape: CircleBorder(
                      side:
                          BorderSide(color: MyTheme.light_grey, width: 1.0),
                    ),
                    color: MyTheme.light_grey,
                    onPressed: () {
                      chooseAndUploadImage(context);
                    },
                    child: const Icon(
                      Icons.edit,
                      color: MyTheme.font_grey,
                      size: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  buildProfileForm(context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!.basic_information_ucf,
                style: const TextStyle(
                    color: MyTheme.grey_153,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLocalizations.of(context)!.name_ucf,
                style: const TextStyle(
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
                  controller: _nameController,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "John Doe",
                      borderColor: MyTheme.light_grey,
                      hintTextColor: MyTheme.grey_153),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLocalizations.of(context)!.password_ucf,
                style: const TextStyle(
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyWidget.customCardView(
                    backgroundColor: MyTheme.white,
                    width: DeviceInfo(context).getWidth(),
                    height: 45,
                    borderRadius: 10,
                    elevation: 5,
                    child: TextField(
                      controller: _passwordController,
                      autofocus: false,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecorations.buildInputDecoration_1(
                          hint_text: "• • • • • • • •",
                          borderColor: MyTheme.light_grey,
                          hintTextColor: MyTheme.grey_153),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .password_must_contain_at_least_6_characters,
                    style: TextStyle(
                        color: MyTheme.textfield_grey,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLocalizations.of(context)!.retype_password_ucf,
                style: const TextStyle(
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
                  controller: _passwordConfirmController,
                  autofocus: false,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "• • • • • • • •",
                      borderColor: MyTheme.light_grey,
                      hintTextColor: MyTheme.grey_153),
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    width: 120,
                    height: 36,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Buttons(
                      width: MediaQuery.of(context).size.width,
                      //height: 50,
                      color: MyTheme.app_accent_color,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Text(
                        AppLocalizations.of(context)!.update_profile_ucf,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressUpdate();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
