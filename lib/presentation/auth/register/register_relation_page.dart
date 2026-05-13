import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/models/pending_registration.dart';
import 'package:hayagsync_app/providers/register_provider.dart';

class RegisterRelationPage extends ConsumerStatefulWidget {
  const RegisterRelationPage({super.key});

  @override
  ConsumerState<RegisterRelationPage> createState() =>
      _RegisterRelationPageState();
}

class _RegisterRelationPageState
    extends ConsumerState<RegisterRelationPage> {
  final studentController = TextEditingController();

  String relationship = 'Father';

  Future<void> proceed() async {
    final notifier = ref.read(registerProvider.notifier);
    final temp = ref.read(registerProvider).tempInfo;

    final registration = PendingRegistration(
      email: temp!['email'],
      firstName: temp['first_name'],
      middleName: temp['middle_name'],
      lastName: temp['last_name'],
      suffix: temp['suffix'],
      gender: temp['gender'],
      birthdate: temp['birthdate'],
      occupation: temp['occupation'],
      phoneNumber: temp['phone_number'],
      studentId: studentController.text.trim(),
      relationship: relationship,
    );

    notifier.saveRegistrationData(registration);

    context.push(AppRoute.registerProofs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: studentController,
              decoration: const InputDecoration(
                labelText: 'Student Number / ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: relationship,
              items: const [
                DropdownMenuItem(
                  value: 'Father',
                  child: Text('Father'),
                ),
                DropdownMenuItem(
                  value: 'Mother',
                  child: Text('Mother'),
                ),
                DropdownMenuItem(
                  value: 'Guardian',
                  child: Text('Guardian'),
                ),
              ],
              onChanged: (value) {
                relationship = value!;
              },
              decoration: const InputDecoration(
                labelText: 'Relationship',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: proceed,
                child: const Text('Proceed'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
