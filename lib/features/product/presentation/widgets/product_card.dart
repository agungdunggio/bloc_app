import 'package:flutter/material.dart';

import 'package:bloc_state_management/features/product/domain/model/product_model.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final ProductModel product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: product.thumbnail.isNotEmpty
            ? Image.network(
                product.thumbnail,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              )
            : const SizedBox(width: 56, height: 56),
        title: Text(product.title),
        subtitle: Text(
          product.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text('\$${product.price.toStringAsFixed(2)}'),
      ),
    );
  }
}
