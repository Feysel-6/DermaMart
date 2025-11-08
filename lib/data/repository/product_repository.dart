import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../main.dart';
import '../../../utlis/constants/image_strings.dart';
import '../model/product_model.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = Supabase.instance.client;

  Future<List<ProductModel>> getAllProducts() async {
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
}

// Future<List<ProductModel>> fetchFeaturedProducts() async {
//   try {
//     final response = await _db
//         .from('products')
//         .select('''
//           *,
//           brand:brands(id, name, image)
//         ''')
//         .eq('is_featured', true).limit(6);
//
//     final rows = response as List;
//
//     return rows.map((raw) {
//       Map<String, dynamic>? brand;
//       final rawBrand = raw['brand'];
//       if (rawBrand != null) {
//         if (rawBrand is List && rawBrand.isNotEmpty) {
//           brand = Map<String, dynamic>.from(rawBrand[0] as Map);
//         } else if (rawBrand is Map) {
//           brand = Map<String, dynamic>.from(rawBrand);
//         }
//       }
//
//       // Build a cleaned map for ProductModel.fromMap()
//       final cleaned = {
//         ...Map<String, dynamic>.from(raw as Map),
//         'brand': brand,
//       };
//
//       return ProductModel.fromMap(cleaned);
//     }).toList();
//   } on PostgrestException catch (e) {
//     throw Exception('Database Error: ${e.message}');
//   } catch (e) {
//     throw Exception('Something went wrong: $e');
//   }
// }