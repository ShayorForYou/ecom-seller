import 'package:ecom_seller_app/const/app_style.dart';
import 'package:ecom_seller_app/const/homepage_features.dart';
import 'package:ecom_seller_app/custom/device_info.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/custom/route_transaction.dart';
import 'package:ecom_seller_app/data_model/category_wise_product_response.dart';
import 'package:ecom_seller_app/data_model/top_12_product_response.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/helpers/shimmer_helper.dart';
import 'package:ecom_seller_app/helpers/shop_info_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/shop_repository.dart';
import 'package:ecom_seller_app/screens/orders.dart';
import 'package:ecom_seller_app/screens/packages.dart';
import 'package:ecom_seller_app/screens/payment_history.dart';
import 'package:ecom_seller_app/screens/payment_setting.dart';
import 'package:ecom_seller_app/screens/pos/pos_manager.dart';
import 'package:ecom_seller_app/screens/product/products.dart';
import 'package:ecom_seller_app/screens/refund_request.dart';
import 'package:ecom_seller_app/screens/shop_settings/shop_settings.dart';
import 'package:ecom_seller_app/screens/verify_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../custom/chart2.dart';
import 'chat_list.dart';
import 'coupon/coupons.dart';
import 'money_withdraw.dart';

class Home extends StatefulWidget {
  final bool fromBottombar;

