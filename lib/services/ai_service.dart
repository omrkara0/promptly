import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  late final GenerativeModel _model;

  AiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key not found or empty in .env file.');
    }
    _model = GenerativeModel(model: 'gemini-3-flash-preview', apiKey: apiKey);
  }

  Future<String> enhancePrompt(
    String originalPrompt, {
    String tone = 'Detailed',
  }) async {
    final systemPrompt =
        '''
Sen uzman bir prompt mühendisisin (Prompt Engineer).
Kullanıcının sana verdiği metni alıp, bir Büyük Dil Modeli'nin (LLM) en üst düzeyde anlayabileceği, 
bağlamı net, rolü belirgin ve beklentisi açık bir hale getireceksin.

ÖNEMLİ KURALLAR:
1. Kullanıcının girdiği dil ne olursa olsun, OLUŞTURDUĞUN YENİ PROMPT KESİNLİKLE İNGİLİZCE OLMALIDIR. 
2. Sadece ama sadece geliştirilmiş prompt metnini ver, başka hiçbir açıklama yapma.
3. İstenen ton ve stil: $tone
''';

    final prompt = '$systemPrompt\n\nKullanıcı Metni:\n$originalPrompt';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);

      return response.text?.trim() ?? 'Prompt geliştirilemedi.';
    } catch (e) {
      return 'Bir hata oluştu: $e';
    }
  }
}
