import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pebblex_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    super.key,
    required this.name,
    required this.price,
    required this.images,
    required this.category,
    required this.supplierId,
    required this.productId,
    required this.stock,
    required this.description,
  });

  final String name;
  final double price;
  final String images;
  final String category;
  final String supplierId;
  final String productId;
  final int stock;
  final String description;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late final TextEditingController _quantityController;
  int _quantity = 1;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _calculateTotal();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    setState(() {
      _totalPrice = widget.price * _quantity;
    });
  }

  void _incrementQuantity() {
    if (_quantity < widget.stock) {
      setState(() {
        _quantity++;
        _quantityController.text = _quantity.toString();
        _calculateTotal();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum stock available: ${widget.stock}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = _quantity.toString();
        _calculateTotal();
      });
    }
  }

  void _onQuantityChanged(String value) {
    final parsedValue = int.tryParse(value);
    if (parsedValue != null && parsedValue > 0 && parsedValue <= widget.stock) {
      setState(() {
        _quantity = parsedValue;
        _calculateTotal();
      });
    } else if (parsedValue != null && parsedValue > widget.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum stock available: ${widget.stock}'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {
        _quantity = widget.stock;
        _quantityController.text = widget.stock.toString();
        _calculateTotal();
      });
    }
  }



  void _addToCart() {
    final cartProvider = context.read<CartProvider>();

    // Add item to cart
    cartProvider.addItem(
      productId: widget.productId,
      supplierId: widget.supplierId,
      name: widget.name,
      category: widget.category,
      image: widget.images,
      price: widget.price,
      stock: widget.stock,
    );

    // Update to selected quantity
    cartProvider.updateQuantity(widget.productId, _quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.name} added to cart ($_quantity items)'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Reset quantity
    setState(() {
      _quantity = 1;
      _quantityController.text = '1';
      _calculateTotal();
    });
  }

 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22 : 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to cart via bottom navigation
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.images,
                          height: isTablet ? 300 : 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: isTablet ? 300 : 200,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: isTablet ? 300 : 200,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.shopping_bag,
                              size: isTablet ? 80 : 60,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          height: isTablet ? 300 : 200,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.shopping_bag,
                            size: isTablet ? 80 : 60,
                            color: Colors.grey,
                          ),
                        ),
                ),
                SizedBox(height: isTablet ? 25 : 20),
                // Product Name
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 10),
                // Category Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.category,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 18 : 15),
                // Description
                if (widget.description.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isTablet ? 10 : 8),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: isTablet ? 25 : 20),
                ],
                // Price
                Row(
                  children: [
                    Text(
                      'Rs. ${widget.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    Text(
                      ' / unit',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 12 : 10),
                // Stock Info
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: isTablet ? 24 : 20,
                      color: widget.stock > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Available Stock: ${widget.stock} units',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: widget.stock > 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 30 : 25),
                // Quantity Section
                Text(
                  'Select Quantity',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isTablet ? 18 : 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Decrement Button
                    IconButton(
                      onPressed: _decrementQuantity,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.blue.shade700,
                      iconSize: isTablet ? 40 : 32,
                    ),
                    const SizedBox(width: 10),
                    // Quantity Input
                    SizedBox(
                      width: isTablet ? 120 : 100,
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: isTablet ? 16 : 12,
                            horizontal: isTablet ? 20 : 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blue.shade700,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: _onQuantityChanged,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Increment Button
                    IconButton(
                      onPressed: _incrementQuantity,
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.blue.shade700,
                      iconSize: isTablet ? 40 : 32,
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 30 : 25),
                // Total Calculation
                Container(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Unit Price:',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                          Text(
                            'Rs. ${widget.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 10 : 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity:',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                          Text(
                            '$_quantity units',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: isTablet ? 24 : 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs. ${_totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 25),
                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  height: isTablet ? 60 : 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: Colors.grey.shade400,
                    ),
                    onPressed: widget.stock <= 0 ? null : _addToCart,
                    icon: Icon(Icons.shopping_cart, size: isTablet ? 24 : 20),
                    label: Text(
                      'ADD TO CART',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
