import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/providers/register_provider.dart';

class RegisterInfoPage extends ConsumerStatefulWidget {
  const RegisterInfoPage({super.key});

  @override
  ConsumerState<RegisterInfoPage> createState() =>
      _RegisterInfoPageState();
}

class _RegisterInfoPageState
    extends ConsumerState<RegisterInfoPage> {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final suffixController = TextEditingController();
  final occupationController = TextEditingController();
  final phoneController = TextEditingController();

  String gender = 'Male';

  DateTime? birthdate;

  Future<void> next() async {
    if (!formKey.currentState!.validate()) return;

    final notifier = ref.read(registerProvider.notifier);
    final state = ref.read(registerProvider);

    notifier.saveTempInfo(
      firstName: firstNameController.text.trim(),
      middleName: middleNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      suffix: suffixController.text.trim(),
      gender: gender,
      birthdate: birthdate!.toIso8601String().split('T').first,
      occupation: occupationController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      email: state.email!,
    );

    context.push(AppRoute.registerRelation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Required'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: middleNameController,
                decoration: const InputDecoration(
                  labelText: 'Middle Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Required'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: suffixController,
                decoration: const InputDecoration(
                  labelText: 'Suffix',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: gender,
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                ],
                onChanged: (value) {
                  gender = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                title: Text(
                  birthdate == null
                      ? 'Select Birthdate'
                      : birthdate!
                          .toIso8601String()
                          .split('T')
                          .first,
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    initialDate: DateTime(2000),
                  );

                  if (picked != null) {
                    setState(() {
                      birthdate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Required'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Required'
                        : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: next,
                  child: const Text('Proceed'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
