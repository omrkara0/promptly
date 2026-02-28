import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  static Future<void> launchChatGPT(String prompt) async {
    // Kopyalama işlemi: Ne olur ne olmaz panoya alalım
    await Clipboard.setData(ClipboardData(text: prompt));

    // ChatGPT native URL parametresini desteklemiyor, kopyala + yapıştır şeklinde çalışır.
    final url = Uri.parse('https://chatgpt.com/');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  static Future<void> launchGemini(String prompt) async {
    // Kopyalama işlemi
    await Clipboard.setData(ClipboardData(text: prompt));

    // URL Parametresi ile pre-fill
    final encodedPrompt = Uri.encodeComponent(prompt);
    final url = Uri.parse(
      'https://gemini.google.com/app?prompt=$encodedPrompt',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      // Fallback
      final fallbackUrl = Uri.parse('https://gemini.google.com/');
      await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
    }
  }
}
