/// Shared data models for the Notes module.
/// FRONTEND ONLY — every field is meant to be populated from your
/// backend/local database. Nothing here is hardcoded data, just the
/// shape of the data.
library;

import 'package:flutter/material.dart';

enum NoteType { text, voice, drawing, checklist }

class NoteCategory {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  NoteCategory({required this.id, required this.name, required this.color, required this.icon});
}

class ChecklistItem {
  final String id;
  final String text;
  final bool isDone;

  ChecklistItem({required this.id, required this.text, this.isDone = false});

  ChecklistItem copyWith({String? text, bool? isDone}) =>
      ChecklistItem(id: id, text: text ?? this.text, isDone: isDone ?? this.isDone);
}

class NoteAttachment {
  final String id;
  final String fileName;
  final String fileExtension;
  final String? url;
  final int fileSizeBytes;

  NoteAttachment({
    required this.id,
    required this.fileName,
    required this.fileExtension,
    this.url,
    this.fileSizeBytes = 0,
  });

  String get formattedSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class Note {
  final String id;
  final String title;
  final String content;
  final NoteType type;
  final NoteCategory? category;
  final DateTime updatedAt;
  final bool isPinned;
  final List<ChecklistItem> checklistItems;
  final List<NoteAttachment> attachments;
  final Duration? voiceDuration;
  final String? drawingImageUrl;

  Note({
    required this.id,
    required this.title,
    this.content = '',
    this.type = NoteType.text,
    this.category,
    DateTime? updatedAt,
    this.isPinned = false,
    this.checklistItems = const [],
    this.attachments = const [],
    this.voiceDuration,
    this.drawingImageUrl,
  }) : updatedAt = updatedAt ?? DateTime.now();
}