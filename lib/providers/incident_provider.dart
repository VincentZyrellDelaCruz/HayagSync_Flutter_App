import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/incident/incident.dart';
import 'package:hayagsync_app/services/incident_service.dart';

final incidentProvider = NotifierProvider<IncidentNotifier, IncidentState>(
  IncidentNotifier.new,
);

class IncidentState {
  final bool isLoading;
  final List<Incident> incidents;
  final String? error;

  const IncidentState({
    this.isLoading = false,
    this.incidents = const [],
    this.error,
  });

  IncidentState copyWith({
    bool? isLoading,
    List<Incident>? incidents,
    String? error,
  }) {
    return IncidentState(
      isLoading: isLoading ?? this.isLoading,
      incidents: incidents ?? this.incidents,
      error: error ?? this.error,
    );
  }
}

class IncidentNotifier extends Notifier<IncidentState> {
  @override
  IncidentState build() {
    getIncidents();
    return IncidentState();
  }

  Future<void> getIncidents() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await IncidentService.getIncidents();

      state = state.copyWith(isLoading: false, incidents: data);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> refresh() async {
    await getIncidents();
  }
}
