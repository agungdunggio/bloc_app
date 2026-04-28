import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '../widgets/product_card.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductDetailRequested(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (prev, curr) =>
            prev.isLoadingDetail != curr.isLoadingDetail ||
            prev.selectedProduct != curr.selectedProduct ||
            prev.recommendations != curr.recommendations ||
            prev.detailFailure != curr.detailFailure,
        builder: (context, state) {
          if (state.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.detailFailure != null) {
            return Center(child: Text(state.detailFailure!.message));
          }
          final product = state.selectedProduct;
          if (product == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.thumbnail.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(product.thumbnail),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(product.description),
                  const SizedBox(height: 8),
                  Text('Price: \$${product.price.toStringAsFixed(2)}'),
                  Text('Rating: ${product.rating.toStringAsFixed(1)}'),
                  const SizedBox(height: 20),
                  Text(
                    'Recommended',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 240,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.recommendations.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final recommendation = state.recommendations[index];
                        return SizedBox(
                          width: 320,
                          child: ProductCard(
                            product: recommendation,
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailPage(
                                    productId: recommendation.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
