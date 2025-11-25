import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/technical_service/ui/pages/technical_services/cubit/technical_services_page_cubit.dart';
import 'package:bandasybandas/src/features/technical_service/ui/pages/technical_services/cubit/technical_services_page_state.dart';
import 'package:bandasybandas/src/features/technical_service/ui/pages/technical_services/view/technical_services_view.dart';
import 'package:bandasybandas/src/shared/templates/tp_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TechnicalServicesPage extends StatelessWidget {
  const TechnicalServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TechnicalServicesPageCubit>()..loadTechnicalServices(),
      child: TpAppScaffold(
        pageTitle: 'Servicios Técnicos',
        body: SafeArea(
          child: BlocBuilder<TechnicalServicesPageCubit,
              TechnicalServicesPageState>(
            builder: (context, state) {
              if (state is TechnicalServicesPageInitial ||
                  state is TechnicalServicesPageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TechnicalServicesPageLoaded) {
                return TechnicalServicesView(services: state.services);
              } else if (state is TechnicalServicesPageError) {
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
