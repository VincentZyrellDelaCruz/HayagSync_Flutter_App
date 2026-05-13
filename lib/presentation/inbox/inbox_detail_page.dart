import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hayagsync_app/providers/inbox_provider.dart';

class InboxDetailPage extends ConsumerWidget {
  const InboxDetailPage({
    super.key,
    required this.inboxId,
  });

  final int inboxId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxDetailProvider(inboxId));

    return inboxAsync.when(
      data: (inbox) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Inbox Detail'),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inbox.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        '${inbox.sender?.firstName ?? ''} ${inbox.sender?.lastName ?? ''}',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.access_time_rounded),

                    const SizedBox(width: 8),

                    Text(
                      DateFormat.yMMMd().add_jm().format(inbox.createdAt),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: Text(
                    inbox.message.isEmpty
                        ? 'No message content'
                        : inbox.message,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },

      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Inbox Detail')),
        body: Center(
          child: Text(e.toString()),
        ),
      ),

      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}