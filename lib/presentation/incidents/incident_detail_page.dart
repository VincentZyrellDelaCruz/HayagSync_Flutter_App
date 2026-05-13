import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/incident/incident_evidence.dart';
import 'package:hayagsync_app/presentation/widgets/expandable_text.dart';
import 'package:hayagsync_app/presentation/widgets/video_preview_dialog.dart';
import 'package:hayagsync_app/providers/incident_details_provider.dart';
import 'package:intl/intl.dart';

class IncidentDetailPage extends ConsumerStatefulWidget {
  const IncidentDetailPage({
    super.key,
    required this.incidentId,
  });

  final String incidentId;

  @override
  ConsumerState<IncidentDetailPage> createState() =>
      _IncidentDetailPageState();
}

class _IncidentDetailPageState
    extends ConsumerState<IncidentDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  void openPreview(IncidentEvidence evidence) {
    showDialog(
      context: context,
      builder: (_) {
        if (evidence.isVideo) {
          return VideoPreviewDialog(
            url: evidence.fullUrl,
          );
        }

        return Dialog(
          child: InteractiveViewer(
            child: Image.network(
              evidence.fullUrl,
            ),
          ),
        );
      },
    );
  }

  Widget buildInfoTab(dynamic incident) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            incident.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          if (incident.evidences.isNotEmpty)
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: incident.evidences.length,
                itemBuilder: (context, index) {
                  final evidence = incident.evidences[index];

                  return GestureDetector(
                    onTap: () => openPreview(evidence),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: evidence.isVideo
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  color: Colors.black12,
                                ),
                                const Icon(
                                  Icons.play_circle_fill,
                                  size: 70,
                                ),
                              ],
                            )
                          : Image.network(
                              evidence.fullUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Incident Code',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(incident.id.substring(0, 8)),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Date Reported',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat.yMMMd().format(
                              incident.createdAt,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Urgency',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(incident.urgencyLevel),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ExpandableText(
              incident.description,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Involved Students',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 14),

          ...incident.students.map<Widget>((student) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${student.firstName} ${student.lastName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          student.studentNumber,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      student.involvementType ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildUpdatesTab(dynamic incident) {
    if (incident.latestUpdate == null) {
      return const Center(
        child: Text('No updates yet.'),
      );
    }

    final update = incident.latestUpdate!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              update.incidentStatus?.statusName ??
                  'Status Update',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            Text(update.note),
          ],
        ),
      ),
    );
  }

  Widget buildGuidanceTab(dynamic incident) {
    final guidance = incident.aiParentingSupport;

    if (guidance == null) {
      return const Center(
        child: Text(
          'No parenting guidance available.',
        ),
      );
    }

    final formatted = guidance.generatedText
        .replaceAll('###', '')
        .replaceAll('***', '');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            guidance.tipsTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              formatted,
              style: const TextStyle(
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidentAsync = ref.watch(
      incidentDetailProvider(widget.incidentId),
    );

    return incidentAsync.when(
      data: (incident) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Incident Details'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Info'),
                Tab(text: 'Updates'),
                Tab(text: 'Parenting Tips'),
              ],
            ),
          ),

          body: TabBarView(
            controller: _tabController,
            children: [
              buildInfoTab(incident),
              buildUpdatesTab(incident),
              buildGuidanceTab(incident),
            ],
          ),
        );
      },

      error: (e, _) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(e.toString()),
          ),
        );
      },

      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}