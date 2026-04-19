import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/incident/incident_evidence.dart';
import 'package:hayagsync_app/presentation/widgets/expandable_text.dart';
import 'package:hayagsync_app/presentation/widgets/video_preview_dialog.dart';
import 'package:hayagsync_app/providers/incident_details_provider.dart';

class IncidentDetailPage extends ConsumerStatefulWidget {
  const IncidentDetailPage({super.key, required this.incidentId});

  final String incidentId;

  @override
  ConsumerState<IncidentDetailPage> createState() => _IncidentDetailPageState();
}

class _IncidentDetailPageState extends ConsumerState<IncidentDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  void openPreview(IncidentEvidence evidence) {
    showDialog(
      context: context,
      builder: (_) {
        if (evidence.isVideo) {
          return VideoPreviewDialog(url: evidence.fullUrl);
        }

        return Dialog(
          child: InteractiveViewer(child: Image.network(evidence.fullUrl)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidentAsync = ref.watch(incidentDetailProvider(widget.incidentId));

    return incidentAsync.when(
      data: (incident) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Incident Details'),
            bottom: TabBar(
              tabs: const [
                Tab(text: 'Info'),
                Tab(text: 'Latest Update'),
              ],
              controller: _tabController,
            ),
          ),

          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      incident.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (incident.evidences.isNotEmpty) ...[
                      SizedBox(
                        height: 250,
                        child: PageView.builder(
                          itemCount: incident.evidences.length,
                          itemBuilder: (context, index) {
                            final evidence = incident.evidences[index];

                            return GestureDetector(
                              onTap: () => openPreview(evidence),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: evidence.isVideo
                                        ? Stack(
                                            alignment: AlignmentGeometry.center,
                                            children: [
                                              Container(color: Colors.black12),
                                              const Icon(
                                                Icons
                                                    .play_circle_outline_rounded,
                                                size: 70,
                                              ),
                                            ],
                                          )
                                        : Image.network(
                                            evidence.fullUrl,
                                            fit: BoxFit.cover,
                                          ),
                                  ),

                                  if (evidence.caption != null &&
                                      evidence.caption!.isNotEmpty)
                                    Positioned(
                                      child: Container(
                                        color: Colors.black54,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          evidence.caption!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    ExpandableText(incident.description),

                    const SizedBox(height: 10),

                    Text(
                      'Category: ${incident.category?.categoryName ?? 'Unknown'}',
                    ),
                    Text('Location: ${incident.location ?? 'Unknown'}'),
                    Text('Urgency: ${incident.urgencyLevel}'),

                    const SizedBox(height: 20),

                    Text(
                      'Students Involved',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    ...incident.students.map((student) {
                      return ListTile(
                        title: Text('${student.firstName} ${student.lastName}'),
                        subtitle: Text(
                          '${student.involvementType}  • ${student.notes ?? ''}',
                        ),
                      );
                    }),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  incident.latestUpdate?.note ?? 'No updates yet.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Incident Details')),
        body: Center(child: Text(e.toString())),
      ),
      loading: () =>
          Scaffold(body: Center(child: CircularProgressIndicator.adaptive())),
    );
  }
}
