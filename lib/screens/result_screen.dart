import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../utils/app_launcher.dart';
import '../providers/localization_provider.dart';

class ResultScreen extends StatefulWidget {
  final String originalPrompt;
  final String enhancedPrompt;

  const ResultScreen({
    super.key,
    required this.originalPrompt,
    required this.enhancedPrompt,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isOriginalPromptExpanded = false;

  void _copyToClipboard() {
    final loc = Provider.of<LocalizationProvider>(context, listen: false);
    if (widget.enhancedPrompt.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.enhancedPrompt));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.copiedToClipboard),
          backgroundColor: AppColors.chatgptGreen,
        ),
      );
    }
  }

  void _sharePrompt() {
    if (widget.enhancedPrompt.isNotEmpty) {
      Share.share(widget.enhancedPrompt);
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
              // Original Prompt Collapsible
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  border: Border.all(color: AppColors.surfaceBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: _isOriginalPromptExpanded,
                    onExpansionChanged: (val) {
                      setState(() => _isOriginalPromptExpanded = val);
                    },
                    leading: const Icon(
                      Icons.history_edu,
                      color: Colors.white54,
                    ),
                    title: Text(
                      loc.orgPrompt,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    iconColor: Colors.white54,
                    collapsedIconColor: Colors.white54,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.surfaceBorder),
                          ),
                        ),
                        child: Text(
                          '"${widget.originalPrompt}"',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white54,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.optimizedPrompt,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      border: Border.all(color: Colors.green.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.greenAccent.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          loc.llmReady,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Result Markdown/Text Area
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  border: Border.all(color: AppColors.surfaceBorder),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Fake macOS Window Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        border: const Border(
                          bottom: BorderSide(color: AppColors.surfaceBorder),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'PROMPT_V2.md',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: _copyToClipboard,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.content_copy,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    loc.copy,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actual Output
                    Container(
                      padding: const EdgeInsets.all(20),
                      constraints: const BoxConstraints(minHeight: 150),
                      child: SelectableText(
                        widget.enhancedPrompt,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // App Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildAppSendButton(
                      title: loc.sendToChatGPT,
                      subtitle: loc.opensInNewTab,
                      icon: Icons.bolt,
                      color: AppColors.chatgptGreen,
                      onTap: () =>
                          AppLauncher.launchChatGPT(widget.enhancedPrompt),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildAppSendButton(
                      title: loc.sendToGemini,
                      subtitle: loc.opensInNewTab,
                      icon: Icons.auto_awesome_mosaic,
                      color: AppColors.geminiBlue,
                      onTap: () =>
                          AppLauncher.launchGemini(widget.enhancedPrompt),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // More Options
              TextButton.icon(
                onPressed: _sharePrompt,
                icon: const Icon(Icons.share, color: Colors.white54),
                label: Text(
                  loc.shareText,
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_fix_high, color: AppColors.primary),
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
        ),
      ),
    );
  }

  Widget _buildAppSendButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
