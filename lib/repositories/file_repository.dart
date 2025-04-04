import 'package:ecom_seller_app/api_request.dart';
import 'package:ecom_seller_app/app_config.dart';
import 'package:ecom_seller_app/data_model/simple_image_upload_response.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class FileRepository {
  Future<SimpleImageUploadResponse> getSimpleImageUploadResponse(
      @required String image, @required String filename) async {
    var postBody = jsonEncode({"image": image, "filename": filename});
    //print(post_body.toString());

    String url = ("${AppConfig.BASE_URL}/file/image-upload");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: postBody);

    //print(response.body.toString());
    return simpleImageUploadResponseFromJson(response.body);
  }
}
