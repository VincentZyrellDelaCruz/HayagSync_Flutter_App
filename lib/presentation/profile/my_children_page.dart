import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/providers/student_provider.dart';

class MyChildrenPage extends ConsumerWidget {
  const MyChildrenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(myStudentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('My Students')),
      body: Column(
        children: [
          Expanded(
            child: studentsAsync.when(
              data: (students) {
                if (students.isEmpty) {
                  return const Center(
                    child: Text(
                      'You don\'t have any related students who currently enrolled',
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.person_2_rounded),
                          title: Text(
                            '${student.firstName} ${student.lastName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '(${student.studentNumber})',
                                style: TextStyle(fontSize: 16),
                              ),

                              Text(
                                'Relationship: ${student.relationship}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  elevation: 2,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text('Add More'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
