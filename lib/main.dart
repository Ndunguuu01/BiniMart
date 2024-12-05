import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'product_details_page.dart';
import 'account_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// Cart Item Model
class CartItem {
  final Map<String, dynamic> product; // Holds the product details
  final int quantity; // Holds the quantity of the product

  CartItem({required this.product, required this.quantity});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> categories = ['All', 'Beverages', 'Flour', 'Drinks', 'Fat & Oil', 'Snacks', 'Cereals', 'Toiletries'];
  String? selectedCategory = 'All';

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Cooking oil 5L',
      'category': 'Fat & Oil',
      'price': 49.99,
      'image': 'assets/images/product1.jpg',
      'rating': 4.5,
      'isWishlisted': false,
    },
    {
      'name': 'Pembe Maize flour 2KG',
      'category': 'Flour',
      'price': 79.99,
      'image': 'assets/images/product2.jpg',
      'rating': 4.0,
      'isWishlisted': false,
    },
    {
      'name': 'Latto Milk 500ML',
      'category': 'Drinks',
      'price': 29.99,
      'image': 'assets/images/product3.jpg',
      'rating': 3.5,
      'isWishlisted': false,
    },
    {
      'name': 'Blue Bubble Toilet Block Lavender 50g',
      'category': 'Toiletries',
      'price': 29.99,
      'image': 'assets/images/Blue Bubble Toilet Block Lavender 50g 4 Pieces.jpg',
      'rating': 2.5,
      'isWishlisted': false,
    },
    {
      'name': 'Cadbury Fruit & Nut 80g',
      'category': 'Snacks',
      'price': 29.99,
      'image': 'assets/images/Cadbury Fruit & Nut 80g.png',
      'rating': 3.5,
      'isWishlisted': false,
    },
    {
      'name': 'Daawat Aromatic Rice 5Kg',
      'category': 'Cereals',
      'price': 29.99,
      'image': 'assets/images/Daawat Aromatic Rice 5Kg.jpg',
      'rating': 3.5,
      'isWishlisted': false,
    },
  ];

  final List<Map<String, dynamic>> otherProducts = [
    {
      'name': 'Blue Bubble Toilet Block Lavender 50g',
      'category': 'Toiletries',
      'price': 29.99,
      'image': 'assets/images/Blue Bubble Toilet Block Lavender 50g 4 Pieces.jpg',
      'rating': 2.5,
      'isWishlisted': false,
    },
    {
      'name': 'Cadbury Fruit & Nut 80g',
      'category': 'Snacks',
      'price': 29.99,
      'image': 'assets/images/Cadbury Fruit & Nut 80g.png',
      'rating': 3.5,
      'isWishlisted': false,
    },
    {
      'name': 'Daawat Aromatic Rice 5Kg',
      'category': 'Cereals',
      'price': 29.99,
      'image': 'assets/images/Daawat Aromatic Rice 5Kg.jpg',
      'rating': 3.5,
      'isWishlisted': false,
    },
  ];

  List<Map<String, dynamic>> wishlist = [];

  Map<String, int> quantities = {};


  Map<String, int> productQuantities = {};

  int quantity = 1;

  String searchQuery = '';

  bool isLoading = true;

  List<Map<String, dynamic>> cart = [];

  Set<String> addedToCartItems = {};




  @override
  void initState() {
    super.initState();
    // Initialize quantities to 1 for each product
    for (var product in products) {
      quantities[product['name']] = 1;
    }
  }

  List<Map<String, dynamic>> get filteredProducts {
    return (selectedCategory == 'All')
        ? products
        : products.where((product) => product['category'] == selectedCategory).toList();
 }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

// Add item to the cart
  void addToCart(Map<String, dynamic> product, int quantity) {
    setState(() {
      // Check if the product is already in the cart
      int existingIndex = cart.indexWhere((item) => item['name'] == product['name']);

      if (existingIndex != -1) {
        // If it exists, update the quantity
        cart[existingIndex]['quantity'] += quantity;
      } else {
        // Otherwise, add the new product to the cart
        cart.add({
          'name': product['name'],
          'price': product['price'],
          'quantity': quantity,
        });
      }

      setState(() {}); // Update the state to reflect changes in the cart
    });
  }

