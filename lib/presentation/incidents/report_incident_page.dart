import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/models/incident/local_evidence.dart';
import 'package:hayagsync_app/models/selected_student.dart';
import 'package:hayagsync_app/models/student.dart';
import 'package:hayagsync_app/presentation/widgets/video_preview_dialog.dart';
import 'package:hayagsync_app/providers/category_provider.dart';
import 'package:hayagsync_app/providers/student_provider.dart';
import 'package:hayagsync_app/services/incident_service.dart';
import 'package:image_picker/image_picker.dart';

class ReportIncidentPage extends ConsumerStatefulWidget {
  const ReportIncidentPage({super.key});

  @override
  ConsumerState<ReportIncidentPage> createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends ConsumerState<ReportIncidentPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _searchController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  int? selectedCategoryId;

  List<SelectedStudent> selectedStudents = [];
  List<Student> filteredStudents = [];

  List<LocalEvidence> evidences = [];

  bool isSelected(String studentId) {
    return selectedStudents.any((e) => e.student.id == studentId);
  }

  void addStudent(Student student, {String role = 'Witness'}) {
    if (isSelected(student.id)) return;

    setState(() {
      selectedStudents.add(
        SelectedStudent(student: student, involvementType: role),
      );
    });
  }

  void removeStudent(String studentId) {
    setState(() {
      selectedStudents.removeWhere((e) => e.student.id == studentId);
    });
  }

  bool isMyStudent(String studentId, List<Student> myStudents) {
    return myStudents.any((s) => s.id == studentId);
  }

  Future<void> pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        evidences = [...evidences, LocalEvidence(file: File(file.path))];
      });
    }
  }

  Future<void> pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        evidences.add(LocalEvidence(file: File(file.path)));
      });
    }
  }

  void removeEvidence(int index) {
    setState(() {
      evidences.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final myStudentsAysnc = ref.watch(myStudentsProvider);
    final studentsAysnc = ref.watch(allStudentsProvider);
    final categoriesAysnc = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Report Bullying'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),

            const SizedBox(height: 10),

            categoriesAysnc.when(
              data: (categories) => DropdownButtonFormField<int>(
                initialValue: selectedCategoryId,
                hint: const Text('Select Category'),
                items: categories.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(c.categoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
              ),
              error: (_, __) => const Text('Unable to load categories'),
              loading: () => const CircularProgressIndicator.adaptive(),
            ),

            const SizedBox(height: 20),

            myStudentsAysnc.when(
              data: (students) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Victim(s)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    ...students.map((s) {
                      final selected = isSelected(s.id);

                      return CheckboxListTile.adaptive(
                        title: Text('${s.firstName} ${s.lastName}'),
                        value: selected,
                        onChanged: (value) {
                          if (value == true) {
                            addStudent(s, role: 'Victim');
                          } else {
                            removeStudent(s.id);
                          }
                        },
                      );
                    }),
                  ],
                );
              },
              error: (_, __) =>
                  const Text('Unable to load your related students'),
              loading: () => CircularProgressIndicator.adaptive(),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search student',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                final all = studentsAysnc.value ?? [];

                setState(() {
                  filteredStudents = all.where((s) {
                    final query = value.toLowerCase();

                    return s.firstName.toLowerCase().contains(query) ||
                        s.lastName.toLowerCase().contains(query) ||
                        s.studentNumber.contains(query);
                  }).toList();
                });
              },
            ),

            const SizedBox(height: 10),

            Column(
              children: filteredStudents.map((s) {
                return ListTile(
                  title: Text('${s.firstName} ${s.lastName}'),
                  subtitle: Text(s.studentNumber),
                  trailing: const Icon(Icons.add),
                  onTap: () => addStudent(s, role: 'Witness'),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            myStudentsAysnc.when(
              data: (myStudents) {
                return Column(
                  children: selectedStudents.map((item) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              '${item.student.firstName} ${item.student.lastName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            DropdownButton<String>(
                              value: item.involvementType,
                              items: ['Victim', 'Offender', 'Witness']
                                  .map(
                                    (role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(role),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == 'Victim' &&
                                    !isMyStudent(item.student.id, myStudents)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Only your child can be a victim',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  item.involvementType = value!;
                                });
                              },
                            ),

                            TextField(
                              decoration: InputDecoration(labelText: 'Notes'),
                              onChanged: (value) => item.notes = value,
                            ),

                            IconButton(
                              onPressed: () => removeStudent(item.student.id),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              error: (_, __) => const SizedBox(),
              loading: () => const SizedBox(),
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Evidences',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    IconButton(
                      onPressed: pickImage,
                      icon: const Icon(Icons.image_rounded),
                    ),
                    IconButton(
                      onPressed: pickVideo,
                      icon: const Icon(Icons.videocam_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (evidences.isNotEmpty)
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      itemCount: evidences.length,
                      itemBuilder: (context, index) {
                        final evidence = evidences[index];

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    if (evidence.isVideo) {
                                      return VideoPreviewDialog(
                                        file: evidence.file,
                                      );
                                    }

                                    return Dialog(
                                      child: Image.file(evidence.file),
                                    );
                                  },
                                );
                              },
                              child: Positioned.fill(
                                child: evidence.isVideo
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(color: Colors.black12),
                                          const Icon(
                                            Icons.play_circle_outline_rounded,
                                            size: 60,
                                          ),
                                        ],
                                      )
                                    : Image.file(
                                        evidence.file,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Caption',
                                  filled: true,
                                ),
                                onChanged: (value) => evidence.caption = value,
                              ),
                            ),

                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () => removeEvidence(index),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  final payloadStudents = selectedStudents
                      .map((e) => e.toJson())
                      .toList();

                  await IncidentService.reportIncident(
                    title: _titleController.text,
                    description: _descController.text,
                    categoryId: selectedCategoryId!,
                    students: payloadStudents,
                    evidences: evidences,
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incident Submitted')),
                  );

                  context.pop();
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
