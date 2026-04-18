import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GemmaService {
  // TODO: replace with your Google AI Studio key from aistudio.google.com
  static const _apiKey = String.fromEnvironment('GEMMA_API_KEY');

  static final _model = GenerativeModel(
    model: 'gemma-2-0-flash-lite',
    apiKey: _apiKey,
  );

  /// Generates a 3-part doctor visit script.
  /// Returns a map with keys: 'opening', 'questions', 'pivot'
  /// Throws an exception if the API call fails.
  static Future<Map<String, String>> generateScript({
    required String apptType,
    required String mainConcern,
    required List<String> checkedTopics,
    required List<String> commStyles,
    String symptoms = '',
    String duration = '',
    String whatTried = '',
    String extraInstruction = '',
  }) async {
    final topicsText = checkedTopics.isEmpty ? 'none selected' : checkedTopics.join(', ');
    final commText = commStyles.isEmpty ? 'none specified' : commStyles.join(', ');

    final prompt = '''
You are helping a neurodivergent person prepare for a doctor appointment.
Return ONLY valid JSON with exactly these keys: "opening", "questions", "pivot".
No markdown, no backticks, no extra text — just the raw JSON object.

Appointment type: $apptType
Main concern: $mainConcern
Additional topics to cover: $topicsText
Symptoms: ${symptoms.isEmpty ? 'not specified' : symptoms}
Duration: ${duration.isEmpty ? 'not specified' : duration}
What they have tried: ${whatTried.isEmpty ? 'nothing specified' : whatTried}
Communication needs: $commText
${extraInstruction.isNotEmpty ? 'Extra instruction: $extraInstruction' : ''}

Rules:
- "opening": 2-4 sentences the person can read aloud at the start. First person, clear, non-apologetic. Include the main concern and any key additional topics.
- "questions": 3-5 numbered questions to ask the doctor. Short and specific. Cover the checked topics.
- "pivot": 2-3 sentences to say if the doctor changes subject before addressing the main concern.
- Plain direct language. No jargon. No filler phrases.
- Reflect communication needs in tone — e.g. if they go blank under pressure, make the opening very short and simple.
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final raw = response.text ?? '';

    // Strip markdown code fences if model adds them anyway
    final cleaned = raw
        .replaceAll(RegExp(r'```json'), '')
        .replaceAll(RegExp(r'```'), '')
        .trim();

    try {
      final parsed = jsonDecode(cleaned) as Map<String, dynamic>;
      return {
        'opening': parsed['opening']?.toString() ?? '',
        'questions': parsed['questions']?.toString() ?? '',
        'pivot': parsed['pivot']?.toString() ?? '',
      };
    } catch (e) {
      throw Exception('Could not parse the script. Try generating again.');
    }
  }
}
