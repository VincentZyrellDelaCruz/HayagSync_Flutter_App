import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/providers/register_provider.dart';

class RegisterOtpPage extends ConsumerStatefulWidget {
  const RegisterOtpPage({super.key});

  @override
  ConsumerState<RegisterOtpPage> createState() =>
      _RegisterOtpPageState();
}

class _RegisterOtpPageState
    extends ConsumerState<RegisterOtpPage> {
  final otpController = TextEditingController();

  Future<void> verify() async {
    try {
      await ref
          .read(registerProvider.notifier)
          .verifyOtp(otpController.text.trim());

      if (mounted) {
        context.push(AppRoute.registerInfo);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(state.email ?? ''),
            const SizedBox(height: 24),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: verify,
                child: const Text('Verify OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
