import 'package:ecom_seller_app/api_request.dart';
import 'package:ecom_seller_app/data_model/google_location_details_response.dart';
import 'package:ecom_seller_app/data_model/location_autocomplete_response.dart';

class GoogleMapLocationRepository {
  var GoogleMapAPIKey = "";

  Future<GoogleLocationAutoCompleteResponse> getAutoCompleteAddress(
      String text) async {
    String url =
        ("https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$text&key=$GoogleMapAPIKey");
    var response = await ApiRequest.get(
      url: url,
    );
    return googleLocationAutoCompleteResponseFromJson(response.body);
  }

  Future<GoogleLocationDetailsResponse> getAddressDetails(
      String placeId) async {
    String url =
        ("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GoogleMapAPIKey");
    var response = await ApiRequest.get(
      url: url,
    );
    return googleLocationDetailsResponseFromJson(response.body);
  }
}
