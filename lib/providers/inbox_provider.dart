import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/inbox.dart';
import 'package:hayagsync_app/providers/auth_provider.dart';
import 'package:hayagsync_app/services/inbox_service.dart';

final inboxProvider =
    AsyncNotifierProvider<InboxNotifier, List<Inbox>>(
      InboxNotifier.new,
    );

class InboxNotifier extends AsyncNotifier<List<Inbox>> {
  String? _lastUserId;

  @override
  Future<List<Inbox>> build() async {
    final auth = ref.watch(authProvider);

    final currentUserId = auth.user?.id;

    // CLEAR OLD USER DATA
    if (_lastUserId != null && _lastUserId != currentUserId) {
      state = const AsyncData([]);
    }

    _lastUserId = currentUserId;

    if (currentUserId == null) {
      return [];
    }

    return InboxService.getInboxList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return InboxService.getInboxList();
    });
  }

  void clear() {
    state = const AsyncData([]);
  }
}

final inboxDetailProvider =
    FutureProvider.family<Inbox, int>((ref, id) async {
      return InboxService.getInboxDetail(id);
    });