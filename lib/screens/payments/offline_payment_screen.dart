
import 'package:ecom_seller_app/custom/buttons.dart';
import 'package:ecom_seller_app/custom/input_decorations.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/helpers/file_helper.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/file_repository.dart';
import 'package:ecom_seller_app/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

class OfflineScreen extends StatefulWidget {

  String? details;
  int? offline_payment_id;
 final int? package_id;
  final double? rechargeAmount;

  OfflineScreen(
      {super.key,
      this.details,
      this.offline_payment_id,
      this.rechargeAmount, this.package_id});

  @override
  _OfflineState createState() => _OfflineState();
}

class _OfflineState extends State<OfflineScreen> {
  final ScrollController _mainScrollController = ScrollController();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _trxIdController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _photo_file;
  String? _photo_path = "";
  int? _photo_upload_id = 0;
  late BuildContext loadingcontext;

  Future<void> _onPageRefresh() async {
    reset();
  }

  reset() {
    _amountController.clear();
    _nameController.clear();
    _trxIdController.clear();
    _photo_path = "";
    _photo_upload_id = 0;
    setState(() {});
  }

  onPressSubmit() async {
    var amount = _amountController.text.toString();
    var name = _nameController.text.toString();
    var trxId = _trxIdController.text.toString();

    if (amount == "" || name == "" || trxId == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.amount_name_and_transaction_id_are_necessary,

          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    if (_photo_path == "" || _photo_upload_id == 0) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.photo_proof_is_necessary,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    loading();
      var submitResponse = await PaymentRepository()
          .getOfflinePaymentResponse(
              amount: amount,
              name: name,
              trx_id: trxId,
              photo: _photo_upload_id,
      package_id: widget.package_id);
      Navigator.pop(loadingcontext);
      if (submitResponse.result == false) {
        ToastComponent.showDialog(submitResponse.message!,
            gravity: Toast.center, duration: Toast.lengthLong);
      } else {
        ToastComponent.showDialog(submitResponse.message!,
            gravity: Toast.center, duration: Toast.lengthLong);
        Navigator.pop(context);
      }

  }

  onPickPhoto(context) async {


      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      _photo_file = await _picker.pickImage(source: ImageSource.gallery);

      if (_photo_file == null) {
        ToastComponent.showDialog(
            AppLocalizations.of(context)!.no_file_is_chosen,
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      //return;
      String base64Image = FileHelper.getBase64FormateFile(_photo_file!.path);
      String fileName = _photo_file!.path.split("/").last;

      var imageUpdateResponse =
          await FileRepository().getSimpleImageUploadResponse(
        base64Image,
        fileName,
      );

      if (imageUpdateResponse.result == false) {
        print(imageUpdateResponse.message);
        ToastComponent.showDialog(imageUpdateResponse.message!,
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      } else {
        ToastComponent.showDialog(imageUpdateResponse.message!,
            gravity: Toast.center, duration: Toast.lengthLong);

        _photo_path = imageUpdateResponse.path;
        _photo_upload_id = imageUpdateResponse.upload_id;
        setState(() {});
      }

  }

  @override
  void initState() {
    _amountController.text = widget.rechargeAmount.toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(context: context,title: AppLocalizations.of(context)!.offline_payment_ucf,).show(),
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
        AppLocalizations.of(context)!.offline_payment_ucf,
        style: TextStyle(fontSize: 16, color: MyTheme.app_accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildBody(context) {

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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Html(data: widget.details),
                ),
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
                AppLocalizations.of(context)!.all_marked_fields_are_mandatory,
                style: TextStyle(
                    color: MyTheme.grey_153,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!
                    .correctly_fill_up_the_necessary_information,
                style: TextStyle(color: MyTheme.grey_153, fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "${AppLocalizations.of(context)!.amount_ucf}*",
                style: TextStyle(
                    color: MyTheme.app_accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: _amountController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "12,000 or Tweleve Thousand Only"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "${AppLocalizations.of(context)!.name_ucf}*",
                style: TextStyle(
                    color: MyTheme.app_accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: _nameController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "John Doe"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "${AppLocalizations.of(context)!.transaction_id_ucf}*",
                style: TextStyle(
                    color: MyTheme.app_accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: _trxIdController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "BNI-4654321354"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "${AppLocalizations.of(context)!.photo_permission_ucf}* (${AppLocalizations.of(context)!.only_image_file_allowed})",
                style: TextStyle(
                    color: MyTheme.app_accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: 180,
                    height: 36,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Buttons(
                      width: MediaQuery.of(context).size.width,
                      //height: 50,
                      color: MyTheme.medium_grey,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: Text(
                        AppLocalizations.of(context)!.photo_proof_ucf,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPickPhoto(context);
                      },
                    ),
                  ),
                ),
                _photo_path != ""
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text(AppLocalizations.of(context)!.selected_ucf),
                      )
                    : Container()
              ],
            ),
            Row(
              children: [
                Spacer(),
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
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: Text(
                        AppLocalizations.of(context)!.submit_ucf,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressSubmit();
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

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text(AppLocalizations.of(context)!.please_wait_ucf),
            ],
          ));
        });
  }
}
