import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


void main() {
  runApp(const ShoppingCartApp());
}

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: buildAppBar(),
        body: const ShoppingScreen(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5,
      title: const Text(
        'My Bag',
        style: TextStyle(
          color: Colors.black,
          fontSize: 35,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
          ),
          onPressed: () {
            // Add your onPressed logic here
          },
          color: Colors.black,
          iconSize: 28,
        ),
      ],
    );
  }
}

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<int> quantities = [1, 1, 1];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    updateTotalPrice();
  }

  void updateTotalPrice() {
    double total = 0.0;
    for (int i = 0; i < quantities.length; i++) {
      total += quantities[i] * getItemPrice(i);
    }

    setState(() {
      totalPrice = total;
    });
  }

  double getItemPrice(int index) {
    switch (index) {
      case 0:
        return 51.0;
      case 1:
        return 30.0;
      case 2:
        return 43.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildProductCard(
                  itemName: 'Hudi',
                  unitPrice: 51.0,
                  color: 'Black',
                  size: 'L',
                  image: 'hudi',
                  quantity: quantities[0],
                  updateTotalPrice: updateTotalPrice,
                  updateQuantity: (value) {
                    handleQuantityUpdate(value, 0);
                  },
                ),
                buildProductCard(
                  itemName: 'T-shirt',
                  unitPrice: 30.0,
                  color: 'Deep Green',
                  size: 'XL',
                  image: 'tshirt',
                  quantity: quantities[1],
                  updateTotalPrice: updateTotalPrice,
                  updateQuantity: (value) {
                    handleQuantityUpdate(value, 1);
                  },
                ),
                buildProductCard(
                  itemName: 'Shoes',
                  unitPrice: 43.0,
                  color: 'Black and white',
                  size: '41',
                  image: 'shoes',
                  quantity: quantities[2],
                  updateTotalPrice: updateTotalPrice,
                  updateQuantity: (value) {
                    handleQuantityUpdate(value, 2);
                  },
                ),
              ],
            ),
          ),
        ),
        TotalPriceRow(totalPrice: totalPrice),
        CheckoutButton(
          onCheckout: () => showSnackbar(
            context,
            'Order placed successfully!',
          ),
        ),
      ],
    );
  }

  void handleQuantityUpdate(int value, int index) {
    if (value > 0 && value <= 15) {
      setState(() {
        quantities[index] = value;
        updateTotalPrice();
        if (value == 5) {
          showAddedToCartDialog('Item', value);
        }
      });
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showAddedToCartDialog(String itemName, int quantity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: Text("Added $quantity $itemName(s) to your cart!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OKAY',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildProductCard({
    required String itemName,
    required double unitPrice,
    required String color,
    required String size,
    required String image,
    required int quantity,
    required Function updateTotalPrice,
    required Function(int) updateQuantity,
  }) {
    return ProductCard(
      itemName: itemName,
      unitPrice: unitPrice,
      color: color,
      size: size,
      image: image,
      quantity: quantity,
      updateTotalPrice: updateTotalPrice,
      updateQuantity: updateQuantity,
    );
  }
}

class ProductCard extends StatefulWidget {
  final String itemName;
  final double unitPrice;
  final String color;
  final String size;
  final String image;
  final int quantity;
  final Function updateTotalPrice;
  final Function(int) updateQuantity;

  const ProductCard({
    Key? key,
    required this.itemName,
    required this.unitPrice,
    required this.color,
    required this.size,
    required this.image,
    required this.quantity,
    required this.updateTotalPrice,
    required this.updateQuantity,
  }) : super(key: key);

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: Image.asset(
                      'assets/${widget.image.toLowerCase()}.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      //color: Colors.cyan,
                      height: 115,
                      width: 238,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    widget.itemName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/ellipsis.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    onPressed: () {
                                      // Handle button press
                                    },
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text('Color: ${widget.color}'),
                                const SizedBox(width: 10),

                                Text('Size: ${widget.size}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (widget.quantity > 1) {
                                            widget.updateQuantity(widget.quantity - 1);
                                          }
                                        },
                                      ),
                                      Text('${widget.quantity}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          if (widget.quantity < 15) {
                                            widget.updateQuantity(widget.quantity + 1);
                                            if (widget.quantity == 5) {
                                              // Show dialog or perform other actions if needed
                                            }
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 40),
                                      Text(
                                        'Price: \$${(widget.quantity * widget.unitPrice).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalPriceRow extends StatelessWidget {
  final double totalPrice;

  const TotalPriceRow({
    Key? key,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Price:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final VoidCallback onCheckout;

  const CheckoutButton({Key? key, required this.onCheckout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        child: const Text(
          'CHECK OUT',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}


