import 'package:ecom_seller_app/api_request.dart';
import 'package:ecom_seller_app/app_config.dart';
import 'package:ecom_seller_app/data_model/addon_response.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';

class AddonRepository {
  Future<List<AddonResponse>> getAddonList() async {
    String url = ("${AppConfig.BASE_URL}/addon-list");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };
    // print("getAddonList url  " + url.toString());
    final response = await ApiRequest.get(url: url, headers: reqHeader);
    // print("getAddonList res  " + response.body.toString());
    return addonResponseFromJson(response.body);
  }
}
