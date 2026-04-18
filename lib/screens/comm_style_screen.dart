import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import 'script_screen.dart';

class CommOption {
  final String id;
  final String label;
  final String detail;
  const CommOption({required this.id, required this.label, required this.detail});
}

const List<CommOption> kCommOptions = [
  CommOption(id: 'blank', label: 'I tend to go blank under pressure', detail: 'My mind empties when the doctor starts talking'),
  CommOption(id: 'openended', label: 'Open-ended questions are hard for me', detail: 'I do better with yes/no or specific questions'),
  CommOption(id: 'dismissed', label: 'I worry about being dismissed', detail: 'I want the script to sound firm and clear'),
  CommOption(id: 'overwhelm', label: 'I get overwhelmed easily', detail: 'Keep the script short and simple'),
  CommOption(id: 'masking', label: 'I mask and seem "fine" even when I\'m not', detail: 'I want language that conveys my real experience'),
];

class CommStyleScreen extends StatefulWidget {
  final List<String> checkedTopics;
  final String apptType;
  final String mainConcern;
  final String symptoms;
  final String duration;
  final String whatTried;

  const CommStyleScreen({
    super.key,
    required this.checkedTopics,
    required this.apptType,
    required this.mainConcern,
    required this.symptoms,
    required this.duration,
    required this.whatTried,
  });

  @override
  State<CommStyleScreen> createState() => _CommStyleScreenState();
}

class _CommStyleScreenState extends State<CommStyleScreen> {
  final Set<String> _selected = {};

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  void _generate() {
    final selectedLabels = kCommOptions
        .where((o) => _selected.contains(o.id))
        .map((o) => o.label)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScriptScreen(
          checkedTopics: widget.checkedTopics,
          apptType: widget.apptType,
          mainConcern: widget.mainConcern,
          symptoms: widget.symptoms,
          duration: widget.duration,
          whatTried: widget.whatTried,
          commStyles: selectedLabels,
        ),
      ),
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
                currentStep: 2,
                totalSteps: 4,
                label: 'How you communicate',
              ),
              const SizedBox(height: 20),

              const Text(
                'Which of these feel true for you?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Text(
                'Select all that apply. This shapes how your script is written.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 20),

              ...kCommOptions.map((opt) {
                final isSelected = _selected.contains(opt.id);
                return GestureDetector(
                  onTap: () => _toggle(opt.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 0.5,
                      ),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                          : Colors.grey.shade50,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) => _toggle(opt.id),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(opt.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 2),
                              Text(opt.detail, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _generate,
                child: const Text('Generate my script'),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Nothing is required — tap Generate to skip',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
