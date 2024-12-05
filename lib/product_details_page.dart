import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  double _rating = 3.5;
  bool _isAddedToCart = false;
  int _quantity = 1;

  // Example list of similar products
  final List<Map<String, dynamic>> similarProducts = [
    {
      'name': 'Product A',
      'image': 'assets/images/product_a.png',
      'price': 100,
      'rating': 4.2,
    },
    {
      'name': 'Product B',
      'image': 'assets/images/product_b.png',
      'price': 150,
      'rating': 4.0,
    },
    {
      'name': 'Product C',
      'image': 'assets/images/product_c.png',
      'price': 80,
      'rating': 3.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centered Product Image
            Center(
              child: Hero(
                tag: product['image'],
                child: SizedBox(
                  height: 320,
                  width: 320,
                  child: Image.asset(
                    product['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product price
                  Text(
                    'KES ${product['price']}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Star Rating
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Product description
                  const Text(
                    'This is a brief description of the product. It includes details about features, usage, and any other relevant information to help the customer make an informed decision.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Add to Cart Button or Quantity Selector
                  _isAddedToCart
                      ? Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (_quantity > 1) _quantity--;
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  )
                      : ElevatedButton(
                         onPressed: () {
                        setState(() {
                        _isAddedToCart = true;
                        });
                       },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                       padding: const EdgeInsets.symmetric(vertical: 16.0),
                       textStyle: const TextStyle(fontSize: 18),
                    ),
                        child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Similar Products Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Similar Products',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similarProducts.length,
                itemBuilder: (context, index) {
                  final similarProduct = similarProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: similarProduct),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            similarProduct['image'],
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Text(similarProduct['name']),
                          Text('KES ${similarProduct['price']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
