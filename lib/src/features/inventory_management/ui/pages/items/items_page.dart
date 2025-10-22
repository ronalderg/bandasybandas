import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_cubit.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_state.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/view/items_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // La vista solo pide el Cubit al service locator.
      // No sabe (ni le importa) cómo se construye.
      create: (_) => sl<ItemsCubit>()..loadItems(),
      child: TpAppScaffold(
        pageTitle: 'Items',
        body: SafeArea(
          child: BlocBuilder<ItemsCubit, ItemsPageState>(
            builder: (context, state) {
              if (state is ItemsPageInitial || state is ItemsPageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ItemsPageLoaded) {
                return ItemsView(items: state.items);
              } else if (state is ItemsPageError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
