import 'package:flutter/foundation.dart';
import '../data_model/products_response.dart';
import '../repositories/product_repository.dart';
import '../repositories/shop_repository.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _productList = [];
  bool _isProductInit = false;
  bool _showMoreProductLoadingContainer = false;
  int _page = 1;

  List<Product> get productList => _productList;
  bool get isProductInit => _isProductInit;
  bool get showMoreProductLoadingContainer => _showMoreProductLoadingContainer;

  Future<void> fetchAll() async {
    _page = 1;
    _productList = [];
    // Clear the list
    await getProductList();
    await getAccountInfo();
    await getProductRemainingUpload();
  }

  Future<void> getProductList() async {
    try {
      var productResponse = await ProductRepository().getProducts(page: _page);
      if (productResponse.data != null) {
        if (productResponse.data!.isEmpty) {
          // Handle no more products or end of list
        } else {
          _productList.addAll(productResponse.data!);
          _showMoreProductLoadingContainer = false;
          _isProductInit = true;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> loadMoreProducts() async {
    _page++; // Increment page number for pagination
    await getProductList();
  }

  Future<void> getAccountInfo() async {
    var response = await ShopRepository().getShopInfo();
    // Process account info
  }

  Future<void> getProductRemainingUpload() async {
    var productResponse = await ProductRepository().remainingUploadProducts();
    // Process remaining product
  }

  Future<void> deleteProduct(int? id) async {
    var response = await ProductRepository().productDeleteReq(id: id);
    if (response.result) {
      _productList.removeWhere((product) => product.id == id);
      notifyListeners();
    }
  }

  Future<void> productStatusChange(int? index, bool value, int id) async {
    var response = await ProductRepository().productStatusChangeReq(id: id, status: value ? 1 : 0);
    if (response.result) {
      _productList[index!].status = value;
      notifyListeners();
    }
  }

  Future<void> productFeaturedChange(int? index, bool value, int id) async {
    var response = await ProductRepository().productFeaturedChangeReq(id: id, featured: value ? 1 : 0);
    if (response.result) {
      _productList[index!].featured = value;
      notifyListeners();
    }
  }
}
