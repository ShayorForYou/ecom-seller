import 'dart:convert';
import 'package:ecom_seller_app/api_request.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:org_chart/org_chart.dart';
import 'package:shimmer/shimmer.dart';

import '../app_config.dart';
import '../helpers/shared_value_helper.dart';
import '../my_theme.dart';

class ManageVendors extends StatefulWidget {
  const ManageVendors({super.key});

  @override
  State<ManageVendors> createState() => _ManageVendorsState();
}

class _ManageVendorsState extends State<ManageVendors> {
  List<Map<dynamic, dynamic>> vendors = [];
  late OrgChartController<Map> orgChartController;

  @override
  void initState() {
    super.initState();
    orgChartController = OrgChartController<Map>(
      orientation: OrgChartOrientation.topToBottom,
      items: vendors,
      idProvider: (data) => data["id"],
      toProvider: (data) => data["parent_id"],
      toSetter: (data, newID) => data["to"] = newID,
    );
    getVendors();
  }

  Future<List<Map<dynamic, dynamic>>> getVendors() async {
    var response = await ApiRequest.get(
        url: "${AppConfig.BASE_URL}/seller/my-organogram",
        headers: {
          "Authorization": "Bearer ${access_token.$}",
        });
    setState(() {
      vendors = List<Map<dynamic, dynamic>>.from(
          json.decode(response.body).map((item) {
        return {
          "id": item["id"].toString(),
          "name": item["name"],
          "email": item["email"],
          "shop_name": item["shop_name"],
          "address": item["address"],
          "parent_id": item["parent_id"]?.toString(),
        };
      }));
      orgChartController.items = vendors;
    });
    if (kDebugMode) {
      print('vendors: $vendors');
    }
    return vendors;
  }

  buildBoxShimmer(
      {double height = double.infinity, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: MyTheme.app_accent_color_extra_light,
      highlightColor: MyTheme.shimmer_highlighted,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        bottom: null,
        title: 'Manage Vendors',
        centerTitle: true,
      ).show(),
      body: OrgChart<Map>(
        cornerRadius: 10,
        curve: Curves.easeInOut,
        controller: orgChartController,
        isDraggable: false,
        linePaint: Paint()
          ..color = Colors.grey
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke,
        builder: (details) {
          return GestureDetector(
            child: Card(
              color: details.item["id"] == '0'
                  ? MyTheme.app_accent_color
                  : Colors.white,
              surfaceTintColor: MyTheme.golden,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      details.item["shop_name"] ?? details.item["name"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: details.item["id"] == '0'
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Address: ',
                            style: TextStyle(
                              color: details.item["id"] == '0'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: details.item["address"],
                            style: TextStyle(
                              color: details.item["id"] == '0'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
