import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(String productName) onProductRemoved;

  const CartScreen({
    Key? key,
    required this.cart,
    required this.onProductRemoved,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Calculate total price of all items in the cart
  double getTotalPrice() {
    double total = 0.0;
    for (var item in widget.cart) {
      double price = item['price'] ?? 0.0;
      int quantity = item['quantity'] ?? 0;
      total += price * quantity;
    }
    return total;
  }

  // Remove an item from the cart
  void removeItem(Map<String, dynamic> product) {
    setState(() {
      widget.cart.remove(product);
      widget.onProductRemoved(product['name'] ?? '');
    });
  }

  // Update the quantity of a product
  void updateQuantity(Map<String, dynamic> product, int newQuantity) {
    setState(() {
      product['quantity'] = newQuantity > 0 ? newQuantity : 1; // Minimum quantity is 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: widget.cart.isEmpty
          ? const Center(
        child: Text('Your cart is empty'),
      )
          : ListView.builder(
        itemCount: widget.cart.length,
        itemBuilder: (context, index) {
          final item = widget.cart[index];
          double price = item['price'] ?? 0.0;
          int quantity = item['quantity'] ?? 0;
          double subtotal = price * quantity;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  item['image'] != null
                      ? Image.asset(
                    item['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.image_not_supported, size: 60),
                  const SizedBox(width: 16),

                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name
                        Text(
                          item['name'] ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),

                        Text(
                          'Unit Price: KES ${price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        // Quantity Selector
                        Row(
                          children: [
                            // Decrease quantity button with blue background
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.remove, color: Colors.white),
                                onPressed: () {
                                  if (quantity > 1) {
                                    updateQuantity(item, quantity - 1);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Display current quantity
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),

                            // Increase quantity button with blue background
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  updateQuantity(item, quantity + 1);
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),
                      ],
                    ),
                  ),

                  // Subtotal and remove button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Subtotal
                      Text(
                        'Subtotal: KES ${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 8),

                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeItem(item),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Price
            Text(
              'Total: KES ${getTotalPrice().toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Checkout Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Checkout', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

