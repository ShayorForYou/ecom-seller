import 'package:ecom_seller_app/const/app_style.dart';
import 'package:ecom_seller_app/custom/buttons.dart';
import 'package:ecom_seller_app/custom/common_style.dart';
import 'package:ecom_seller_app/custom/device_info.dart';
import 'package:ecom_seller_app/custom/localization.dart';
import 'package:ecom_seller_app/custom/my_app_bar.dart';
import 'package:ecom_seller_app/custom/my_widget.dart';
import 'package:ecom_seller_app/custom/route_transaction.dart';
import 'package:ecom_seller_app/custom/submitButton.dart';
import 'package:ecom_seller_app/custom/toast_component.dart';
import 'package:ecom_seller_app/data_model/products_response.dart';
import 'package:ecom_seller_app/helpers/main_helper.dart';
import 'package:ecom_seller_app/helpers/shared_value_helper.dart';
import 'package:ecom_seller_app/helpers/shimmer_helper.dart';
import 'package:ecom_seller_app/my_theme.dart';
import 'package:ecom_seller_app/repositories/product_repository.dart';
import 'package:ecom_seller_app/repositories/shop_repository.dart';
import 'package:ecom_seller_app/screens/packages.dart';
import 'package:ecom_seller_app/screens/product/new_product.dart';
import 'package:ecom_seller_app/screens/product/update_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';

import '../../providers/product_provider.dart';

class Products extends StatefulWidget {
  final bool fromBottomBar;

  const Products({super.key, this.fromBottomBar = false});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _isProductInit = false;
  bool _showMoreProductLoadingContainer = false;

  List<Product> _productList = [];

  // List<bool> _productStatus=[];
  // List<bool> _productFeatured=[];

  String _remainingProduct = "...";
  String? _currentPackageName = "...";
  late BuildContext loadingContext;
  late BuildContext switchContext;
  late BuildContext featuredSwitchContext;

  //MenuOptions _menuOptionSelected = MenuOptions.Published;

  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  // double variables
  double mHeight = 0.0, mWidth = 0.0;
  int _page = 1;

  getProductList() async {
    var productResponse = await ProductRepository().getProducts(page: _page);
    if (productResponse.data!.isEmpty) {
      if(context.mounted) {
        ToastComponent.showDialog(
          LangText(context: context).getLocal().no_more_products_ucf,
          gravity: Toast.center,
          bgColor: MyTheme.white,
          textStyle: const TextStyle(color: Colors.black));
      }
    }
    _productList.addAll(productResponse.data!);
    _showMoreProductLoadingContainer = false;
    _isProductInit = true;
    setState(() {});
  }

