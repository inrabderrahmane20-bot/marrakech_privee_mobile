import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../services/outreach.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

enum OutreachMethod { whatsapp, email, instagram }

class RequestPage extends StatefulWidget {
  final Activity? activity;
  final List<Activity>? bucketItems;
  const RequestPage({this.activity, this.bucketItems, super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _people = 1;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCountryCode = '+212';
  String _selectedCountryFlag = '\u{1F1F2}\u{1F1E6}'; // 🇲🇦

  static const _countryOptions = <({String code, String flag, String label})>[
    (code: '+212', flag: '\u{1F1F2}\u{1F1E6}', label: 'Maroc'),
    (code: '+33',  flag: '\u{1F1EB}\u{1F1F7}', label: 'France'),
    (code: '+44',  flag: '\u{1F1EC}\u{1F1E7}', label: 'Royaume-Uni'),
    (code: '+1',   flag: '\u{1F1FA}\u{1F1F8}', label: 'États-Unis'),
    (code: '+971', flag: '\u{1F1E6}\u{1F1EA}', label: 'E.A.U.'),
    (code: '+39',  flag: '\u{1F1EE}\u{1F1F9}', label: 'Italie'),
    (code: '+34',  flag: '\u{1F1EA}\u{1F1F8}', label: 'Espagne'),
    (code: '+49',  flag: '\u{1F1E9}\u{1F1EA}', label: 'Allemagne'),
    (code: '+32',  flag: '\u{1F1E7}\u{1F1EA}', label: 'Belgique'),
    (code: '+41',  flag: '\u{1F1E8}\u{1F1ED}', label: 'Suisse'),
    (code: '+31',  flag: '\u{1F1F3}\u{1F1F1}', label: 'Pays-Bas'),
    (code: '+213', flag: '\u{1F1E9}\u{1F1FF}', label: 'Algérie'),
    (code: '+216', flag: '\u{1F1F9}\u{1F1F9}', label: 'Tunisie'),
    (code: '+20',  flag: '\u{1F1EA}\u{1F1EC}', label: 'Égypte'),
    (code: '+90',  flag: '\u{1F1F9}\u{1F1F7}', label: 'Turquie'),
    (code: '+7',   flag: '\u{1F1F7}\u{1F1FA}', label: 'Russie'),
    (code: '+86',  flag: '\u{1F1E8}\u{1F1F3}', label: 'Chine'),
    (code: '+91',  flag: '\u{1F1EE}\u{1F1F3}', label: 'Inde'),
    (code: '+81',  flag: '\u{1F1EF}\u{1F1F5}', label: 'Japon'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _composedMessage() {
    final lines = <String>[
      'Bonjour Marrakech Privée,',
      '',
    ];

    if (widget.activity != null) {
      lines.add('\u2022 Exp\u00E9rience : ${widget.activity!.title}');
    }
    if (widget.bucketItems != null && widget.bucketItems!.isNotEmpty) {
      lines.add('\u2022 Exp\u00E9riences s\u00E9lectionn\u00E9es :');
      for (final item in widget.bucketItems!) {
        lines.add('  \u2013 ${item.title}');
      }
    }
    if (_startDate != null) lines.add('\u2022 Du : ${_fmt(_startDate!)}');
    if (_endDate != null) lines.add('\u2022 Au : ${_fmt(_endDate!)}');
    if (_startDate == null && _endDate == null) {
      lines.add('\u2022 Dates \u00E0 d\u00E9finir ensemble');
    }
    lines.add('\u2022 Nombre de personnes : $_people');
    lines.add('\u2022 Nom : ${_nameController.text.trim()}');
    lines.add(
        '\u2022 T\u00E9l\u00E9phone : $_selectedCountryCode ${_phoneController.text.trim()}');
    final notes = _notesController.text.trim();
    if (notes.isNotEmpty) {
      lines.add('\u2022 Informations compl\u00E9mentaires : $notes');
    }
    return lines.join('\n');
  }

  Future<void> _pickDate({required bool start}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: start ? (_startDate ?? now) : (_endDate ?? _startDate ?? now),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: coral),
          fontFamily: 'serif',
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (start) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  bool _validate() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez remplir votre nom et votre num\u00E9ro de t\u00E9l\u00E9phone.',
            style: TextStyle(fontSize: 12),
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _send(OutreachMethod method) async {
    if (!_validate()) return;
    final message = _composedMessage();
    switch (method) {
      case OutreachMethod.whatsapp:
        await Outreach.whatsapp(context, message);
        break;
      case OutreachMethod.instagram:
        await Outreach.instagram(context, message);
        break;
      case OutreachMethod.email:
        await Outreach.email(context, 'Demande sur mesure \u2014 Marrakech Priv\u00E9e', message);
        break;
    }
  }

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'Demande sur mesure',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dites-nous tout.',
                style: TextStyle(fontSize: 34, color: espresso, height: 1.05, fontWeight: FontWeight.w300)),
            const Text('Nous concevons le reste.',
                style: TextStyle(fontSize: 34, color: coral, height: 1.05, fontWeight: FontWeight.w300)),
            const SizedBox(height: 15),
            const Text(
              'Champs marqu\u00E9s \u2731 sont obligatoires.',
              style: TextStyle(color: brown, fontSize: 12, height: 1.6),
            ),
            const SizedBox(height: 22),

            // ── Activity context ──────────────────────────────────────
            if (widget.activity != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: blushDeep),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_activity_outlined, size: 16, color: coral),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.activity!.title,
                        style: const TextStyle(color: espresso, fontSize: 13, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
            ] else if (widget.bucketItems != null && widget.bucketItems!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: blushDeep),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bookmark_border, size: 16, color: coral),
                        SizedBox(width: 8),
                        Text('Ma bucket list', style: TextStyle(color: espresso, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final item in widget.bucketItems!)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '\u2013 ${item.title}',
                          style: const TextStyle(color: brown, fontSize: 12, height: 1.4),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
            ],

            // ── Dates ────────────────────────────────────────────────
            _DateField(
              label: 'Date de d\u00E9but',
              date: _startDate,
              hint: 'Choisir une date',
              onTap: () => _pickDate(start: true),
            ),
            const SizedBox(height: 10),
            _DateField(
              label: 'Date de fin',
              date: _endDate,
              hint: 'Choisir une date',
              onTap: () => _pickDate(start: false),
            ),
            const SizedBox(height: 22),

            // ── People ───────────────────────────────────────────────
            _CounterField(
              label: 'Nombre de personnes',
              value: _people,
              min: 1,
              onChanged: (v) => setState(() => _people = v),
            ),
            const SizedBox(height: 22),

            // ── Name (required) ──────────────────────────────────────
            const _FieldLabel('Nom et pr\u00E9nom \u2731'),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: espresso, fontSize: 14),
              decoration: _inputDecoration('Comment vous appeler ?'),
            ),
            const SizedBox(height: 18),

            // ── Phone (required) ─────────────────────────────────────
            const _FieldLabel('T\u00E9l\u00E9phone \u2731'),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: blushDeep),
              ),
              child: Row(
                children: [
                  // Country code picker
                  InkWell(
                    onTap: _showCountryPicker,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: blushDeep),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedCountryFlag, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(_selectedCountryCode,
                              style: const TextStyle(color: espresso, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 2),
                          const Icon(Icons.expand_more, size: 14, color: brown),
                        ],
                      ),
                    ),
                  ),
                  // Phone number
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: espresso, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: '+212 6 00 00 00 00',
                        hintStyle: const TextStyle(color: brown, fontSize: 13),
                        filled: true,
                        fillColor: cream,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // ── Notes (optional) ─────────────────────────────────────
            const _FieldLabel('Informations compl\u00E9mentaires (facultatif)'),
            const SizedBox(height: 6),
            TextField(
              controller: _notesController,
              maxLines: 4,
              style: const TextStyle(color: espresso, fontSize: 14),
              decoration: _inputDecoration(
                'Dates flexibles, pr\u00E9f\u00E9rences, occasion, tout ce qui nous aide \u00E0 vous pr\u00E9parer la meilleure exp\u00E9rience\u2026',
              ),
            ),
            const SizedBox(height: 30),

            // ── Send actions ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: PillButton(
                label: 'Envoyer sur WhatsApp',
                onPressed: () => _send(OutreachMethod.whatsapp),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _send(OutreachMethod.email),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: espresso,
                      side: const BorderSide(color: blushDeep),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('E-mail', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _send(OutreachMethod.instagram),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: espresso,
                      side: const BorderSide(color: blushDeep),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Instagram', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'R\u00E9ponse personnelle sous 24h \u00B7 Confidentiel \u00B7 Sans engagement',
                style: TextStyle(color: brown, fontSize: 11),
              ),
            ),
          ],
        ),
      );

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: blushDeep,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Indicatif pays',
                  style: TextStyle(color: espresso, fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countryOptions.length,
                  itemBuilder: (_, index) {
                    final c = _countryOptions[index];
                    final isSelected = c.code == _selectedCountryCode;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                      title: Text(
                        c.label,
                        style: TextStyle(
                          color: espresso,
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: Text(
                        c.code,
                        style: TextStyle(
                          color: isSelected ? coral : brown,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountryCode = c.code;
                          _selectedCountryFlag = c.flag;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared field decorations ──────────────────────────────────────────────────

InputDecoration _inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: brown, fontSize: 13),
      filled: true,
      fillColor: cream,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: blushDeep),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: blushDeep),
      ),
    );

// ── Re-usable small widgets ──────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(color: brown, fontSize: 12, fontWeight: FontWeight.w600),
      );
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String hint;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.hint,
    required this.onTap,
  });

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: blushDeep),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 15, color: coral),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$label \u00B7 ${date != null ? _fmt(date!) : hint}',
                  style: TextStyle(color: date != null ? espresso : brown, fontSize: 14),
                ),
              ),
              const Icon(Icons.expand_more, size: 18, color: brown),
            ],
          ),
        ),
      );
}

class _CounterField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final ValueChanged<int> onChanged;

  const _CounterField({
    required this.label,
    required this.value,
    required this.min,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: blushDeep),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(label, style: const TextStyle(color: brown, fontSize: 13)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepButton(
                  icon: Icons.remove,
                  onTap: () => value > min ? onChanged(value - 1) : null,
                ),
                Text(
                  '$value',
                  style: const TextStyle(color: espresso, fontSize: 17, fontWeight: FontWeight.w700),
                ),
                _StepButton(icon: Icons.add, onTap: () => onChanged(value + 1)),
              ],
            ),
          ],
        ),
      );
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: onTap != null ? blush : blushDeep,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: onTap != null ? espresso : brown),
        ),
      );
}
