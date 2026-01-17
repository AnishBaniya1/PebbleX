import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pebblex_app/providers/product_provider.dart';
import 'package:pebblex_app/views/order/order_page.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    // ✅ Trigger search when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().searchproduct(
        productname: widget.searchQuery,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          'Search: "${widget.searchQuery}"',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            // Loading State
            if (productProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            // Error State
            if (productProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Error: ${productProvider.errorMessage}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        productProvider.searchproduct(
                          productname: widget.searchQuery,
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            final searchResults = productProvider.searchResults;

            // Empty State
            if (searchResults.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No products found for',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${widget.searchQuery}"',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Results Found
            return RefreshIndicator(
              onRefresh: () => productProvider.searchproduct(
                productname: widget.searchQuery,
              ),
              color: Colors.blue.shade700,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 20 : 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Results Count
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 12 : 8,
                          vertical: isTablet ? 16 : 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.blue.shade700,
                              size: isTablet ? 28 : 24,
                            ),
                            SizedBox(width: isTablet ? 12 : 8),
                            Text(
                              '${searchResults.length} result${searchResults.length > 1 ? 's' : ''} found',
                              style: TextStyle(
                                fontSize: isTablet ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 10),

                      // Grid View
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 3 : 2,
                          crossAxisSpacing: isTablet ? 16 : 10,
                          mainAxisSpacing: isTablet ? 16 : 10,
                          childAspectRatio: isTablet ? 0.8 : 0.75,
                        ),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final product = searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderPage(
                                    productId: product.id ?? '',
                                    supplierId:
                                        '', // ✅ Search model doesn't have supplier, pass empty string
                                    name:
                                        product.name ??
                                        'Unknown', // ✅ Changed from productName
                                    price: (product.price ?? 0)
                                        .toDouble(), // ✅ Changed from productPrice
                                    images:
                                        product
                                            .images
                                            .isNotEmpty // ✅ Changed from imageUrl
                                        ? product.images.first
                                        : '',
                                    category:
                                        product.category ??
                                        '', // ✅ Changed from productCategory
                                    stock: product.stock ?? 0,
                                    description: '',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: product.images.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: product.images.first,
                                            height: isTablet ? 140 : 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                                  height: isTablet ? 140 : 120,
                                                  color: Colors.grey.shade200,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.blue,
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  height: isTablet ? 140 : 120,
                                                  color: Colors.grey.shade200,
                                                  child: const Icon(
                                                    Icons.inventory_2_outlined,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          )
                                        : Container(
                                            height: isTablet ? 140 : 120,
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.inventory_2_outlined,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),

                                  // Product Details
                                  Padding(
                                    padding: EdgeInsets.all(isTablet ? 12 : 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name ?? 'Unknown',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isTablet ? 18 : 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: isTablet ? 6 : 4),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isTablet ? 10 : 8,
                                            vertical: isTablet ? 6 : 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            product.category ?? '',
                                            style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontSize: isTablet ? 13 : 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 6 : 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Rs. ${product.price}',
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: isTablet ? 15 : 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Stock: ${product.stock}',
                                              style: TextStyle(
                                                color: (product.stock ?? 0) > 0
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontSize: isTablet ? 13 : 12,
                                                fontWeight: FontWeight.w600,
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
