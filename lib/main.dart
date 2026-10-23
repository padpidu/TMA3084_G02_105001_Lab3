import 'package:flutter/material.dart';

void main() {
  runApp(const PadBakeryApp());
}

const Color navy = Color(0xFF153E75);
const Color bakeryRed = Color(0xFFB32635);
const Color pageBackground = Color(0xFFF5F7FB);

class BakeryProduct {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final Color color;
  final String? imagePath;
  int quantity;

  BakeryProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
    this.imagePath,
    this.quantity = 0,
  });
}

class PadBakeryApp extends StatelessWidget {
  const PadBakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAD BAKERY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: navy),
        scaffoldBackgroundColor: pageBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const BakeryHomePage(),
    );
  }
}

class BakeryHomePage extends StatefulWidget {
  const BakeryHomePage({super.key});

  @override
  State<BakeryHomePage> createState() => _BakeryHomePageState();
}

class _BakeryHomePageState extends State<BakeryHomePage> {
  final List<BakeryProduct> products = [
    BakeryProduct(
      name: 'Butter Croissant',
      description: 'Flaky layers with rich, golden butter.',
      price: 5.90,
      icon: Icons.bakery_dining,
      color: navy,
      imagePath: 'assets/images/butter_kwason.jpg',
    ),
    BakeryProduct(
      name: 'Melon Pan',
      description: 'Soft Japanese bread with a crisp, sweet crust.',
      price: 6.50,
      icon: Icons.breakfast_dining,
      color: bakeryRed,
      imagePath: 'assets/images/melon_pan.jpg',
    ),
    BakeryProduct(
      name: 'Matcha Bun',
      description: 'A mellow green tea flavour in every bite.',
      price: 6.90,
      icon: Icons.cake,
      color: navy,
      imagePath: 'assets/images/matcha_bun.jpg',
    ),
  ];

  int get totalItems =>
      products.fold(0, (sum, product) => sum + product.quantity);

  double get totalPrice => products.fold(
    0.0,
    (sum, product) => sum + product.price * product.quantity,
  );

  String money(double amount) => 'RM ${amount.toStringAsFixed(2)}';

  void changeQuantity(int index, int change) {
    setState(() {
      final nextQuantity = products[index].quantity + change;

      if (nextQuantity >= 0) {
        products[index].quantity = nextQuantity;
      }
    });
  }

  void clearCart() {
    setState(() {
      for (final product in products) {
        product.quantity = 0;
      }
    });
  }

  void showCheckout() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          products: products,
          money: money,
          onClearCart: clearCart,
          onConfirmOrder: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(this.context).showSnackBar(
              const SnackBar(
                content: Text('Order reviewed! Payment is not connected yet.'),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PAD BAKERY',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            Text(
              'JAPANESE STREET BAKERY',
              style: TextStyle(fontSize: 10, letterSpacing: 1.5),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Badge(
                isLabelVisible: totalItems > 0,
                label: Text('$totalItems'),
                child: IconButton(
                  tooltip: 'Open shopping cart',
                  onPressed: showCheckout,
                  icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _buildWelcomeBanner(),
          const SizedBox(height: 22),
          _buildSectionHeading(),
          const SizedBox(height: 10),
          ...List.generate(
            products.length,
            (index) => _buildProductCard(products[index], index),
          ),
          const SizedBox(height: 8),
          _buildCartSummary(),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              '焼きたて • BAKED WITH LOVE',
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 1.4,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [navy, Color(0xFF2867A8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('焼きたて！', style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 6),
          Text(
            'Fresh from the oven.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Japanese-inspired treats, baked with love.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'OUR MENU',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
          ),
        ),
        Text(
          '${products.length} ITEMS',
          style: const TextStyle(color: navy, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProductCard(BakeryProduct product, int index) {
    return Card(
      color: product.color,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 100,
                height: 100,
                child: product.imagePath != null
                    ? Image.asset(
                        product.imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white24,
                            child: Icon(
                              product.icon,
                              color: Colors.white,
                              size: 32,
                            ),
                          );
                        },
                      )
                    : Icon(product.icon, color: Colors.white, size: 32),
              ),
            ),

            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    money(product.price),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove,
                        onPressed: product.quantity > 0
                            ? () => changeQuantity(index, -1)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          '${product.quantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _quantityButton(
                        icon: Icons.add,
                        onPressed: () => changeQuantity(index, 1),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'QTY',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          disabledBackgroundColor: Colors.white24,
          disabledForegroundColor: Colors.white54,
        ),
        icon: Icon(icon, size: 18),
      ),
    );
  }

  Widget _buildCartSummary() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YOUR BASKET',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total items: $totalItems',
                  style: const TextStyle(color: Colors.black54),
                ),
                Text(
                  money(totalPrice),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: showCheckout,
                icon: const Icon(Icons.receipt_long),
                label: const Text('View Cart & Checkout'),
                style: FilledButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.products,
    required this.money,
    required this.onClearCart,
    required this.onConfirmOrder,
  });

  final List<BakeryProduct> products;
  final String Function(double amount) money;
  final VoidCallback onClearCart;
  final VoidCallback onConfirmOrder;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int get totalItems =>
      widget.products.fold(0, (sum, product) => sum + product.quantity);

  double get totalPrice => widget.products.fold(
    0.0,
    (sum, product) => sum + product.price * product.quantity,
  );

  @override
  Widget build(BuildContext context) {
    final selectedProducts = widget.products
        .where((product) => product.quantity > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CHECKOUT'),
        leading: IconButton(
          tooltip: 'Back to bakery',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [navy, Color(0xFF2867A8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.receipt_long, color: Colors.white, size: 32),
                SizedBox(height: 12),
                Text(
                  'YOUR ORDER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Review your freshly baked selection.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'ORDER SUMMARY',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: selectedProducts.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 52,
                              color: Colors.black38,
                            ),
                            SizedBox(height: 12),
                            Text('Your cart is empty.'),
                            SizedBox(height: 4),
                            Text(
                              'Return to the menu to add some treats.',
                              style: TextStyle(color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        for (final product in selectedProducts) ...[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: product.color,
                              child: Icon(product.icon, color: Colors.white),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${widget.money(product.price)} × ${product.quantity}',
                            ),
                            trailing: Text(
                              widget.money(product.price * product.quantity),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                        ],
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total items',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        '$totalItems',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'GRAND TOTAL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.money(totalPrice),
                        style: const TextStyle(
                          color: navy,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: totalItems == 0 ? null : widget.onConfirmOrder,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Confirm Order'),
              style: FilledButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          if (totalItems > 0)
            Center(
              child: TextButton(
                onPressed: () {
                  widget.onClearCart();
                  setState(() {});
                },
                child: const Text('Clear cart'),
              ),
            ),
        ],
      ),
    );
  }
}
