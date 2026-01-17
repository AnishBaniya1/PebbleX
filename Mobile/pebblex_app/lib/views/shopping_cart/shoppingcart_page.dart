import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pebblex_app/providers/cart_provider.dart';
import 'package:pebblex_app/providers/product_provider.dart';
import 'package:pebblex_app/views/shopping_cart/widgets/orderconfirmationsheet.dart';
import 'package:provider/provider.dart';

class ShoppingcartPage extends StatefulWidget {
  const ShoppingcartPage({super.key});

  @override
  State<ShoppingcartPage> createState() => _ShoppingcartPageState();
}

class _ShoppingcartPageState extends State<ShoppingcartPage> {
  Future<void> _placeOrder() async {
    final cartProvider = context.read<CartProvider>();
    final productProvider = context.read<ProductProvider>();

    if (cartProvider.itemCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Get all cart items
    final cartItems = cartProvider.items.values.toList();

    if (cartItems.isEmpty) {
      return;
    }

    // Get supplier ID from first item (all items are from same supplier)
    final supplierId = cartItems.first.supplierId;

    // Validate supplier ID
    if (supplierId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid supplier information'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Prepare order items
      final orderItems = cartItems
          .map((item) => {'product': item.productId, 'quantity': item.quantity})
          .toList();

      // Debug logging
      print('📤 Placing order for supplier: $supplierId');
      print('📤 Order items: $orderItems');
      print('📦 Total items: ${cartProvider.itemCount}');
      print('💰 Total amount: Rs. ${cartProvider.totalAmount}');

      // Place order
      final orderResult = await productProvider.orderproduct(
        supplierId: supplierId,
        items: orderItems,
      );

      // Debug response
      print('📥 Order result: ${orderResult?.order?.id}');
      print('📥 Message: ${orderResult?.message}');
      print('📥 Status: ${orderResult?.order?.status}');

      if (orderResult == null) {
        throw Exception('Order result is null');
      }

      // ✅ Check if order exists (success means order object is not null)
      if (orderResult.order == null) {
        throw Exception(orderResult.message ?? 'Order failed');
      }

      if (mounted) {
        // Show confirmation sheet
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => OrderConfirmationSheet(
            totalPrice: cartProvider.totalAmount,
            totalQuantity: cartProvider.itemCount,
            orderResult: orderResult,
          ),
        );

        // Clear cart after successful order
        cartProvider.clearCart();
      }
    } catch (e) {
      print('💥 Order error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Order failed: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22 : 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => cart.itemCount > 0
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Clear Cart'),
                          content: const Text(
                            'Are you sure you want to remove all items?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                cart.clearCart();
                                Navigator.of(ctx).pop();
                              },
                              child: const Text(
                                'Clear',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: isTablet ? 120 : 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    'Add products to get started',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items.values.toList()[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isTablet ? 16 : 12),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  item.image.isNotEmpty && item.image != 'null'
                                  ? CachedNetworkImage(
                                      imageUrl: item.image,
                                      width: isTablet ? 100 : 80,
                                      height: isTablet ? 100 : 80,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width: isTablet ? 100 : 80,
                                        height: isTablet ? 100 : 80,
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            width: isTablet ? 100 : 80,
                                            height: isTablet ? 100 : 80,
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.shopping_bag,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    )
                                  : Container(
                                      width: isTablet ? 100 : 80,
                                      height: isTablet ? 100 : 80,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.shopping_bag,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                            SizedBox(width: isTablet ? 16 : 12),
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: isTablet ? 6 : 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 10 : 8,
                                      vertical: isTablet ? 5 : 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: isTablet ? 13 : 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 10 : 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Rs. ${item.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: isTablet ? 18 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                      Text(
                                        ' × ${item.quantity}',
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: isTablet ? 6 : 4),
                                  Text(
                                    'Total: Rs. ${item.totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Quantity Controls
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (item.quantity < item.stock) {
                                      cart.updateQuantity(
                                        item.productId,
                                        item.quantity + 1,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Max stock: ${item.stock}',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.blue.shade700,
                                    size: isTablet ? 28 : 24,
                                  ),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      cart.updateQuantity(
                                        item.productId,
                                        item.quantity - 1,
                                      );
                                    } else {
                                      cart.removeItem(item.productId);
                                    }
                                  },
                                  icon: Icon(
                                    item.quantity > 1
                                        ? Icons.remove_circle
                                        : Icons.delete,
                                    color: item.quantity > 1
                                        ? Colors.blue.shade700
                                        : Colors.red,
                                    size: isTablet ? 28 : 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bottom Summary
              Container(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Items:',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${cart.totalQuantity}',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs. ${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      Consumer<ProductProvider>(
                        builder: (context, productProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: isTablet ? 60 : 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: productProvider.isLoading
                                  ? null
                                  : _placeOrder,
                              child: productProvider.isLoading
                                  ? SizedBox(
                                      height: isTablet ? 28 : 24,
                                      width: isTablet ? 28 : 24,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'PLACE ORDER',
                                      style: TextStyle(
                                        fontSize: isTablet ? 20 : 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
