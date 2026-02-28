import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:intl/intl.dart';

import '../models/history_item.dart';
import '../services/ai_service.dart';
import '../theme/app_colors.dart';
import '../providers/localization_provider.dart';
import 'result_screen.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TextEditingController _inputController = TextEditingController();
  bool _isLoading = false;
  String _selectedTone = 'Detailed';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _enhancePrompt() async {
    final loc = Provider.of<LocalizationProvider>(context, listen: false);
    final originalText = _inputController.text.trim();
    if (originalText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseEnterPrompt),
          backgroundColor: AppColors.surfaceBorder,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    FocusScope.of(context).unfocus();

    try {
      final aiService = Provider.of<AiService>(context, listen: false);
      final enhancedText = await aiService.enhancePrompt(
        originalText,
        tone: _selectedTone,
      );

      if (!mounted) return;

      // Save to Hive history
      final box = Hive.box<HistoryItem>('historyBox');
      final newHistoryItem = HistoryItem(
        originalPrompt: originalText,
        enhancedPrompt: enhancedText,
        date: DateTime.now(),
        tone: _selectedTone,
      );
      await box.add(newHistoryItem);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            originalPrompt: originalText,
            enhancedPrompt: enhancedText,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.error}$e'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      appBar: _buildAppBar(loc),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Hero Text
              Text(
                loc.heroTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                loc.heroSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 32),

              // Tone Selector
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tune,
                        size: 20,
                        color: AppColors.primary.withOpacity(0.8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.toneLabel.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildToneChip(
                          'Detailed',
                          loc.toneDetailed,
                          Icons.article_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildToneChip(
                          'Concise',
                          loc.toneConcise,
                          Icons.short_text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildToneChip(
                          'Creative',
                          loc.toneCreative,
                          Icons.lightbulb_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Input Area
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.edit_note,
                                size: 20,
                                color: AppColors.primary.withOpacity(0.8),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                loc.rawInputLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                  color: AppColors.primary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${_inputController.text.length}/2000',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _inputController,
                        maxLines: 8,
                        minLines: 6,
                        onChanged: (val) => setState(() {}),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: loc.inputHint,
                          hintStyle: const TextStyle(
                            color: Colors.white38,
                            fontWeight: FontWeight.w300,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // Actions (Paste, Clear)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              _inputController.clear();
                              setState(() {});
                            },
                            tooltip: loc.btnClear,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.content_paste,
                              size: 20,
                              color: Colors.white54,
                            ),
                            onPressed: () async {
                              final data = await Clipboard.getData(
                                'text/plain',
                              );
                              if (data != null && data.text != null) {
                                _inputController.text += data.text!;
                                setState(() {});
                              }
                            },
                            tooltip: loc.btnPaste,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Enhance Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _enhancePrompt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: AppColors.primary.withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.auto_awesome),
                            const SizedBox(width: 12),
                            Text(
                              loc.btnOptimize,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                loc.tokenMessage,
                style: const TextStyle(fontSize: 12, color: Colors.white38),
              ),
              const SizedBox(height: 48),

              // History Section Inline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 20,
                        color: AppColors.primary.withOpacity(0.8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.history.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: Hive.box<HistoryItem>(
                      'historyBox',
                    ).listenable(),
                    builder: (context, Box<HistoryItem> box, _) {
                      if (box.isEmpty) return const SizedBox.shrink();
                      return InkWell(
                        onTap: () => _confirmClearHistory(context, box, loc),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            loc.clear,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: Hive.box<HistoryItem>(
                  'historyBox',
                ).listenable(),
                builder: (context, Box<HistoryItem> box, _) {
                  if (box.values.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.surfaceBorder.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 32, color: Colors.white24),
                          const SizedBox(height: 12),
                          Text(
                            loc.noHistory,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final historyList = box.values.toList().reversed.toList();

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historyList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = historyList[index];
                      // To get the actual key from the reversed list:
                      final itemKey = box.keyAt(box.length - 1 - index);
                      final dateString = DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(item.date);

                      return Dismissible(
                        key: ValueKey(itemKey),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          box.delete(itemKey);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(loc.itemDeleted),
                              backgroundColor: AppColors.surfaceBorder,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: _buildHistoryCard(context, item, dateString),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(LocalizationProvider loc) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgDark,
          border: Border(
            bottom: BorderSide(color: AppColors.surfaceBorder, width: 1),
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                loc.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            TextButton.icon(
              icon: const Icon(
                Icons.translate,
                color: Colors.white54,
                size: 20,
              ),
              label: Text(
                loc.isEnglish ? 'TR' : 'EN',
                style: const TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Provider.of<LocalizationProvider>(
                  context,
                  listen: false,
                ).toggleLanguage();
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildToneChip(String value, String label, IconData icon) {
    final isSelected = _selectedTone == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTone = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surfaceBorder.withOpacity(0.3),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : Colors.white54,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.white70,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    HistoryItem item,
    String formattedDate,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              originalPrompt: item.originalPrompt,
              enhancedPrompt: item.enhancedPrompt,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: Border.all(color: AppColors.surfaceBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getIconForTone(item.tone),
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.tone.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 11, color: Colors.white38),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.originalPrompt,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTone(String tone) {
    switch (tone) {
      case 'Detailed':
        return Icons.article_outlined;
      case 'Concise':
        return Icons.short_text;
      case 'Creative':
        return Icons.lightbulb_outline;
      default:
        return Icons.tune;
    }
  }

  void _confirmClearHistory(
    BuildContext context,
    Box<HistoryItem> box,
    LocalizationProvider loc,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.surfaceBorder),
          ),
          title: Text(
            loc.historyDeleteConfirm,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                loc.cancel,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                box.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.historyDeleted),
                    backgroundColor: AppColors.surfaceBorder,
                  ),
                );
              },
              child: Text(
                loc.clear,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
