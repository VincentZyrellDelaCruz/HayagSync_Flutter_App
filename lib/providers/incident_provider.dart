import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/incident/incident.dart';
import 'package:hayagsync_app/services/incident_service.dart';

final incidentProvider = NotifierProvider<IncidentNotifier, IncidentState>(
  IncidentNotifier.new,
);

class IncidentState {
  final bool isLoading;
  final bool hasLoaded;
  final List<Incident> incidents;
  final String? error;

  const IncidentState({
    this.isLoading = false,
    this.hasLoaded = false,
    this.incidents = const [],
    this.error,
  });

  IncidentState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    List<Incident>? incidents,
    String? error,
  }) {
    return IncidentState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      incidents: incidents ?? this.incidents,
      error: error ?? this.error,
    );
  }
}

class IncidentNotifier extends Notifier<IncidentState> {

  @override
  IncidentState build() {
    return const IncidentState();
  }

  void clear() {
    state = const IncidentState();
  }

  Future<void> getIncidents({bool forceRefresh = false}) async {
    if (state.hasLoaded && !forceRefresh) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await IncidentService.getIncidents();

      state = state.copyWith(
        isLoading: false,
        incidents: data,
        hasLoaded: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );

      rethrow;
    }
  }

  Future<void> refresh() async {
    await getIncidents(forceRefresh: true);
  }
}
