import 'package:flutter/material.dart';
import 'package:binimart_app/main.dart';
import 'services/api_service.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Cart items list
              cartItems.isEmpty
                  ? const Center(child: Text("Your Cart is Empty"))
                  : ListView.builder(
                      shrinkWrap: true, // Shrinks to only take up the space needed
                      physics: NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartItems[index]['product'] ?? {}; // Default empty map if null
                        final image = product['image'] ?? 'assets/default_image.png'; // Fallback image
                        final name = product['name'] ?? 'Unnamed Product'; // Fallback name
                        final price = product['price'] * product['quantity'];

                        return ListTile(
                          leading: Image.asset(image, width: 50, height: 50),
                          title: Text(name),
                          subtitle: Text('Quantity: ${product['quantity']} - \$${price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              // Remove from cart
                              _apiService.removeFromCart(product['id']);
                              setState(() {
                                cartItems.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),

              // Total and VAT information
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
