import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/cubit/users_page_cubit.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/cubit/users_page_state.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/view/users_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      // La vista solo pide el Cubit al service locator.
      // No sabe (ni le importa) cómo se construye.
      create: (_) => sl<UsersPageCubit>()..loadUsers(),
      child: TpAppScaffold(
        pageTitle: l10n?.users ?? 'Users',
        body: SafeArea(
          child: BlocBuilder<UsersPageCubit, UsersPageState>(
            builder: (context, state) {
              if (state is UsersPageInitial || state is UsersPageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UsersPageLoaded) {
                return UsersView(users: state.users);
              } else if (state is UsersPageError) {
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
