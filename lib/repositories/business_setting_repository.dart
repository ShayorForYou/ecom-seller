import 'dart:convert';

import 'package:ecom_seller_app/api_request.dart';
import 'package:ecom_seller_app/app_config.dart';
import 'package:ecom_seller_app/data_model/business_setting_response.dart';

class BusinessSettingRepository {
  Future<List<BusinessSettingListResponse>> getBusinessSettingList() async {
    String url = ("${AppConfig.BASE_URL}/business-settings");

    var businessSettings = [
      "conversation_system",
      "coupon_system",
      "product_manage_by_admin",
      // "google_recaptcha",
      "product_query_activation",
      "shipping_type",
      "pos_activation_for_seller",
      "google_firebase"
    ];
    String params = businessSettings.join(',');
    var body = {"keys": params};
    // print("business ${body}");
    var response = await ApiRequest.post(url: url, body: jsonEncode(body));

    print("business ${response.body} ${response.statusCode} $url ");

    return businessSettingListResponseFromJson(response.body);
  }
}
