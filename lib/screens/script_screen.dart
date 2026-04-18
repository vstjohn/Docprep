import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/gemma_service.dart';
import '../widgets/step_indicator.dart';
import '../widgets/script_card.dart';
import 'checklist_screen.dart';

class ScriptScreen extends StatefulWidget {
  final List<String> checkedTopics;
  final String apptType;
  final String mainConcern;
  final String symptoms;
  final String duration;
  final String whatTried;
  final List<String> commStyles;

  const ScriptScreen({
    super.key,
    required this.checkedTopics,
    required this.apptType,
    required this.mainConcern,
    required this.symptoms,
    required this.duration,
    required this.whatTried,
    required this.commStyles,
  });

  @override
  State<ScriptScreen> createState() => _ScriptScreenState();
}

class _ScriptScreenState extends State<ScriptScreen> {
  Map<String, String>? _script;
  String? _error;
  bool _loading = true;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate({String extra = ''}) async {
    setState(() { _loading = true; _error = null; _script = null; });

    try {
      final result = await GemmaService.generateScript(
        apptType: widget.apptType,
        mainConcern: widget.mainConcern,
        checkedTopics: widget.checkedTopics,
        commStyles: widget.commStyles,
        symptoms: widget.symptoms,
        duration: widget.duration,
        whatTried: widget.whatTried,
        extraInstruction: extra,
      );
      setState(() { _script = result; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _copyAll() {
    if (_script == null) return;
    final text = [
      'Opening statement:\n${_script!['opening']}',
      'Questions to ask:\n${_script!['questions']}',
      'If the doctor pivots:\n${_script!['pivot']}',
    ].join('\n\n');
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  void _startOver() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ChecklistScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DocPrep'),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepIndicator(
                currentStep: 3,
                totalSteps: 4,
                label: 'Your script',
              ),
              const SizedBox(height: 20),

              // Loading state
              if (_loading) ...[
                const SizedBox(height: 60),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Writing your script...',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
              ],

              // Error state
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Something went wrong: $_error',
                    style: TextStyle(fontSize: 13, color: Colors.red.shade700),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _generate,
                  child: const Text('Try again'),
                ),
              ],

              // Script output
              if (_script != null) ...[
                const Text(
                  'Your script',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  'Read this aloud, or hand your phone to your doctor.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                ScriptCard(sectionLabel: 'Opening statement', content: _script!['opening'] ?? ''),
                ScriptCard(sectionLabel: 'Questions to ask', content: _script!['questions'] ?? ''),
                ScriptCard(sectionLabel: 'If the doctor pivots', content: _script!['pivot'] ?? ''),

                const SizedBox(height: 8),

                // Copy button
                ElevatedButton.icon(
                  onPressed: _copyAll,
                  icon: Icon(_copied ? Icons.check : Icons.copy, size: 18),
                  label: Text(_copied ? 'Copied!' : 'Copy full script'),
                ),
                const SizedBox(height: 10),

                // Tone chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip('Make it shorter', () => _generate(extra: 'make it shorter and simpler')),
                    _chip('More assertive', () => _generate(extra: 'make the tone more assertive and direct')),
                    _chip('Softer tone', () => _generate(extra: 'make the tone gentler and softer')),
                    _chip('Regenerate', _generate),
                  ],
                ),
                const SizedBox(height: 24),

                // Start over
                OutlinedButton(
                  onPressed: _startOver,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Start over'),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: Colors.grey.shade300),
    );
  }
}
