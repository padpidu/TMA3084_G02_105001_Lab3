
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
  int quantity;

  BakeryProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
        ),
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
  State<BakeryHomePage> createState() =>
      _BakeryHomePageState();
}

class _BakeryHomePageState extends State<BakeryHomePage> {
  final List<BakeryProduct> products = [
    BakeryProduct(
      name: 'Butter Croissant',
      description: 'Flaky layers with rich, golden butter.',
      price: 5.90,
      icon: Icons.bakery_dining,
      color: navy,
    ),
    BakeryProduct(
      name: 'Melon Pan',
      description: 'Soft Japanese bread with a crisp, sweet crust.',
      price: 6.50,
      icon: Icons.breakfast_dining,
      color: bakeryRed,
    ),
    BakeryProduct(
      name: 'Matcha Bun',
      description: 'A mellow green tea flavour in every bite.',
      price: 6.90,
      icon: Icons.cake,
      color: navy,
    ),
  ];

  int get totalItems => products.fold(
        0,
        (sum, product) => sum + product.quantity,
      );

  double get totalPrice => products.fold(
        0.0,
        (sum, product) =>
            sum + product.price * product.quantity,
      );

  String money(double amount) => 'RM ${amount.toStringAsFixed(2)}';

  void changeQuantity(int index, int change) {
    setState(() {
      final nextQuantity =
          products[index].quantity + change;

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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, refreshSheet) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20, 8, 20, 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'YOUR ORDER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Review your freshly baked selection.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      if (totalItems == 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 28,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 54,
                                  color: Colors.black38,
                                ),
                                SizedBox(height: 12),
                                Text('Your cart is empty.'),
                              ],
                            ),
                          ),
                        )
                      else
                        ...products
                            .where((p) => p.quantity > 0)
                            .map(
                              (product) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor:
                                      product.color,
                                  child: Icon(
                                    product.icon,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${money(product.price)} × ${product.quantity}',
                                ),
                                trailing: Text(
                                  money(
                                    product.price *
                                        product.quantity,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      const Divider(height: 28),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            money(totalPrice),
                            style: const TextStyle(
                              fontSize: 23,
                              color: navy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: totalItems == 0
                              ? null
                              : () {
                                  Navigator.pop(sheetContext);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Order reviewed! '
                                        'Payment is not connected yet.',
                                      ),
                                    ),
                                  );
                                },
                          icon: const Icon(
                            Icons.check_circle_outline,
                          ),
                          label: const Text('Confirm Order'),
                        ),
                      ),
                      if (totalItems > 0)
                        Center(
                          child: TextButton(
                            onPressed: () {
                              clearCart();
                              refreshSheet(() {});
                            },
                            child: const Text('Clear cart'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Text(
              'JAPANESE STREET BAKERY',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
              ),
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
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWelcomeBanner(),
          const SizedBox(height: 26),
          _buildSectionHeading(),
          const SizedBox(height: 14),
          ...List.generate(
            products.length,
            (index) => _buildProductCard(
              products[index],
              index,
            ),
          ),
          const SizedBox(height: 8),
          _buildCartSummary(),
          const SizedBox(height: 20),
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
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(22),
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
          Text(
            '焼きたて！',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Fresh from the oven.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Japanese-inspired treats, baked with love.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
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
          style: const TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    BakeryProduct product,
    int index,
  ) {
    return Card(
      color: product.color,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                product.icon,
                color: Colors.white,
                size: 32,
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
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
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
                        onPressed: () =>
                            changeQuantity(index, 1),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total items: $totalItems',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
