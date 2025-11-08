import 'package:get/get.dart';

import '../../../../utlis/constants/enums.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    getFeaturedProducts();
    super.onInit();
  }

  void getFeaturedProducts() async {
    try {
      isLoading.value = true;
      final products = await productRepository.getAllProducts();
      featuredProducts.assignAll(products);
    } catch (e) {
      throw Exception('Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}