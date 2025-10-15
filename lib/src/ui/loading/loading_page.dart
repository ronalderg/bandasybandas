import 'package:bandasybandas/src/core/theme/assets.gen.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Assets.images.logo.image(),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
