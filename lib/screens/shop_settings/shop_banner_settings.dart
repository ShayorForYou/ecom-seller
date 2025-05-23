import 'dart:convert';
import 'package:ecom_seller_app/custom/buttons.dart';
import 'package:ecom_seller_app/custom/device_info.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/custom/submitButton.dart';
import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/data_model/uploaded_file_list_response.dart';
import 'package:ecom_seller_app/helpers/main_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/shop_repository.dart';
import 'package:ecom_seller_app/screens/uploads/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class ShopBannerSettings extends StatefulWidget {
  const ShopBannerSettings({super.key});

  @override
  State<ShopBannerSettings> createState() => _ShopBannerSettingsState();
}

class _ShopBannerSettingsState extends State<ShopBannerSettings> {
  late BuildContext loadingContext;

  List<String> _imageUrls = [];

  List<String> _imageIds = [];
  List<String> _errors = [];

  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  Future<bool> _getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
    Navigator.pop(loadingContext);

    _imageUrls.addAll(response.shopInfo!.sliders!);

    if (response.shopInfo!.slidersId != null) {
      _imageIds = response.shopInfo!.slidersId.split(",");
    }

    print(_imageIds.join(','));
    setState(() {});
    return true;
  }

  updateInfo() async {
    var postBody = jsonEncode({
      "sliders": _imageIds.join(','),
    });
    loadingShow(context);
    var response = await ShopRepository().updateShopSetting(postBody);
    Navigator.pop(loadingContext);

    ToastComponent.showDialog(response.message,
        bgColor: MyTheme.white,
        duration: Toast.lengthLong,
        gravity: Toast.center);
  }

  resetData() {
    cleanData();
    faceData();
  }

  cleanData() {
    _imageUrls = [];
    _imageIds = [];
    _errors = [];
    //for image uploading
  }

  faceData() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadingShow(context));
    _getAccountInfo();
  }

  chooseAndUploadImage(context) async {
    List<FileInfo>? fileInfo = await Navigator.push<List<FileInfo>>(
        context,
        MaterialPageRoute(
            builder: (context) => const UploadFile(
                  fileType: "image",
                  canSelect: true,
                  canMultiSelect: true,
                )));
    if (fileInfo != null && fileInfo.isNotEmpty) {
      for (var element in fileInfo) {
        _imageIds.add(element.id.toString());
        _imageUrls.add(element.url!);
      }

      setState(() {});
    }
  }

  formValidation() {
    _errors = [];
    if (_imageIds.isEmpty) {
      _errors.add(
          LangText(context: context).getLocal().shop_banner_image_is_required);
    }
    setState(() {});
  }

  Future onRefresh() {
    faceData();
    return Future.delayed(Duration(seconds: 0));
  }

  @override
  void initState() {
    faceData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              context: context,
              title: LangText(context: context).getLocal().banner_settings)
          .show(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      LangText(context: context).getLocal().banner_1500_x_450,
                      style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.font_grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Buttons(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        chooseAndUploadImage(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: MyWidget().myContainer(
                          width: DeviceInfo(context).getWidth(),
                          height: 36,
                          borderRadius: 6.0,
                          borderColor: MyTheme.light_grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  getLocal(context).choose_file,
                                  style: TextStyle(
                                      fontSize: 12, color: MyTheme.grey_153),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  height: 36,
                                  width: 80,
                                  color: MyTheme.light_grey,
                                  child: Text(
                                    getLocal(context).browse_ucf,
                                    style: TextStyle(
                                        fontSize: 12, color: MyTheme.grey_153),
                                  )),
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  LangText(context: context).getLocal().banner_1500_x_450_des,
                  style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 10,
                  children: List.generate(
                    _imageUrls.length,
                    (index) => Stack(
                      children: [
                        MyWidget.imageWithPlaceholder(
                            height: 60.0, width: 60.0, url: _imageUrls[index]),
                        Positioned(
                          top: 0,
                          right: 5,
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: MyTheme.white),
                            child: InkWell(
                              onTap: () {
                                _imageUrls.removeAt(index);
                                _imageIds.removeAt(index);
                                setState(() {});
                              },
                              child: Icon(
                                Icons.close,
                                size: 12,
                                color: MyTheme.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                SizedBox(
                  height: 20,
                ),
                SubmitBtn.show(
                    alignment: Alignment.center,
                    onTap: () {
                      formValidation();
                      if (_errors.isEmpty) {
                        updateInfo();
                      }
                    },
                    height: 48,
                    backgroundColor: MyTheme.app_accent_color,
                    radius: 6.0,
                    width: DeviceInfo(context).getWidth(),
                    child: Text(
                      LangText(context: context).getLocal().save_ucf,
                      style: TextStyle(fontSize: 17, color: MyTheme.white),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loadingShow(BuildContext myContext) {
    return showDialog(
        //barrierDismissible: false,
        context: myContext,
        builder: (BuildContext context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text(LangText(context: context).getLocal().please_wait_ucf),
            ],
          ));
        });
  }
}