// Remove item from the cart
  void removeFromCart(String productName) {
    setState(() {
      // Remove the product from the cart
      cart.removeWhere((item) => item['name'] == productName);

      // Optionally, reset quantity to 0 for the product
      addedToCartItems.remove(productName);
      productQuantities[productName] = 0;
    });
  }


  // Define the updateCart function
  void updateCart(String productName) {
    setState(() {
      // Remove the product from the cart based on the product name
      cart.removeWhere((item) => item['name'] == productName);
      addedToCartItems.remove(productName); // Optionally remove it from the added list
      productQuantities[productName] = 0;  // Reset quantity to 0 if needed
    });
  }


  void updateQuantity(String productName, int change) {
    setState(() {
      final currentQuantity = quantities[productName] ?? 1;
      final newQuantity = currentQuantity + change;
      if (newQuantity > 0) {
        quantities[productName] = newQuantity;
      }
    });
  }

  void toggleWishlist(Map<String, dynamic> product) {
    setState(() {
      product['isWishlisted'] = !product['isWishlisted'];
      if (product['isWishlisted']) {
        wishlist.add(product);
      } else {
        wishlist.removeWhere((item) => item['name'] == product['name']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profilepic.jpg'),
              radius: 20,
            ),
            const SizedBox(width: 8),
            const Text('Brian N'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cartItems: cart,
                ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF3F3),
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                         icon: const Icon(Icons.clear),
                         onPressed: () {
                             setState(() {
                              searchQuery = '';
                          });
                    },
                  )
                      : null,
                  hintText: 'Search goods',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Carousel banner
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: [
                'assets/images/banner1.jpg',
                'assets/images/banner2.jpg',
                'assets/images/banner3.jpg',
              ].map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            // Categories section
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => selectCategory(categories[index]),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedCategory == categories[index]
                            ? Colors.deepPurple
                            : Colors.grey[200],
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedCategory == categories[index]
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // Products section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Popular Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  productQuantities[product['name']] ??= 1;

                  if (searchQuery.isNotEmpty &&
                      !product['name'].toLowerCase().contains(searchQuery.toLowerCase())) {
                    return Container(); // Skip this product if it doesn't match the search
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(product: product),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 4,
                        child : SizedBox(
                          width: 168,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: product['image'],
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        product['image'],
                                        fit: BoxFit.cover,
                                        width: 168,
                                        height: 180,
                                      ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: IconButton(
                                        icon: Icon(
                                          product['isWishlisted'] ? Icons.favorite : Icons.favorite_border,
                                          color: product['isWishlisted'] ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () => toggleWishlist(product),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('\$${product['price']}'),
                                    const SizedBox(height: 4),
                                    Text('Rating: ${product['rating']}'),
                                    const SizedBox(height: 1),


                                   //Quantity Selector
                                    Row(
                                      children: [
                                        // Decrease Quantity Button with Background Color
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent, // Background color for the minus button
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                                            padding: EdgeInsets.zero,
                                            onPressed: (productQuantities[product['name']] ?? 0) > 0
                                                ? () {
                                              setState(() {
                                                productQuantities[product['name']] = (productQuantities[product['name']] ?? 0) - 1;
                                              });
                                            }
                                                : null,
                                          ),
                                        ),

                                        // Display the current quantity
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            '${productQuantities[product['name']] ?? 0}',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),

                                        // Increase Quantity Button with Background Color
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent, // Background color for the add button
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.add,size: 16, color: Colors.white),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              setState(() {
                                                productQuantities[product['name']] = (productQuantities[product['name']] ?? 0) + 1;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 1),

                                    // Add to Cart
                                    ElevatedButton(
                                      onPressed: (productQuantities[product['name']] ?? 0) > 0 && !addedToCartItems.contains(product['name'])
                                          ? () {
                                        // Get the product quantity
                                        int quantity = productQuantities[product['name']] ?? 1;

                                        // Add the product to the cart
                                        addToCart(product, quantity);

                                        // Mark the product as added to the cart
                                        setState(() {
                                          addedToCartItems.add(product['name']);
                                        });

                                        // Show a confirmation snackbar
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${product['name']} added to cart'),
                                            duration: const Duration(milliseconds: 800),
                                          ),
                                        );
                                      }
                                          : null, // Disable button if quantity is 0 or already added
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: addedToCartItems.contains(product['name']) ? Colors.lime: Colors.lightBlue,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: Colors.grey,
                                      ),
                                      child: Text(
                                        addedToCartItems.contains(product['name']) ? "Added to Cart" : "Add To Cart",
                                      ),
                                    )





                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // More Products section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'More Products',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),

            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: otherProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  productQuantities[product['name']] ??= 1;

                  if (searchQuery.isNotEmpty &&
                      !product['name'].toLowerCase().contains(searchQuery.toLowerCase())) {
                    return Container(); // Skip this product if it doesn't match the search
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(product: product),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 4,
                        child : SizedBox(
                          width: 168,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: product['image'],
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          product['image'],
                                          fit: BoxFit.cover,
                                          width: 168,
                                          height: 180,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: IconButton(
                                        icon: Icon(
                                          product['isWishlisted'] ? Icons.favorite : Icons.favorite_border,
                                          color: product['isWishlisted'] ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () => toggleWishlist(product),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('\$${product['price']}'),
                                    const SizedBox(height: 4),
                                    Text('Rating: ${product['rating']}'),
                                    const SizedBox(height: 1),


                                    //Quantity Selector
                                    Row(
                                      children: [
                                        // Decrease Quantity Button with Background Color
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent, // Background color for the minus button
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                                            padding: EdgeInsets.zero,
                                            onPressed: (productQuantities[product['name']] ?? 0) > 0
                                                ? () {
                                              setState(() {
                                                productQuantities[product['name']] = (productQuantities[product['name']] ?? 0) - 1;
                                              });
                                            }
                                                : null,
                                          ),
                                        ),

                                        // Display the current quantity
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            '${productQuantities[product['name']] ?? 0}',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),

                                        // Increase Quantity Button with Background Color
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent, // Background color for the add button
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.add,size: 16, color: Colors.white),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              setState(() {
                                                productQuantities[product['name']] = (productQuantities[product['name']] ?? 0) + 1;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 1),

                                    // Add to Cart
                                    ElevatedButton(
                                      onPressed: (productQuantities[product['name']] ?? 0) > 0 && !addedToCartItems.contains(product['name'])
                                          ? () {
                                        // Get the product quantity
                                        int quantity = productQuantities[product['name']] ?? 1;

                                        // Add the product to the cart
                                        addToCart(product, quantity);

                                        // Mark the product as added to the cart
                                        setState(() {
                                          addedToCartItems.add(product['name']);
                                        });

                                        // Show a confirmation snackbar
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${product['name']} added to cart'),
                                            duration: const Duration(milliseconds: 800),
                                          ),
                                        );
                                      }
                                          : null, // Disable button if quantity is 0 or already added
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: addedToCartItems.contains(product['name']) ? Colors.lime: Colors.lightBlue,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: Colors.grey,
                                      ),
                                      child: Text(
                                        addedToCartItems.contains(product['name']) ? "Added to Cart" : "Add To Cart",
                                      ),
                                    )





                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) {
                        var wishlistPage = WishlistPage(
                        wishlist: wishlist,
                        removeFromWishlist: toggleWishlist,
                      );
                        return wishlistPage;
                      },
                      ),
                );
              },
            ),
            const SizedBox(width: 40), // space for FAB
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(cartItems: cart,
                    onProductRemoved: updateCart,
                  )),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VouchersPage()),
          );
        },
        child: const Icon(Icons.card_giftcard),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Dummy CartPage widget
