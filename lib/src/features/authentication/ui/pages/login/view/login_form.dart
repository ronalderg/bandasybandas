import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/core/theme/app_spacing.dart';
import 'package:bandasybandas/src/features/authentication/ui/pages/login/cubit/login_cubit.dart';
import 'package:bandasybandas/src/features/authentication/ui/pages/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content:
                    Text(state.errorMessage ?? l10n?.error_unexpected ?? ''),
              ),
            );
        }
      },
      // Centra el formulario en el espacio disponible.
      child: Center(
        // Limita el ancho máximo del formulario a 400 píxeles.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ingrese su información',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  AppSpacing.verticalGapLg,
                  const _EmailInput(),
                  AppSpacing.verticalGapMd,
                  const _PasswordInput(),
                  AppSpacing.verticalGapLg,
                  const _LoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LoginCubit, LoginState>(
      //buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          decoration: InputDecoration(
            labelText: l10n.email,
            errorText: state.email.isNotValid ? l10n.error_invalid_email : null,
          ),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  const _PasswordInput();

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LoginCubit, LoginState>(
      // buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: _isPasswordObscured,
          decoration: InputDecoration(
            labelText: l10n.password,
            errorText: state.password.isNotValid
                ? l10n.error_password_too_short
                : null,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => _isPasswordObscured = !_isPasswordObscured),
            ),
          ),
          onSubmitted: (_) => context.read<LoginCubit>().logInWithCredentials(),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: state.isValid
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: const Text('INICIAR SESIÓN'),
              );
      },
    );
  }
}
