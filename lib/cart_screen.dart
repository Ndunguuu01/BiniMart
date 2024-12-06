import 'package:binimart_app/main.dart';
import 'package:flutter/material.dart';
import  'services/api_service.dart';
import 'dart:developer';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(String) onProductRemoved;
  
  const CartPage({
    super.key,
    required this.cartItems,
    required this.onProductRemoved,
    });

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  _loadCart() async {
    // Call your backend to fetch cart items
    try {
      final response = await _apiService.getProducts(); // Replace with your cart API
      setState(() {
        cartItems = response;
      });
    } catch (e) {
      log('Error loading cart items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
    double vat = total * 0.02;
    double finalAmount = total + vat;

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your Cart is Empty"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final price = item['price'] * item['quantity'];

                return ListTile(
                  leading: Image.asset(item['image'], width: 50, height: 50),
                  title: Text(item['name']),
                  subtitle: Text('Quantity: ${item['quantity']} - \$${price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      // Remove from cart
                      _apiService.removeFromCart(item['id']);
                      setState(() {
                        cartItems.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total: \$${total.toStringAsFixed(2)}'),
              Text('VAT (2%): \$${vat.toStringAsFixed(2)}'),
              Text(
                'Final Amount: \$${finalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}