  Future<bool> _getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
    _currentPackageName = response.shopInfo!.sellerPackage;
    setState(() {});
    return true;
  }

  getProductRemainingUpload() async {
    var productResponse = await ProductRepository().remainingUploadProducts();
    _remainingProduct = productResponse.ramainingProduct.toString();

    setState(() {});
  }

  duplicateProduct(int? id) async {
    loading();
    var response = await ProductRepository().productDuplicateReq(id: id);
    if(context.mounted) Navigator.pop(loadingContext);
    if (response.result) {
      // resetAll();
      if(context.mounted) Provider.of<ProductProvider>(context, listen: false).fetchAll();
    }
    ToastComponent.showDialog(
      response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: const TextStyle(color: MyTheme.black),
    );
  }

  deleteProduct(int? id) async {
    loading();
    var response = await ProductRepository().productDeleteReq(id: id);
    if(context.mounted) Navigator.pop(loadingContext);
    if (response.result) {
      // resetAll();
      if(context.mounted) Provider.of<ProductProvider>(context, listen: false).fetchAll();
    }
    ToastComponent.showDialog(
      response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: const TextStyle(color: MyTheme.black),
    );
  }

  productStatusChange(int? index, bool value, setState, id) async {
    loading();
    var response = await ProductRepository()
        .productStatusChangeReq(id: id, status: value ? 1 : 0);
    if(context.mounted) Navigator.pop(loadingContext);
    if (response.result) {
      // _productStatus[index] = value;
      _productList[index!].status = value;
      resetAll();
    }
    if(context.mounted) Navigator.pop(switchContext);
    ToastComponent.showDialog(
      response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: const TextStyle(color: MyTheme.black),
    );
  }

  productFeaturedChange({int? index, required bool value, setState, id}) async {
    print(value);
    loading();
    var response = await ProductRepository()
        .productFeaturedChangeReq(id: id, featured: value ? 1 : 0);
    if(context.mounted) Navigator.pop(loadingContext);

    if (response.result) {
      // _productFeatured[index]=value;
      _productList[index!].featured = value;
      resetAll();
    }
    if(context.mounted) Navigator.pop(featuredSwitchContext);

    ToastComponent.showDialog(
      response.message,
      gravity: Toast.center,
      duration: 3,
      textStyle: const TextStyle(color: MyTheme.black),
    );
  }

  scrollControllerPosition() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _showMoreProductLoadingContainer = true;
        setState(() {
          _page++;
        });
        getProductList();
      }
    });
  }

  cleanAll() {
    _isProductInit = false;
    _showMoreProductLoadingContainer = false;
    _productList = [];
    _page = 1;
    // _productStatus=[];
    // _productFeatured=[];
    _remainingProduct = "....";
    _currentPackageName = "...";
    setState(() {});
  }

  fetchAll() {
    getProductList();
    _getAccountInfo();
    getProductRemainingUpload();
    setState(() {});
  }

  resetAll() {
    cleanAll();
    fetchAll();
  }

  _tabOption(int index, productId, listIndex) {
    switch (index) {
      case 0:
        slideRightWidget(
                newPage: UpdateProduct(
                  productId: productId,
                ),
                context: context)
            .then((value) {
          resetAll();
        });
        break;
      case 1:
        showPublishUnPublishDialog(listIndex, productId);
        break;
      case 2:
        showFeaturedUnFeaturedDialog(listIndex, productId);
        break;
      case 3:
        showDeleteWarningDialog(productId);
        //deleteProduct(productId);
        break;
      case 4:
        print(productId);
        duplicateProduct(productId);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Load more products
        Provider.of<ProductProvider>(context, listen: false).loadMoreProducts();
      }
    });

    // Initial data fetch
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchAll();
    });
  }


  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    final productProvider = Provider.of<ProductProvider>(context);

    return Directionality(
      textDirection: app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: !widget.fromBottomBar
            ? MyAppBar(
          context: context,
          title: LangText(context: context).getLocal().products_ucf,
        ).show()
            : null,
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            Provider.of<ProductProvider>(context, listen: false).fetchAll();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildTop2BoxContainer(context),
                Visibility(
                  visible: seller_package_addon.$,
                  child: buildPackageUpgradeContainer(context),
                ),
                const SizedBox(height: 20),
                Container(
                  child: productProvider.isProductInit
                      ? productsContainer(productProvider.productList)
                      : ShimmerHelper().buildListShimmer(item_count: 20, item_height: 80.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPackageUpgradeContainer(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppStyles.itemMargin,
        ),
        MyWidget().myContainer(
            marginY: 15,
            height: 40,
            width: DeviceInfo(context).getWidth(),
            borderRadius: 6,
            borderColor: MyTheme.app_accent_color,
            bgColor: MyTheme.app_accent_color_extra_light,
            child: InkWell(
              onTap: () {
                MyTransaction(context: context).push(const Packages());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/icon/package.png",
                          height: 20, width: 20),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        LangText(context: context)
                            .getLocal().current_package_ucf,
                        style: const TextStyle(fontSize: 10, color: MyTheme.grey_153),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        _currentPackageName!,
                        style: const TextStyle(
                            fontSize: 10,
                            color: MyTheme.app_accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        LangText(context: context)
                            .getLocal().upgrade_package_ucf,
                        style: const TextStyle(
                            fontSize: 12,
                            color: MyTheme.app_accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset("assets/icon/next_arrow.png",
                          color: MyTheme.app_accent_color,
                          height: 8.7,
                          width: 7),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Container buildTop2BoxContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //border: Border.all(color: MyTheme.app_accent_border),
                color: MyTheme.app_accent_color,
              ),
              height: 75,
              width: mWidth / 2 - 23,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      LangText(context: context).getLocal().remaining_uploads,
                      style: MyTextStyle().productBoxText(context),
                    ),
                    Text(
                      _remainingProduct,
                      style: MyTextStyle().productBoxNumber(context),
                    ),
                  ],
                ),
              )),
          SizedBox(
            width: AppStyles.itemMargin,
          ),
          Container(
              child: SubmitBtn.show(
            onTap: () {
              MyTransaction(context: context).push(const NewProduct()).then((value) {
                resetAll();
              });
            },
            borderColor: MyTheme.app_accent_color,
            backgroundColor: MyTheme.app_accent_color_extra_light,
            height: 75,
            width: mWidth / 2 - 23,
            radius: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    LangText(context: context).getLocal().add_new_product_ucf,
                    style: MyTextStyle()
                        .dashboardBoxText(context)
                        .copyWith(color: MyTheme.app_accent_color),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon/add.png',
                        color: MyTheme.app_accent_color,
                        height: 24,
                        width: 42,
                        fit: BoxFit.contain,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget productsContainer(List<Product> productList) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LangText(context: context).getLocal().all_products_ucf,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MyTheme.app_accent_color),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productList.length + 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == productList.length) {
                  return moreProductLoading();
                }
                return productItem(
                    index: index,
                    productId: productList[index].id,
                    imageUrl: productList[index].thumbnailImg,
                    productTitle: productList[index].name!,
                    category: productList[index].category,
                    productPrice: productList[index].price.toString(),
                    quantity: productList[index].quantity.toString());
              }),
        ],
      ),
    );
  }

  Container productItem(
      {int? index,
      productId,
      String? imageUrl,
      required String productTitle,
      required category,
      required String productPrice,
      required String quantity}) {
    return MyWidget.customCardView(
        elevation: 5,
        backgroundColor: MyTheme.white,
        height: 90,
        width: mWidth,
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        borderColor: MyTheme.light_grey,
        borderRadius: 6,
        child: InkWell(
          onTap: () {
            slideRightWidget(
                    newPage: UpdateProduct(
                      productId: productId,
                    ),
                    context: context)
                .then((value) {
              resetAll();
            });
          },
          child: Row(
            children: [
              MyWidget.imageWithPlaceholder(
                width: 84.0,
                height: 90.0,
                fit: BoxFit.cover,
                url: imageUrl,
                radius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              // Image.asset(ImageUrl,width: 80,height: 80,fit: BoxFit.contain,),
              const SizedBox(
                width: 11,
              ),
              SizedBox(
                width: mWidth - 129,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: mWidth - 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productTitle,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: MyTheme.font_grey,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  category,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: MyTheme.grey_153,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: showOptions(
                                listIndex: index, productId: productId),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(productPrice,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: MyTheme.app_accent_color,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icon/product.png",
                                width: 10,
                                height: 10,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(quantity,
                                    style: const TextStyle(
                                        fontSize: 13, color: MyTheme.grey_153)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )) as Container;
  }

  showDeleteWarningDialog(id) {
    showDialog(
        context: context,
        builder: (context) => SizedBox(
              width: DeviceInfo(context).getWidth() * 1.5,
              child: AlertDialog(
                title: Text(
                  LangText(context: context).getLocal().warning_ucf,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: MyTheme.red),
                ),
                content: Text(
                  LangText(context: context)
                      .getLocal().do_you_want_to_delete_it,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14),
                ),
                actions: [
                  Buttons(
                      color: MyTheme.app_accent_color,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LangText(context: context).getLocal().no_ucf,
                        style: TextStyle(color: MyTheme.white, fontSize: 12),
                      )),
                  Buttons(
                      color: MyTheme.app_accent_color,
                      onPressed: () {
                        Navigator.pop(context);
                        deleteProduct(id);
                      },
                      child: Text(
                          LangText(context: context).getLocal().yes_ucf,
                          style:
                              TextStyle(color: MyTheme.white, fontSize: 12))),
                ],
              ),
            ));
  }

  Widget showOptions({listIndex, productId}) {
    return SizedBox(
      width: 35,
      child: PopupMenuButton<MenuOptions>(
        offset: const Offset(-12, 0),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Container(
            width: 35,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.topRight,
            child: Image.asset("assets/icon/more.png",
                width: 3,
                height: 15,
                fit: BoxFit.contain,
                color: MyTheme.grey_153),
          ),
        ),
        onSelected: (MenuOptions result) {
          _tabOption(result.index, productId, listIndex);
          // setState(() {
          //   //_menuOptionSelected = result;
          // });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Edit,
            child: Text(getLocal(context).edit_ucf),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Published,
            child: Text(getLocal(context).published),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Featured,
            child: Text(getLocal(context).featured),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Delete,
            child: Text(getLocal(context).delete_ucf),
          ),
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Duplicate,
            child: Text(getLocal(context).duplicate),
          ),
        ],
      ),
    );
  }

  void showPublishUnPublishDialog(int? index, id) {
    //print(index.toString()+" "+_productStatus[index].toString());
    showDialog(
        context: context,
        builder: (context) {
          switchContext = context;
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 75,
              width: DeviceInfo(context).getWidth(),
              child: AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _productList[index!].status
                          ? getLocal(context).published
                          : getLocal(context).unpublished,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Switch(
                      value: _productList[index].status,
                      activeColor: MyTheme.green,
                      inactiveThumbColor: MyTheme.grey_153,
                      onChanged: (value) {
                        productStatusChange(index, value, setState, id);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void showFeaturedUnFeaturedDialog(int? index, id) {
    //print(_productFeatured[index]);
    print(index);
    showDialog(
        context: context,
        builder: (context) {
          featuredSwitchContext = context;
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 75,
              width: DeviceInfo(context).getWidth(),
              child: AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _productList[index!].featured
                          ? getLocal(context).featured
                          : getLocal(context).unfeatured,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Switch(
                      value: _productList[index].featured,
                      activeColor: MyTheme.green,
                      inactiveThumbColor: MyTheme.grey_153,
                      onChanged: (value) {
                        productFeaturedChange(
                            index: index,
                            value: value,
                            setState: setState,
                            id: id);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                width: 10,
              ),
              Text(AppLocalizations.of(context)!.please_wait_ucf),
            ],
          ));
        });
  }

  Widget moreProductLoading() {
    return _showMoreProductLoadingContainer
        ? Container(
            alignment: Alignment.center,
            child: const SizedBox(
              height: 40,
              width: 40,
              child: Row(
                children: [
                  SizedBox(
                    width: 2,
                    height: 2,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          )
        : const SizedBox(
            height: 5,
            width: 5,
          );
  }
}

enum MenuOptions { Edit, Published, Featured, Delete, Duplicate }
