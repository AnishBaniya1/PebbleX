import 'package:flutter/material.dart';
import 'package:pebblex_app/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderHistorypage extends StatefulWidget {
  const OrderHistorypage({super.key});

  @override
  State<OrderHistorypage> createState() => _OrderHistorypageState();
}

class _OrderHistorypageState extends State<OrderHistorypage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().orderhistory();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'shipped':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'rejected':
        return Icons.cancel;
      case 'shipped':
        return Icons.local_shipping;
      case 'cancelled':
        return Icons.remove_circle;
      default:
        return Icons.info;
    }
  }

  double _calculateOrderTotal(List items) {
    double total = 0.0;

    for (final item in items) {
      final double price = (item.product?.price ?? 0).toDouble();
      final int quantity = (item.quantity ?? 0).toInt();

      total += price * quantity;
    }

    return total;
  }

  // int _calculateTotalItems(List items) {
  //   int total = 0;

  //   for (final item in items) {
  //     total += (item.quantity ?? 0).toInt();
  //   }

  //   return total;
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22 : 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<ProductProvider>().orderhistory();
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: isTablet ? 80 : 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: Text(
                      'Error: ${provider.errorMessage}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                  ElevatedButton.icon(
                    onPressed: () => provider.orderhistory(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 32 : 24,
                        vertical: isTablet ? 16 : 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: isTablet ? 100 : 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    'Your order history will appear here',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.orderhistory(),
            color: Colors.blue.shade700,
            child: ListView.builder(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              itemCount: provider.orders.length,
              itemBuilder: (context, index) {
                final order = provider.orders[index];
                final total = _calculateOrderTotal(order.items);
                // final totalItems = _calculateTotalItems(order.items);
                final orderDate = order.createdAt ?? DateTime.now();
                final status = order.status ?? 'pending';

                return Card(
                  margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // _showOrderDetails(context, order, total, totalItems);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order ID and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Order #${order.id?.substring(order.id!.length - 8).toUpperCase() ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 14 : 10,
                                  vertical: isTablet ? 8 : 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getStatusIcon(status),
                                      color: Colors.white,
                                      size: isTablet ? 16 : 14,
                                    ),
                                    SizedBox(width: isTablet ? 6 : 4),
                                    Text(
                                      status.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isTablet ? 12 : 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 16 : 12),

                          // Supplier Info
                          if (order.supplier != null) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.store,
                                  size: isTablet ? 20 : 16,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: isTablet ? 10 : 8),
                                Expanded(
                                  child: Text(
                                    order.supplier!.name ?? 'Unknown Supplier',
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                          ],

                          // Date
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: isTablet ? 20 : 16,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: isTablet ? 10 : 8),
                              Text(
                                DateFormat(
                                  'dd MMM yyyy, hh:mm a',
                                ).format(orderDate),
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 12 : 8),

                          // Items Count
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: isTablet ? 20 : 16,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: isTablet ? 10 : 8),
                              // Text(
                              //   '$totalItems ${totalItems == 1 ? 'item' : 'items'}',
                              //   style: TextStyle(
                              //     fontSize: isTablet ? 16 : 14,
                              //     color: Colors.grey.shade700,
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 16 : 12),

                          const Divider(),
                          SizedBox(height: isTablet ? 12 : 8),

                          // Total Amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                'Rs. ${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: isTablet ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),

                          // ...existing code...

                          // Cancel Button for Pending Orders
                          if (status.toLowerCase() == 'pending') ...[
                            SizedBox(height: isTablet ? 16 : 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => _showCancelConfirmation(
                                  context,
                                  order.id ?? '',
                                ),
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  size: 18,
                                ),
                                label: Text(
                                  'Cancel Order',
                                  style: TextStyle(
                                    fontSize: isTablet ? 14 : 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 20 : 16,
                                    vertical: isTablet ? 12 : 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Cancel Order'),
            ],
          ),
          content: const Text(
            'Are you sure you want to cancel this order? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('No, Keep Order'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Close dialog

                try {
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext loadingContext) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  );

                  // Cancel the order
                  await context.read<ProductProvider>().cancelorder(orderId);

                  // Close loading indicator
                  if (context.mounted) Navigator.pop(context);

                  // Refresh order history
                  if (context.mounted) {
                    await context.read<ProductProvider>().orderhistory();
                  }

                  // Show success message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Order cancelled successfully'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  // Close loading indicator
                  if (context.mounted) Navigator.pop(context);

                  // Show error message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Failed to cancel order: ${e.toString().replaceAll('Exception: ', '')}',
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showOrderDetails(context, order, double total, int totalItems) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final status = order.status ?? 'pending';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 32 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 20 : 16),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 10 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(status),
                        color: Colors.white,
                        size: isTablet ? 20 : 18,
                      ),
                      SizedBox(width: isTablet ? 10 : 8),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 20 : 16),

                // Order ID
                _buildDetailRow(
                  'Order ID',
                  '#${order.id?.substring(order.id!.length - 8).toUpperCase()}',
                  isTablet,
                ),

                // Supplier
                if (order.supplier != null)
                  _buildDetailRow(
                    'Supplier',
                    order.supplier!.name ?? 'Unknown',
                    isTablet,
                  ),

                // Date
                _buildDetailRow(
                  'Order Date',
                  DateFormat(
                    'dd MMM yyyy, hh:mm a',
                  ).format(order.createdAt ?? DateTime.now()),
                  isTablet,
                ),

                SizedBox(height: isTablet ? 24 : 20),
                const Divider(),
                SizedBox(height: isTablet ? 20 : 16),

                // Items List
                Text(
                  'Items ($totalItems)',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),

                ...order.items.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product?.name ?? 'Unknown Product',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: isTablet ? 6 : 4),
                              Text(
                                'Qty: ${(item.quantity ?? 0).toInt()} × Rs. ${item.product?.price ?? 0}',
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Rs. ${(((item.product?.price ?? 0).toDouble()) * ((item.quantity ?? 0).toInt())).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(),
                SizedBox(height: isTablet ? 16 : 12),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs. ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),

                // Cancel Button for Pending Orders
                if (status.toLowerCase() == 'pending') ...[
                  SizedBox(height: isTablet ? 20 : 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                        _showCancelConfirmation(context, order.id ?? '');
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: Text(
                        'Cancel Order',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 14 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 12 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