  const Home({Key? key, this.fromBottombar = false}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //String variables
  // String homePageTitle = "Dashboard";

  //bool type
  bool _faceTopProducts = false;
  bool _faceCategoryWiseProducts = false;

  // double variables
  double mHeight = 0.0, mWidht = 0.0;

  //List
  List<ChartData> chartValues = [];
  List<CriteriaProducts> product = [];
  List<String> logoSliders = [];
  List<CategoryWiseProductResponse> categoryWiseProducts = [];

  String? _productsCount = '...',
      _rattingCount = "...",
      _totalOrdersCount = "...",
      _totalSalesCount = '...',
      _soldOutProducts = "...",
      _lowStockProducts = "...",
      _currentPackageName = "...",
      _prodcutUploadLimit = "...",
      _pacakgeExpDate = "...";

  Future<bool> _getTop12Product() async {
    var response = await ShopRepository().ordersByCriteria();
    product.addAll(response.data!);
    _faceTopProducts = true;
    setState(() {});

    return true;
  }

  Future<bool> _getCategoryWiseProduct() async {
    var response = await ShopRepository().getCategoryWiseProductRequest();
    categoryWiseProducts.addAll(response);
    _faceCategoryWiseProducts = true;
    setState(() {});
    return true;
  }

  Future<bool> _getShopInfo() async {
    var response = await ShopRepository().getShopInfo();

    _productsCount = response.shopInfo!.products.toString();
    _rattingCount = response.shopInfo!.rating.toString();
    _totalOrdersCount = response.shopInfo!.orders.toString();
    _totalSalesCount = response.shopInfo!.sales.toString();
    _pacakgeExpDate = response.shopInfo!.packageInvalidAt;
    _currentPackageName = response.shopInfo!.sellerPackage;
    _prodcutUploadLimit = response.shopInfo!.productUploadLimit.toString();
    logoSliders.addAll(response.shopInfo!.sliders!);

    ShopInfoHelper().setShopInfo();
    setState(() {});
    return true;
  }

  cleanAll() {
    _productsCount = '...';
    _rattingCount = "...";
    _totalOrdersCount = "...";
    _totalSalesCount = '...';
    _soldOutProducts = "...";
    _lowStockProducts = "...";
    _currentPackageName = "...";
    _prodcutUploadLimit = "...";
    _pacakgeExpDate = "...";
    chartValues = [];
    product = [];
    categoryWiseProducts = [];
    _faceTopProducts = false;
    _faceCategoryWiseProducts = false;
    setState(() {});
  }

  Future<void> reFresh() {
    cleanAll();
    facingAll();
    return Future.delayed(const Duration(seconds: 1));
  }

  facingAll() async {
    _getTop12Product();
    _getCategoryWiseProduct();
    _getShopInfo();
  }

  @override
  void initState() {
    // TODO: implement initState
    facingAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(AppBar().preferredSize.height);
    }
    mHeight = MediaQuery.of(context).size.height;
    mWidht = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: reFresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: dashboard(),
          ),
        ],

      ),
    );
  }

  Widget dashboard() {
    return SizedBox(
      height: DeviceInfo(context).getHeight() ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          top4Boxes(),
          // packageContainer(),
          // SizedBox(
          //   height: AppStyles.listItemsMargin,
          // ),
          SizedBox(
            height: AppStyles.listItemsMargin,
          ),
          chartContainer(),
          SizedBox(
            height: AppStyles.listItemsMargin,
          ),
          featureContainer(),

          SizedBox(
            height: AppStyles.listItemsMargin,
          ),

          if (!verify_form_submitted.$ && !shop_verify.$)
            Column(
              children: [
                verifyContainer(),
                SizedBox(
                  height: AppStyles.listItemsMargin,
                ),
              ],
            ),
          settingContainer(),
          SizedBox(
            height: AppStyles.listItemsMargin,
          ),

          // categoryWiseProduct(),
          // Container(
          //   height: AppStyles.listItemsMargin,
          // ),
          // topProductsContainer(),
          // SizedBox(
          //   height: AppStyles.listItemsMargin,
          // ),
        ],
      ),
    );
  }

  Widget buildTopProductsShimmer() {
    return SizedBox(
      height: DeviceInfo(context).getHeight(),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  bottom: 15, top: index == product.length - 1 ? 15 : 0),
              child: MyWidget.customCardView(
                elevation: 5,
                height: 112,
                width: DeviceInfo(context).getWidth(),
                borderRadius: 10.0,
                borderColor: MyTheme.light_grey,
                child: ShimmerHelper().buildBasicShimmer(
                    height: 112.0, width: DeviceInfo(context).getWidth()),
              ),
            );
          }),
    );
  }

  Container topProductsContainer() {
    return Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 17,
              child: Text(
                LangText(context: context).getLocal().top_products_ucf,
                style: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: AppStyles.itemMargin,
            ),
            _faceTopProducts
                ? product.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: 205,
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          LangText(context: context)
                              .getLocal()
                              .no_data_is_available,
                          style: const TextStyle(
                              fontSize: 14,
                              color: MyTheme.app_accent_color,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: product.length,
                        itemBuilder: (context, index) {
                          return buildTopProductItem(index);
                        },
                      )
                : buildTopProductsShimmer(),
          ],
        ));
  }

  Widget buildTopProductItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: MyWidget.customCardView(
        backgroundColor: MyTheme.white,
        elevation: 5,
        height: 112,
        width: DeviceInfo(context).getWidth(),
        borderRadius: 10.0,
        borderColor: MyTheme.light_grey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyWidget.imageWithPlaceholder(
                url: product[index].thumbnailImg,
                width: 112.0,
                height: 112.0,
                radius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(),
                SizedBox(
                  width: DeviceInfo(context).getWidth() * 0.5,
                  child: Text(
                    product[index].name!,
                    maxLines: 2,
                    style:
                        const TextStyle(fontSize: 12, color: MyTheme.font_grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  product[index].category!,
                  style: const TextStyle(
                      fontSize: 10,
                      color: MyTheme.grey_153,
                      fontWeight: FontWeight.normal),
                ),
                const Spacer(),
                Text(
                  product[index].price!,
                  style: const TextStyle(
                      fontSize: 12,
                      color: MyTheme.app_accent_color,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoriesShimmer() {
    return SizedBox(
      height: 112,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ShimmerHelper()
                .buildBasicShimmer(height: 112.0, width: 89.0);
          }),
    );
  }

  Widget categoryWiseProductShimmer() {
    return Column(
      children: [
        ShimmerHelper().buildBasicShimmer(height: 20),
        const SizedBox(
          height: 5,
        ),
        ShimmerHelper().buildBasicShimmer(height: 20),
        const SizedBox(
          height: 5,
        ),
        ShimmerHelper().buildBasicShimmer(height: 20),
        const SizedBox(
          height: 5,
        ),
        ShimmerHelper().buildBasicShimmer(height: 20),
      ],
    );
  }

  Container categoryWiseProduct() {
    return MyWidget.customContainer(
        alignment: Alignment.topLeft,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 17,
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "${LangText(context: context).getLocal().your_categories_ucf} (${categoryWiseProducts.length})",
                style: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.app_accent_color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            _faceCategoryWiseProducts
                ? product.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: 112,
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          LangText(context: context)
                              .getLocal()
                              .no_data_is_available,
                          style: const TextStyle(
                              fontSize: 14,
                              color: MyTheme.app_accent_color,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : SizedBox(
                        height: 112,
                        child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppStyles.itemMargin),
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: AppStyles.itemMargin,
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryWiseProducts.length,
                            itemBuilder: (context, index) {
                              return buildCategoryItem(index);
                            }),
                      )
                : buildCategoriesShimmer(),
          ],
        ));
  }

  Widget buildCategoryItem(int index) {
    return MyWidget.customCardView(
        backgroundColor: MyTheme.noColor,
        elevation: 5,
        blurSize: 20,
        height: 112,
        width: 89,
        // borderRadius: 12.0,
        shadowColor: MyTheme.app_accent_shado,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: MyWidget.imageWithPlaceholder(
                url: categoryWiseProducts[index].banner,
                width: 89.0,
                height: 112.0,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(12),
              ),
            ),
            Container(
              height: 112,
              width: 89,
              decoration: BoxDecoration(
                  color: MyTheme.app_accent_tranparent,
                  borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      categoryWiseProducts[index].name!,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 10,
                          color: MyTheme.white,
                          fontWeight: FontWeight.normal),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Text(
                    "(${categoryWiseProducts[index].cntProduct})",
                    style: TextStyle(
                        fontSize: 10,
                        color: MyTheme.white,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget chartShimmer() {
    return SizedBox(
      height: 130,
      width: DeviceInfo(context).getWidth() / 1.5,
      child:
          ShimmerHelper().buildListShimmer(item_height: 20.0, item_count: 10),
    );
  }

  Widget chartContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: MyWidget.customCardView(
        padding: const EdgeInsets.only(bottom: 10),
        elevation: 5,
        height: 300,
        shadowColor: MyTheme.app_accent_color_extra_light,
        backgroundColor: MyTheme.white,
        width: DeviceInfo(context).getWidth(),
        borderRadius: 10,
        child: Stack(
          children: [
            // Positioned(
            //   right: 5,
            //   child: Text(
            //     "20-26 Feb, 2022",
            //     style: TextStyle(
            //         fontSize: 10, color: MyTheme.app_accent_color),
            //   ),
            // ),
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: MyTheme.app_accent_color.withOpacity(0.7),
                ),
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sales stats',
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.white,
                            fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                ),
              ),

              // Text(
              //   LangText(context: context).getLocal().sales_stat_ucf,
              //   style: const TextStyle(
              //       fontSize: 14,
              //       color: MyTheme.app_accent_color,
              //       fontWeight: FontWeight.bold),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SizedBox(
                  height: 230,
                  width: DeviceInfo(context).getWidth(),
                  child: const MChart()),
            ),
          ],
        ),

        /*Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LangText(context: context)
                        .getLocal()
                        .dashboard_sales_stat,
                    style: TextStyle(
                        fontSize: 14, color: MyTheme.app_accent_color),
                  ),
                  Text(
                    "20-26 Feb, 2022",
                    style: TextStyle(
                        fontSize: 10,
                        color: MyTheme.app_accent_color),
                  ),
                ],
              ),
              Center(
                  child: Container(
                //padding: EdgeInsets.all(8),
                child: Container(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        width: 20,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("4K"),
                            Text("3K"),
                            Text("2K"),
                            Text("1K"),
                            Text("0"),
                          ],
                        ),
                      ),
                      _isTopProductsData?Container(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              child: Stack(
                                children: [

                                  Container(
                                    width:
                                        DeviceInfo(context).getWidth() / 1.5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                        Container(
                                          color:
                                              MyTheme.app_accent_color,
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width:
                                        DeviceInfo(context).getWidth() / 1.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[0].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[1].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[2].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[3].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[4].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[5].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 130,
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 130*chartValues[6].salesValue/4000,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: MyTheme.app_accent_color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2),
                                                topRight: Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
                            Container(
                             width: DeviceInfo(context).getWidth() / 1.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),
                                  Text(chartValues[0].date),

                                ],
                              ),
                            )
                          ],
                        ),
                      ):chartShimmer(),
                    ],
                  ),
                ),
              ))
            ],
          )*/
      ),
    );
  }

  Widget packageContainer() {
    return seller_package_addon.$
        ? Column(
            children: [
              SizedBox(
                height: AppStyles.listItemsMargin,
              ),
              MyWidget.customCardView(
                  width: DeviceInfo(context).getWidth(),
                  height: 128,
                  borderRadius: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  backgroundColor: MyTheme.white,
                  elevation: 5,
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      Image.asset(
                        'assets/icon/package.png',
                        width: 64,
                        height: 64,
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                LangText(context: context)
                                    .getLocal()
                                    .current_package_ucf,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: MyTheme.app_accent_color,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                _currentPackageName!,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: MyTheme.app_accent_color,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                LangText(context: context)
                                    .getLocal()
                                    .product_upload_limit_ucf,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${_prodcutUploadLimit!} ${LangText(context: context).getLocal().times_all_lower}",
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                LangText(context: context)
                                    .getLocal()
                                    .package_expires_at_ucf,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                _pacakgeExpDate!,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: MyTheme.grey_153,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              MyTransaction(context: context)
                                  .push(const Packages());
                            },
                            child: MyWidget().myContainer(
                                bgColor: MyTheme.app_accent_color,
                                borderRadius: 6,
                                height: 36,
                                width: DeviceInfo(context).getWidth() / 2.2,
                                child: Text(
                                  LangText(context: context)
                                      .getLocal()
                                      .upgrade_package_ucf,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: MyTheme.white,
                                      fontWeight: FontWeight.w400),
                                )),
                          )
                        ],
                      ),
                      const Spacer(),
                    ],
                  )),
            ],
          )
        : Container();
  }

  Widget settingContainer() {
    return Container(
      width: DeviceInfo(context).getWidth(),
      padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     MyWidget.customCardView(
      //         borderWidth: 1,
      //         elevation: 5,
      //         borderRadius: 10,
      //         //padding:EdgeInsets.symmetric(vertical: 5),
      //         width: DeviceInfo(context).getWidth() / 2 - 23,
      //         height: DeviceInfo(context).getWidth() / 2 - 20,
      //         borderColor: MyTheme.app_accent_border,
      //         backgroundColor: MyTheme.app_accent_color_extra_light,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Column(
      //               children: [
      //                 Text(
      //                   LangText(context: context)
      //                       .getLocal().shop_settings_ucf,
      //                   style: const TextStyle(
      //                       fontSize: 14,
      //                       fontWeight: FontWeight.bold,
      //                       color: MyTheme.app_accent_color),
      //                   textAlign: TextAlign.center,
      //                 ),
      //                 const SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   LangText(context: context)
      //                       .getLocal().manage_n_organize_your_shop,
      //                   style: const TextStyle(
      //                       fontSize: 10,
      //                       fontWeight: FontWeight.normal,
      //                       color: MyTheme.app_accent_color),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ],
      //             ),
      //             Image.asset(
      //               "assets/icon/shop_setting.png",
      //               color: MyTheme.app_accent_color,
      //               height: 32,
      //               width: 32,
      //             ),
      //             InkWell(
      //               onTap: () {
      //                 MyTransaction(context: context).push(const ShopSettings());
      //               },
      //               child: MyWidget().myContainer(
      //                 bgColor: MyTheme.app_accent_color,
      //                 child: Text(
      //                   LangText(context: context).getLocal().go_to_settings,
      //                   textAlign: TextAlign.center,
      //                   style: const TextStyle(fontSize: 12, color: Colors.white),
      //                 ),
      //                 width: DeviceInfo(context).getWidth() / 3,
      //                 height: 30,
      //                 borderRadius: 6,
      //               ),
      //             )
      //           ],
      //         )),
      //     const SizedBox(
      //       width: 14,
      //     ),
      //     MyWidget.customCardView(
      //         elevation: 5,
      //         borderRadius: 10,
      //         borderWidth: 1,
      //         //padding:EdgeInsets.symmetric(vertical: 5),
      //         width: DeviceInfo(context).getWidth() / 2 - 23,
      //         height: DeviceInfo(context).getWidth() / 2 - 20,
      //         borderColor: MyTheme.app_accent_border,
      //         backgroundColor: MyTheme.app_accent_color_extra_light,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Column(
      //               children: [
      //                 Text(
      //                   LangText(context: context)
      //                       .getLocal().payment_settings_ucf,
      //                   style: const TextStyle(
      //                       fontSize: 14,
      //                       fontWeight: FontWeight.bold,
      //                       color: MyTheme.app_accent_color),
      //                   textAlign: TextAlign.center,
      //                 ),
      //                 const SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   LangText(context: context)
      //                       .getLocal().configure_your_payment_method,
      //                   style: const TextStyle(
      //                       fontSize: 10,
      //                       fontWeight: FontWeight.normal,
      //                       color: MyTheme.app_accent_color),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ],
      //             ),
      //             Image.asset(
      //               "assets/icon/payment_setting.png",
      //               color: MyTheme.app_accent_color,
      //               height: 32,
      //               width: 32,
      //             ),
      //             InkWell(
      //               onTap: () {
      //                 MyTransaction(context: context).push(const PaymentSetting());
      //               },
      //               child: MyWidget().myContainer(
      //                 bgColor: MyTheme.app_accent_color,
      //                 child: Text(
      //                   LangText(context: context)
      //                       .getLocal().configure_now_ucf,
      //                   textAlign: TextAlign.center,
      //                   style: const TextStyle(fontSize: 12, color: Colors.white),
      //                 ),
      //                 width: DeviceInfo(context).getWidth() / 3,
      //                 height: 30,
      //                 borderRadius: 6,
      //               ),
      //             )
      //           ],
      //         )),
      //   ],
      // ),
    );
  }

  Widget verifyContainer() {
    return Container(
      width: DeviceInfo(context).getWidth(),
      padding: EdgeInsets.symmetric(horizontal: AppStyles.layoutMargin),
      child: MyWidget.customCardView(
        elevation: 5,
        borderRadius: 10,
        borderWidth: 1,
        //padding:EdgeInsets.symmetric(vertical: 5),
        width: DeviceInfo(context).getWidth(),
        height: DeviceInfo(context).getWidth() / 2 - 20,
        borderColor: MyTheme.app_accent_border,
        backgroundColor: MyTheme.app_accent_color_extra_light,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  LangText(context: context)
                      .getLocal()
                      .your_account_is_unverified,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.app_accent_color),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  LangText(context: context).getLocal().verify_your_account,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: MyTheme.app_accent_color),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Image.asset(
              "assets/icon/unverify.png",
              height: 32,
              width: 32,
            ),
            InkWell(
              onTap: () {
                MyTransaction(context: context)
                    .push(const VerifyPage())
                    .then((value) {
                  if (!verify_form_submitted.$) {
                    setState(() {});
                  }
                });
              },
              child: MyWidget().myContainer(
                bgColor: MyTheme.app_accent_color,
                child: Text(
                  LangText(context: context).getLocal().verify_now,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                width: DeviceInfo(context).getWidth() / 3,
                height: 30,
                borderRadius: 6,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget featureContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                MyTransaction(context: context).push(const PosManager());
              },
              child: MyWidget.homePageTopBox(context,
                  elevation: 5,
                  title: 'Pos Manager',
                  iconUrl: 'assets/icon/pos_system.png'),
            ),
            InkWell(
              onTap: () {
                MyTransaction(context: context).push(ChatList());
              },
              child: MyWidget.homePageTopBox(context,
                  title: 'Chat', iconUrl: 'assets/icon/chat.png'),
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RefundRequest()));
              },
              child: MyWidget.homePageTopBox(context,
                  elevation: 5,
                  title: 'Refund Request',
                  iconUrl: 'assets/icon/refund.png'),
            ),
            InkWell(
              onTap: () {
                MyTransaction(context: context).push(Coupons());
              },
              child: MyWidget.homePageTopBox(context,
                  elevation: 5,
                  title: 'Coupons',
                  iconUrl: 'assets/icon/coupon.png'),
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                MyTransaction(context: context).push(MoneyWithdraw());
              },
              child: MyWidget.homePageTopBox(context,
                  elevation: 5,
                  title: 'Withdraw Money',
                  iconUrl: 'assets/icon/withdraw.png'),
            ),
            InkWell(
              onTap: () {
                MyTransaction(context: context).push(PaymentHistory());
              },
              child: MyWidget.homePageTopBox(context,
                  elevation: 5,
                  title: 'Payment History',
                  iconUrl: 'assets/icon/payment_history.png'),
            ),
          ],
        )
      ],
    );
    // return Container(
    //     width: DeviceInfo(context).getWidth(),
    //     alignment: Alignment.center,
    //     color: MyTheme.app_accent_color,
    //     //padding: EdgeInsets.symmetric(horizontal: 15.0,),
    //     height: 90,
    //     child: SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: List.generate(
    //             FeaturesList(context).getFeatureList().length, (index) {
    //           return Container(
    //               child: Padding(
    //             padding: EdgeInsets.only(
    //                 right: 22.0,
    //                 left: index == 0 &&
    //                         FeaturesList(context).getFeatureList().length > 3
    //                     ? 22
    //                     : 0),
    //             child: FeaturesList(context).getFeatureList()[index],
    //           ));
    //         }),
    //       ),
    //     ));
  }

  Widget top4Boxes() {
    return Stack(
      children: [
        // Column(
        //   children: [
        //     Container(
        //       height: 170,
        //       width: DeviceInfo(context).getWidth(),
        //       child: MyWidget.imageSlider(
        //           imageUrl: logoSliders, context: context),
        //     ),
        //     Container(
        //       height: 70,
        //       width: DeviceInfo(context).getWidth(),
        //     ),
        //   ],
        // ),

        // Positioned(
        //   top: 0,
        //   child: SizedBox(
        //     height: 170,
        //     width: DeviceInfo(context).getWidth(),
        //     child:
        //         MyWidget.imageSlider(imageUrl: logoSliders, context: context),
        //   ),
        // ),

        // this container only for transparent color
        // Container(
        //   height: 240,
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [
        //         Color.fromRGBO(255, 255, 255, 0),
        //         Color.fromRGBO(255, 255, 255, .15),
        //         Color.fromRGBO(255, 255, 255, .25),
        //         Color.fromRGBO(255, 255, 255, .50),
        //         Color.fromRGBO(255, 255, 255, .9),
        //         Color.fromRGBO(255, 255, 255, 1),
        //         Color.fromRGBO(255, 255, 255, 1),
        //         Color.fromRGBO(255, 255, 255, 1),
        //       ],
        //     ),
        //   ),
        // ),

        Container(
            color: Colors.transparent,
            // margin: EdgeInsets.only(top: 60),
            //color: MyTheme.red,
            //height: 190,
            width: DeviceInfo(context).getWidth(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        MyTransaction(context: context).push(const Products(
                          fromBottomBar: false,
                        ));
                      },
                      child: MyWidget.homePageTopBox(context,
                          elevation: 5,
                          title: LangText(context: context)
                              .getLocal()
                              .products_ucf,
                          counter: _productsCount,
                          iconUrl: 'assets/icon/products.png'),
                    ),
                    MyWidget.homePageTopBox(context,
                        title:
                            LangText(context: context).getLocal().rating_ucf,
                        counter: _rattingCount,
                        iconUrl: 'assets/icon/rating.png'),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        MyTransaction(context: context).push(const Orders());
                      },
                      child: MyWidget.homePageTopBox(context,
                          elevation: 5,
                          title: LangText(context: context)
                              .getLocal()
                              .total_orders_ucf,
                          counter: _totalOrdersCount,
                          iconUrl: 'assets/icon/orders.png'),
                    ),
                    MyWidget.homePageTopBox(context,
                        elevation: 5,
                        title: LangText(context: context)
                            .getLocal()
                            .total_sales_ucf,
                        counter: _totalSalesCount,
                        iconUrl: 'assets/icon/sales.png'),
                  ],
                )
              ],
            )

