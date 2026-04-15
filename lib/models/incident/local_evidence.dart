import 'dart:io';

class LocalEvidence {
  final File file;
  String? caption;

  LocalEvidence({required this.file, this.caption});

  bool get isVideo {
    final path = file.path.toLowerCase();
    return path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.avi');
  }
}
