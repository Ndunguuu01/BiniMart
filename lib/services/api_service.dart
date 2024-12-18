import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://192.168.100.51:5001/api/products"; 

  // Fetch products from the API
  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Add item to the cart
  Future<void> addToCart(int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      body: json.encode({
        'productId': productId,
        'quantity': quantity,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add item to cart');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$productId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from cart');
    }
  }

  // Get the user's wishlist
  Future<List<Map<String, dynamic>>> getWishlist() async {
    final response = await http.get(Uri.parse('$baseUrl/wishlist'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load wishlist');
    }
  }

  // Add item to the wishlist
  Future<void> addToWishlist(int productId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wishlist'),
      body: json.encode({
        'productId': productId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add item to wishlist');
    }
  }

  // Remove item from wishlist
  Future<void> removeFromWishlist(int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/wishlist/$productId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from wishlist');
    }
  }
}
