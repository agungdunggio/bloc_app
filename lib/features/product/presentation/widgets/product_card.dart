import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final ProductEntity product;
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
