import 'package:ecom_seller_app/data_model/login_response.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/helpers/system_config.dart';
import 'package:ecom_seller_app/repositories/auth_repository.dart';

class AuthHelper {
  setUserData(LoginResponse loginResponse) {
    if (loginResponse.result == true) {
      SystemConfig.systemUser = loginResponse.user;
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.access_token;
      access_token.save();
      seller_id.$ = loginResponse.user!.id;
      seller_id.save();
    }
  }

  clearUserData() {
    SystemConfig.systemUser = null;
    is_logged_in.$ = false;
    is_logged_in.save();
    access_token.$ = "";
    access_token.save();
    seller_id.$ = 0;
    seller_id.save();
  }

  Future<LoginResponse> fetch_and_set() async {
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();
    if (userByTokenResponse.result == true) {
      setUserData(userByTokenResponse);
    } else {
      clearUserData();
    }
    return userByTokenResponse;
  }
}
