import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  late HomeController homeController;

  final CartController cartController = Get.find<CartController>();

  final Rxn<ProductModel> product = Rxn<ProductModel>();

  // QUANTITY
  final quantity = 1.obs;

  // SELECTED SIZE
  final selectedSize = '42'.obs;

  // FAVORITE
  final isFavorite = false.obs;

  // AVAILABLE SIZES
  final availableSizes = <String>['39', '40', '41', '42', '43', '44', '45'];

  @override
  void onInit() {
    super.onInit();

    homeController = Get.find<HomeController>();

    final arguments = Get.arguments;

    if (arguments is Map) {
      final productData = ProductModel.fromJson(
        Map<String, dynamic>.from(arguments),
      );

      product.value = productData;

      isFavorite.value = homeController.isFavorite(productData.id);
    }
  }

  // INCREASE QUANTITY
  void incrementQuantity() {
    quantity.value++;
  }

  // DECREASE QUANTITY
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // CHANGE SIZE
  void changeSize(String size) {
    selectedSize.value = size;
  }

  // TOGGLE FAVORITE
  void toggleFavorite() {
    final currentProduct = product.value;

    if (currentProduct == null) return;

    homeController.toggleFavorite(currentProduct.id);

    isFavorite.value = homeController.isFavorite(currentProduct.id);
  }

  // ADD TO CART
  void addToCart() {
    final currentProduct = product.value;

    if (currentProduct == null) return;

    cartController.addItem(
      product: currentProduct,
      quantity: quantity.value,
      size: selectedSize.value,
    );

    quantity.value = 1;
  }
}
