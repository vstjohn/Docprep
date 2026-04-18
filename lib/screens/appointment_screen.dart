import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import 'comm_style_screen.dart';

const List<String> kAppointmentTypes = [
  'General check-up',
  'New symptom / concern',
  'Follow-up appointment',
  'Mental health',
  'Specialist referral',
  'Medication review',
  'Other',
];

class AppointmentScreen extends StatefulWidget {
  final List<String> checkedTopics;

  const AppointmentScreen({super.key, required this.checkedTopics});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String? _apptType;
  final _concernController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _durationController = TextEditingController();
  final _triedController = TextEditingController();

  bool get _canProceed => _apptType != null && _concernController.text.trim().isNotEmpty;

  void _goNext() {
    if (!_canProceed) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommStyleScreen(
          checkedTopics: widget.checkedTopics,
          apptType: _apptType!,
          mainConcern: _concernController.text.trim(),
          symptoms: _symptomsController.text.trim(),
          duration: _durationController.text.trim(),
          whatTried: _triedController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _concernController.dispose();
    _symptomsController.dispose();
    _durationController.dispose();
    _triedController.dispose();
    super.dispose();
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
                currentStep: 1,
                totalSteps: 4,
                label: 'About your appointment',
              ),
              const SizedBox(height: 20),

              const Text(
                'About your appointment',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // Appointment type dropdown
              _fieldLabel('Type of appointment'),
              DropdownButtonFormField<String>(
                value: _apptType,
                hint: const Text('Select one...', style: TextStyle(fontSize: 14)),
                decoration: const InputDecoration(),
                items: kAppointmentTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 14))))
                    .toList(),
                onChanged: (val) => setState(() => _apptType = val),
              ),
              const SizedBox(height: 16),

              // Main concern
              _fieldLabel('Main concern'),
              _fieldHint('The one thing you most need the doctor to understand today.'),
              TextField(
                controller: _concernController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. I\'ve been having recurring headaches for 3 weeks',
                  hintStyle: TextStyle(fontSize: 14),
                ),
                onChanged: (_) => setState(() {}), // refresh Next button state
              ),
              const SizedBox(height: 16),

              // Symptoms
              _fieldLabel('Symptoms', optional: true),
              TextField(
                controller: _symptomsController,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. headache, nausea, light sensitivity',
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Duration
              _fieldLabel('How long has this been going on?', optional: true),
              TextField(
                controller: _durationController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. 3 weeks, on and off for months',
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),

              // What tried
              _fieldLabel('What have you already tried?', optional: true),
              TextField(
                controller: _triedController,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. ibuprofen, rest — nothing helped',
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _canProceed ? _goNext : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text, {bool optional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          if (optional) ...[
            const SizedBox(width: 6),
            Text('(optional)', style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w400)),
          ]
        ],
      ),
    );
  }

  Widget _fieldHint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
    );
  }
}
