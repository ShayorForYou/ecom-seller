import 'package:ecom_seller_app/custom/device_info.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/data_model/product_review_response.dart';
import 'package:ecom_seller_app/helpers/shimmer_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../custom/localization.dart';

class ProductReviews extends StatefulWidget {
  const ProductReviews({super.key});

  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  List<Review> _reviews = [];
  bool _isLoadData = false;

  Future<bool> getReviews() async {
    var response = await ProductRepository().getProductReviewsReq();
    _reviews.addAll(response.data!);
    _isLoadData = true;

    setState(() {});
    return true;
  }

  fetchData() async {
    await getReviews();
  }

  clearData() async {
    _reviews = [];
    _isLoadData = false;
    setState(() {});
  }

  Future<void> reFresh() async {
    clearData();
    await fetchData();
    return Future.delayed(const Duration(microseconds: 100));
  }

  @override
  void initState() {
    getReviews();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
              title: AppLocalizations.of(context)!.product_reviews_ucf,
              context: context)
          .show(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: RefreshIndicator(
          onRefresh: reFresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: _isLoadData ? buildReviewList() : buildShimmer(),
          ),
        ),
      ),
    );
  }

  Widget buildReviewList() {
    return ListView.builder(
        itemCount: _reviews.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            child: reviewItem(index),
          );
        });
  }

  Widget reviewItem(int index) {
    return MyWidget().customCard(
        elevation: 15.0,
        margin: EdgeInsets.only(bottom: 20, top: index == 0 ? 20 : 0),
        //padding:EdgeInsets.symmetric(horizontal: 15,vertical: 5) ,
        //width: DeviceInfo(context).getWidth(),
        backgroundColor: MyTheme.app_accent_color_extra_light,
        borderRadius: 10.0,
        borderColor: MyTheme.light_grey,
        shadowColor: MyTheme.app_accent_shado,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: DeviceInfo(context).getWidth() / 2,
                  child: Text(
                    _reviews[index].productName!,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.app_accent_color,
                    ),
                  )),
              SizedBox(
                width: DeviceInfo(context).getWidth(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: DeviceInfo(context).getWidth() / 2,
                        child: Text(
                          _reviews[index].name!,
                          style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.font_grey,
                          ),
                        )),
                    Container(
                        child: Text(
                      _reviews[index].status == 1
                          ? LangText(context: context).getLocal().publish_ucf
                          : LangText(context: context)
                              .getLocal()
                              .unpublish_ucf,
                      style: TextStyle(
                        fontSize: 16,
                        color: MyTheme.app_accent_color,
                      ),
                    )),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: double.parse(_reviews[index].rating.toString()),
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              _reviews[index].comment!.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: MyTheme.white,
                        ),
                        Text(_reviews[index].comment!),
                      ],
                    )
                  : Container()
            ],
          ),
        ));
  }

  Widget buildShimmer() {
    return Container(
      child:
          ShimmerHelper().buildListShimmer(item_height: 160.0, item_count: 10),
    );
  }
}
