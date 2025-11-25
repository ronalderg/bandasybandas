import 'package:bandasybandas/src/features/technical_service/domain/models/technical_service_model.dart';
import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:flutter/material.dart';

class TechnicalServicesView extends StatelessWidget {
  const TechnicalServicesView({
    required this.services,
    super.key,
  });

  final List<TechnicalServiceModel> services;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(
        child: Text(
          'No hay servicios técnicos registrados',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              service.serviceNumber,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Cliente: ${service.clientName}'),
                Text('Teléfono: ${service.clientPhone}'),
                Text('Problema: ${service.reportedIssue}'),
                const SizedBox(height: 4),
                Chip(
                  label: Text(
                    service.status.name.toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getStatusColor(service.status),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Color _getStatusColor(EntityStatus status) {
    switch (status) {
      case EntityStatus.active:
        return Colors.blue.shade100;
      case EntityStatus.pending:
        return Colors.orange.shade100;
      case EntityStatus.archived:
        return Colors.grey.shade100;
      case EntityStatus.deleted:
        return Colors.red.shade100;
      case EntityStatus.draft:
        return Colors.yellow.shade100;
      case EntityStatus.sold:
        return Colors.green.shade100;
    }
  }
}
