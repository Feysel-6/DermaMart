import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../main.dart';
import '../../../utlis/constants/image_strings.dart';
import '../model/product_model.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = Supabase.instance.client;

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await _db.from('products').select();

      final rows = response as List;

      return rows.map((raw) {
        final cleaned = Map<String, dynamic>.from(raw as Map);
        return ProductModel.fromMap(cleaned);
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
  Future<List<ProductModel>> fetchRecommendedProducts([String skinType = 'dry']) async {
    try {
      final response = await _db.from('products').select().eq('skin', skinType);

      final rows = response as List;

      return rows.map((raw) {
        final cleaned = Map<String, dynamic>.from(raw as Map);
        return ProductModel.fromMap(cleaned);
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}