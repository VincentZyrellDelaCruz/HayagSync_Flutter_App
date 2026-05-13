import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/providers/register_provider.dart';
import 'package:image_picker/image_picker.dart';

class RegisterProofsPage extends ConsumerStatefulWidget {
  const RegisterProofsPage({super.key});

  @override
  ConsumerState<RegisterProofsPage> createState() =>
      _RegisterProofsPageState();
}

class _RegisterProofsPageState
    extends ConsumerState<RegisterProofsPage> {
  File? selfie;
  File? validId;
  File? studentId;

  final picker = ImagePicker();

  Future<void> pickImage(Function(File file) setter) async {
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      setter(File(image.path));
      setState(() {});
    }
  }

  Widget tile({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.grey.shade200,
      title: Text(title),
      subtitle: Text(
        file == null ? 'Tap to capture' : 'Image captured',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> submit() async {
    if (selfie == null || validId == null || studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture all required images.'),
        ),
      );
      return;
    }

    final notifier = ref.read(registerProvider.notifier);

    // SAVE IMAGES TO STATE
    notifier.setProofImages(
      selfie: selfie!,
      validId: validId!,
      studentId: studentId!,
    );

    try {
      final registerState = ref.read(registerProvider);

      final temp = registerState.tempInfo;

      if (temp == null) {
        throw Exception('Registration information missing.');
      }

      await notifier.submitRegistration(
        studentId: registerState.registration?.studentId ?? '',
        relationship:
            registerState.registration?.relationship ?? '',
      );

      if (mounted) {
        context.go(AppRoute.registerSuccess);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            tile(
              title: 'Take a selfie',
              file: selfie,
              onTap: () => pickImage((file) => selfie = file),
            ),
            const SizedBox(height: 16),
            tile(
              title: 'Take valid ID',
              file: validId,
              onTap: () => pickImage((file) => validId = file),
            ),
            const SizedBox(height: 16),
            tile(
              title: 'Take student ID',
              file: studentId,
              onTap: () => pickImage((file) => studentId = file),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                child: const Text('Submit Registration'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
