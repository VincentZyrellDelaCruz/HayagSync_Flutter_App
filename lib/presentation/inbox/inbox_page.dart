import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/providers/inbox_provider.dart';

class InboxListPage extends ConsumerWidget {
  const InboxListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),

      body: inboxAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('No inbox messages'),
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              await ref.read(inboxProvider.notifier).refresh();
            },
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final inbox = items[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      inbox.sender?.firstName.substring(0, 1) ?? '?',
                    ),
                  ),

                  title: Text(
                    inbox.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  subtitle: Text(
                    '${inbox.sender?.firstName ?? ''} ${inbox.sender?.lastName ?? ''}',
                  ),

                  trailing: inbox.isRead
                      ? null
                      : const Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.red,
                        ),

                  onTap: () {
                    context.push('/inbox/${inbox.id}');
                  },
                );
              },
            ),
          );
        },

        error: (e, _) => Center(
          child: Text(e.toString()),
        ),

        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}