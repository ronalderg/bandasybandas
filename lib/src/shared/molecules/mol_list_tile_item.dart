import 'package:flutter/material.dart';

class MolListtileItem extends StatelessWidget {
  const MolListtileItem({
    required this.onEditTap,
    required this.onMoreTap,
    required this.onViewTap,
    required this.price,
    required this.quantity,
    required this.subtitle,
    required this.title,
    super.key,
  });
  final VoidCallback? onViewTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onMoreTap;
  final String title;
  final String subtitle;
  final double price;
  final double quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Wrap(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.remove_red_eye)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      title: Text(title),
      subtitle: Text('Stock: $quantity'),
      trailing: Text('\$${price.toStringAsFixed(2)}'),
    );
  }
}
