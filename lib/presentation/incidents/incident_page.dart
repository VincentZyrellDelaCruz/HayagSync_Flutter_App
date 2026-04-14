import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/providers/incident_provider.dart';

class IncidentPage extends ConsumerStatefulWidget {
  const IncidentPage({super.key});

  @override
  ConsumerState<IncidentPage> createState() => _IncidentPageState();
}

class _IncidentPageState extends ConsumerState<IncidentPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(incidentProvider.notifier).getIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(incidentProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    if (state.incidents.isEmpty) {
      return const Center(
        child: Text('You have no reported incidents so far.'),
      );
    }

    return RefreshIndicator(
      child: ListView.builder(
        itemCount: state.incidents.length,
        itemBuilder: (context, index) {
          final incident = state.incidents[index];

          return ListTile(
            title: Text(incident.title),
            subtitle: Text(incident.description),
          );
        },
      ),
      onRefresh: () => ref.read(incidentProvider.notifier).refresh(),
    );
  }
}