class CartPage extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Calculate the total price once outside of the ListView.builder
    double total = cartItems.fold(
      0.0,
          (sum, item) => sum + (item.product['price'] * item.quantity),
    );

    // Calculate VAT and final amount
    double vat = total * 0.02;
    double finalAmount = total + vat;

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cartItems.isEmpty
          ? const Center(
        child: Text(
          "Your Cart is Empty",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final price = item.product['price'] * item.quantity;

          return ListTile(
            leading: Image.asset(
              item.product['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(item.product['name']),
            subtitle: Text(
              'Quantity: ${item.quantity} - \$${price.toStringAsFixed(2)}',
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total: \$${total.toStringAsFixed(2)}'),
              Text('VAT (2%): \$${vat.toStringAsFixed(2)}'),
              Text(
                'Final Amount: \$${finalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy VouchersPage widget
class VouchersPage extends StatelessWidget {
  const VouchersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vouchers')),
      body: const Center(child: Text('Vouchers Page Content')),
    );
  }
}

// Wishlist page
class WishlistPage extends StatefulWidget {
  const WishlistPage({
    super.key,
    required this.wishlist,
    required this.removeFromWishlist,
  });

  final List<Map<String, dynamic>> wishlist;
  final Function(String) removeFromWishlist; // Function to remove item from wishlist

  @override
  WishlistPageState createState() => WishlistPageState();
}

class WishlistPageState extends State<WishlistPage> {
  late List<Map<String, dynamic>> wishlist;

  @override
  void initState() {
    super.initState();
    // Initialize wishlist with data passed to the widget
    wishlist = widget.wishlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: wishlist.isEmpty
          ? const Center(child: Text("Your wishlist is empty"))
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final product = wishlist[index];
                return ListTile(
                  leading: Image.asset(product['image'], width: 50, height: 50),
                  title: Text(product['name']),
                  subtitle: Text('\$${product['price']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () {
                      // Call the remove function passed from the parent widget
                      widget.removeFromWishlist(product['id']);
                      setState(() {
                        wishlist.removeAt(index); // Update local state after removal
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

