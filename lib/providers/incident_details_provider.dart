import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/incident/incident.dart';
import 'package:hayagsync_app/services/incident_service.dart';

final incidentDetailProvider = FutureProvider.family<Incident, String>(
  (ref, id) async => IncidentService.getIncidentById(id),
);
