import 'package:flutter/material.dart';

class LocalizationProvider extends ChangeNotifier {
  bool _isEnglish = false;

  bool get isEnglish => _isEnglish;

  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    notifyListeners();
  }

  // --- Entries ---
  String get pleaseEnterPrompt =>
      _isEnglish ? 'Please enter a prompt.' : 'Lütfen bir prompt girin.';
  String get error => _isEnglish ? 'Error: ' : 'Hata: ';
  String get copiedToClipboard =>
      _isEnglish ? 'Copied to clipboard!' : 'Panoya kopyalandı!';

  String get title => 'Promptly'; // Same
  String get heroTitle =>
      _isEnglish ? 'Craft the Perfect Prompt' : 'Mükemmel Promptu Oluşturun';
  String get heroSubtitle => _isEnglish
      ? 'Transform your raw ideas into high-performance instructions for ChatGPT, Gemini, and Claude.'
      : 'Ham fikirlerinizi ChatGPT, Gemini ve Claude için yüksek performanslı talimatlara dönüştürün.';

  String get rawInputLabel => _isEnglish ? 'YOUR RAW INPUT' : 'HAM GİRDİNİZ';
  String get inputHint => _isEnglish
      ? "Type what you want to achieve...\ne.g. 'A script that scrapes product prices from Amazon...'"
      : "Neyi başarmak istediğinizi yazın...\nörn. 'Amazon'dan ürün fiyatlarını çeken bir betik...'";
  String get btnClear => _isEnglish ? 'Clear' : 'Temizle';
  String get btnPaste => _isEnglish ? 'Paste' : 'Yapıştır';
  String get btnOptimize =>
      _isEnglish ? 'Optimize Prompt' : 'Promptu Optimize Et';
  String get tokenMessage => _isEnglish
      ? '1 token used per optimization.'
      : 'Optimizasyon başına 1 token kullanılır.';

  String get orgPrompt => _isEnglish ? 'Original Prompt' : 'Orijinal İstem';
  String get optimizedPrompt =>
      _isEnglish ? 'Optimized Prompt' : 'Optimize Edilmiş Prompt';
  String get llmReady => _isEnglish ? 'LLM Ready' : 'LLM\'e Hazır';
  String get copy => _isEnglish ? 'Copy' : 'Kopyala';
  String get sendToChatGPT =>
      _isEnglish ? 'Send to ChatGPT' : 'ChatGPT\'ye Gönder';
  String get sendToGemini =>
      _isEnglish ? 'Send to Gemini' : 'Gemini\'ye Gönder';
  String get opensInNewTab =>
      _isEnglish ? 'Opens native app' : 'Uygulamayı açar';
  String get shareText => _isEnglish ? 'Share Text' : 'Metni Paylaş';

  // --- Tones ---
  String get toneLabel => _isEnglish ? 'Tone' : 'Ton';
  String get toneDetailed => _isEnglish ? 'Detailed' : 'Detaylı';
  String get toneConcise => _isEnglish ? 'Concise' : 'Kısa ve Öz';
  String get toneCreative => _isEnglish ? 'Creative' : 'Yaratıcı';

  // --- History ---
  String get history => _isEnglish ? 'History' : 'Geçmiş';
  String get noHistory => _isEnglish ? 'No history yet' : 'Henüz geçmiş yok';
  String get itemDeleted => _isEnglish ? 'Item deleted' : 'Öğe silindi';
  String get historyDeleted =>
      _isEnglish ? 'History cleared' : 'Geçmiş temizlendi';
  String get historyDeleteConfirm =>
      _isEnglish ? 'Clear all history?' : 'Tüm geçmiş silinsin mi?';
  String get cancel => _isEnglish ? 'Cancel' : 'İptal';
  String get clear => _isEnglish ? 'Clear' : 'Sil';
}
