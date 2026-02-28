import 'package:hive/hive.dart';

part 'history_item.g.dart';

@HiveType(typeId: 0)
class HistoryItem extends HiveObject {
  @HiveField(0)
  final String originalPrompt;

  @HiveField(1)
  final String enhancedPrompt;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String tone;

  HistoryItem({
    required this.originalPrompt,
    required this.enhancedPrompt,
    required this.date,
    required this.tone,
  });
}
