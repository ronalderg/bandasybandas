import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:bandasybandas/src/features/authentication/ui/pages/login/cubit/login_cubit.dart';
import 'package:bandasybandas/src/features/authentication/ui/pages/login/view/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SIG BANDAS Y BANDAS')),
      body: Padding(
        padding: AppSpacing.horizontalPadding,
        child: BlocProvider(
          create: (_) => LoginCubit(
            GetIt.I<AuthenticationRepository>(),
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
