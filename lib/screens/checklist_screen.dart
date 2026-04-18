import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import 'appointment_screen.dart';

// Pre-built topic chips the user can tap to select
const List<String> kDefaultTopics = [
  'Current medications',
  'Recent lab results',
  'Mental health check-in',
  'Side effects from treatment',
  'Referral request',
  'Diagnosis clarification',
  'Something feels off but I can\'t explain it',
  'Follow-up scheduling',
  'Allergies',
  'Sleep issues',
  'Pain levels',
  'Nutrition / diet concerns',
];

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final Set<String> _selected = {};
  final TextEditingController _customController = TextEditingController();
  final List<String> _customTopics = [];

  void _addCustomTopic() {
    final text = _customController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _customTopics.add(text);
      _selected.add(text);
      _customController.clear();
    });
  }

  void _toggleTopic(String topic) {
    setState(() {
      if (_selected.contains(topic)) {
        _selected.remove(topic);
      } else {
        _selected.add(topic);
      }
    });
  }

  void _goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentScreen(
          checkedTopics: _selected.toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTopics = [...kDefaultTopics, ..._customTopics];

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
                currentStep: 0,
                totalSteps: 4,
                label: 'Topics to cover',
              ),
              const SizedBox(height: 20),

              const Text(
                'What do you want to cover?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Text(
                'Tap everything you want to make sure comes up. You can also add your own.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Topic chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allTopics.map((topic) {
                  final isSelected = _selected.contains(topic);
                  return FilterChip(
                    label: Text(topic),
                    selected: isSelected,
                    onSelected: (_) => _toggleTopic(topic),
                    showCheckmark: true,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Colors.grey.shade700,
                    ),
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Add custom topic
              Text(
                'Add your own',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Ask about physical therapy',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      onSubmitted: (_) => _addCustomTopic(),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: _addCustomTopic,
                    icon: const Icon(Icons.add),
                    tooltip: 'Add topic',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Selected count
              if (_selected.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '${_selected.length} topic${_selected.length == 1 ? '' : 's'} selected',
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.primary),
                  ),
                ),

              // Next button — always enabled, checklist is optional
              ElevatedButton(
                onPressed: _goNext,
                child: const Text('Next'),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'You can skip this step — nothing is required',
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