/*
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            primary: false,
            padding:  EdgeInsets.all(AppStyles.layoutMargin),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            crossAxisCount: 2,
            childAspectRatio:DeviceInfo(context).getHeightInPercent(),
            children: <Widget>[
              MyWidget.homePageTopBox(context,
                  elevation: 5,
                  title: LangText(context: context)
                      .getLocal()
                      .product_screen_products,
                  counter: _productsCount,
                  iconUrl: 'assets/icon/products.png'),
              MyWidget.homePageTopBox(context,
                  title:
                  LangText(context: context).getLocal().common_rating,
                  counter: _rattingCount,
                  iconUrl: 'assets/icon/rating.png'),

              MyWidget.homePageTopBox(context,
                  elevation: 5,
                  title: LangText(context: context)
                      .getLocal()
                      .common_total_orders,
                  counter: _totalOrdersCount,
                  iconUrl: 'assets/icon/orders.png'),
              MyWidget.homePageTopBox(context,
                  elevation: 5,
                  title: LangText(context: context)
                      .getLocal()
                      .common_total_sales,
                  counter: _totalSalesCount,
                  iconUrl: 'assets/icon/sales.png')
            ],
          ),*/

            ),
      ],
    );
  }
}

class ChartData {
  int salesValue;
  String date;

  ChartData(this.date, this.salesValue);
}
