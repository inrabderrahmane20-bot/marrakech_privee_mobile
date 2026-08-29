import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  // 01 · Votre demande.
  static const _requestTypesAll = [
    'Conciergerie & activités',
    'Événement privé',
    'Événement corporatif',
    'Lieu et villa',
    'Expérience signature',
    'Séjour complet',
  ];
  final Set<String> _requestTypes = {};
  String? _occasion;
  static const _occasions = [
    'Mariage',
    'Proposition',
    'Anniversaire',
    'EVJF',
    'Séminaire d’entreprise',
    'Construction d’équipe',
    'Lancement de marque',
    'Dîner privé',
    'Lune de miel',
    'Voyage en famille',
    'Autre',
  ];

  // 02 · Dates et invités.
  DateTime? _arrivalDate;
  DateTime? _departureDate;
  bool _flexibleDates = false;
  String? _preferredMoment;
  static const _moments = ['Matin', 'Midi', 'Après-midi', 'Coucher de soleil', 'Soirée', 'Nuit'];
  int _adults = 2;
  int _children = 0;

  // 03 · Services.
  final Set<String> _services = {};
  static const _serviceOptions = [
    'Villa ou riad',
    'Chef privé',
    'Restauration',
    'Chauffeur privé & transferts',
    'Décoration & scénographie',
    'Photographe / vidéaste',
    'Musique, DJ et artistes',
    'Beauté et spa',
    'Sécurité',
    'Garde d’enfants',
    'Excursions & activités',
    'Réservations de restaurants',
    'Billetterie & spectacles',
    'Location de matériel',
  ];

  // 04 · Style et préférences.
  String? _where;
  static const _whereOptions = [
    'Marrakech',
    'Désert d’Agafay',
    'Atlas',
    'Essaouira',
    'Palmeraie',
    'Plusieurs endroits',
    'Je ne suis pas encore sûr',
  ];
  String? _ambiance;
  static const _ambianceOptions = [
    'Intime & romantique',
    'Festive',
    'Élégante & chic',
    'Aventureuse',
    'Détente & bien-être',
    'Familiale',
    'Autre',
  ];
  String? _budget;
  static const _budgetOptions = [
    'Moins de 1 000 €',
    '1 000 – 5 000 €',
    '5 000 – 15 000 €',
    '15 000 – 50 000 €',
    'Plus de 50 000 €',
    'Je préfère en discuter',
  ];
  final _allergiesController = TextEditingController();
  final _detailsController = TextEditingController();

  // 05 · Comment vous joindre.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _contactMethod;
  static const _contactMethods = ['WhatsApp', 'E-mail', 'Téléphone'];

  @override
  void dispose() {
    _allergiesController.dispose();
    _detailsController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool arrival}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: arrival ? (_arrivalDate ?? now) : (_departureDate ?? _arrivalDate ?? now),
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 3)),
      builder: (context, child) => Theme(
        data: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: coral), fontFamily: 'serif'),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (arrival) {
          _arrivalDate = picked;
          if (_departureDate != null && _departureDate!.isBefore(picked)) _departureDate = null;
        } else {
          _departureDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String _composeMessage() {
    final lines = <String>['Bonjour Marrakech Privée, voici ma demande sur mesure :', ''];

    void field(String label, String value) {
      final text = value.trim();
      if (text.isEmpty) return;
      lines.add('• $label : $text');
    }

    lines.add('— 01 · Votre demande —');
    if (_requestTypes.isNotEmpty) field('Type', _requestTypes.join(', '));
    field('Occasion', _occasion ?? '');

    lines.add('');
    lines.add('— 02 · Dates et invités —');
    if (_arrivalDate != null) field('Arrivée', _formatDate(_arrivalDate!));
    if (_departureDate != null) field('Départ', _formatDate(_departureDate!));
    field('Dates flexibles', _flexibleDates ? 'Oui' : 'Non');
    if (_departureDate == null && !_flexibleDates) lines.add('• Dates à préciser ensemble');
    field('Moment préféré', _preferredMoment ?? '');
    lines.add('• Invités : $_adults adulte${_adults > 1 ? 's' : ''}${_children > 0 ? ', $_children enfant${_children > 1 ? 's' : ''}' : ''}');

    if (_services.isNotEmpty) {
      lines.add('');
      lines.add('— 03 · Services —');
      for (final service in _services) {
        lines.add('• $service');
      }
    }

    if (_where != null || _ambiance != null || _budget != null || _allergiesController.text.isNotEmpty || _detailsController.text.isNotEmpty) {
      lines.add('');
      lines.add('— 04 · Style et préférences —');
      field('Où', _where ?? '');
      field('Ambiance', _ambiance ?? '');
      field('Budget', _budget ?? '');
      field('Allergies / régimes', _allergiesController.text);
      field('Précisions', _detailsController.text);
    }

    lines.add('');
    lines.add('— 05 · Mes coordonnées —');
    field('Nom', _nameController.text);
    field('E-mail', _emailController.text);
    field('Téléphone / WhatsApp', _phoneController.text);
    field('Moyen privilégié', _contactMethod ?? '');

    lines.add('');
    lines.add('Merci de votre réponse personnalisée !');
    return lines.join('\n');
  }

  Future<void> _submit() async {
    final message = _composeMessage();
    await Clipboard.setData(ClipboardData(text: message));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande copiée — collez-la dans WhatsApp au $whatsappNumber.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'Demande sur mesure',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dites-nous tout.', style: TextStyle(fontSize: 34, color: espresso, height: 1.05, fontWeight: FontWeight.w300)),
            const Text('Nous concevons le reste.', style: TextStyle(fontSize: 34, color: coral, height: 1.05, fontWeight: FontWeight.w300)),
            const SizedBox(height: 15),
            const Text(
              'Plus vous partagez de détails, plus notre première proposition sera précise : chaque champ est facultatif, sauf le moyen de vous joindre.',
              style: TextStyle(color: brown, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 15),
            const Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _TrustTag(text: 'Réponse personnelle sous 24h'),
                _TrustTag(text: 'Confidentiel'),
                _TrustTag(text: 'Sans engagement'),
              ],
            ),
            const SizedBox(height: 34),
            _StepHeader(num: '01', title: 'Votre demande'),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _requestTypesAll.map((type) {
                final selected = _requestTypes.contains(type);
                return ChoiceChip(
                  label: Text(type),
                  selected: selected,
                  onSelected: (_) => setState(() {
                    selected ? _requestTypes.remove(type) : _requestTypes.add(type);
                  }),
                  selectedColor: coral,
                  backgroundColor: cream,
                  labelStyle: TextStyle(color: selected ? cream : brown, fontSize: 12, fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
                  side: BorderSide.none,
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            _DropdownField(
              hint: 'L’occasion',
              value: _occasion,
              items: _occasions,
              onChanged: (value) => setState(() => _occasion = value),
            ),
            const SizedBox(height: 34),
            _StepHeader(num: '02', title: 'Dates et invités'),
            const SizedBox(height: 14),
            _DateField(label: 'Date d’arrivée', date: _arrivalDate, hint: 'Choisir une date', onTap: () => _pickDate(arrival: true)),
            const SizedBox(height: 10),
            _DateField(label: 'Date de départ (facultatif)', date: _departureDate, hint: 'Choisir une date', onTap: () => _pickDate(arrival: false)),
            const SizedBox(height: 6),
            SwitchListTile(
              value: _flexibleDates,
              onChanged: (value) => setState(() => _flexibleDates = value),
              title: const Text('Mes dates sont flexibles', style: TextStyle(color: espresso, fontSize: 14)),
              activeThumbColor: coral,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            const SizedBox(height: 8),
            _DropdownField(
              hint: 'Moment préféré',
              value: _preferredMoment,
              items: _moments,
              onChanged: (value) => setState(() => _preferredMoment = value),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _CounterField(label: 'Adultes', value: _adults, min: 1, onChanged: (v) => setState(() => _adults = v))),
                const SizedBox(width: 14),
                Expanded(child: _CounterField(label: 'Enfants', value: _children, min: 0, onChanged: (v) => setState(() => _children = v))),
              ],
            ),
            const SizedBox(height: 34),
            _StepHeader(num: '03', title: 'Services'),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Vous pouvez en sélectionner plusieurs.', style: TextStyle(color: brown, fontSize: 12)),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _serviceOptions.map((service) {
                final selected = _services.contains(service);
                return FilterChip(
                  label: Text(service),
                  selected: selected,
                  onSelected: (_) => setState(() {
                    selected ? _services.remove(service) : _services.add(service);
                  }),
                  selectedColor: blushDeep,
                  backgroundColor: cream,
                  labelStyle: const TextStyle(color: espresso, fontSize: 12),
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                );
              }).toList(),
            ),
            const SizedBox(height: 34),
            _StepHeader(num: '04', title: 'Style et préférences'),
            const SizedBox(height: 14),
            _DropdownField(
              hint: 'Où ?',
              value: _where,
              items: _whereOptions,
              onChanged: (value) => setState(() => _where = value),
            ),
            const SizedBox(height: 10),
            _DropdownField(
              hint: 'Ambiance',
              value: _ambiance,
              items: _ambianceOptions,
              onChanged: (value) => setState(() => _ambiance = value),
            ),
            const SizedBox(height: 10),
            _DropdownField(
              hint: 'Budget prévisionnel',
              value: _budget,
              items: _budgetOptions,
              onChanged: (value) => setState(() => _budget = value),
            ),
            const SizedBox(height: 14),
            _TextArea(label: 'Allergies ou régimes alimentaires', controller: _allergiesController, hint: 'Facultatif', lines: 2),
            const SizedBox(height: 14),
            _TextArea(label: 'Dis-nous tout…', controller: _detailsController, hint: 'Votre projet, vos envies, le déroulé de rêve…', lines: 5),
            const SizedBox(height: 34),
            _StepHeader(num: '05', title: 'Comment vous joindre'),
            const SizedBox(height: 14),
            _TextArea(label: 'Nom et prénom', controller: _nameController, hint: 'Comment vous appeler ?', lines: 1),
            const SizedBox(height: 10),
            _TextArea(label: 'E-mail', controller: _emailController, hint: 'vous@exemple.com', lines: 1, keyboard: TextInputType.emailAddress),
            const SizedBox(height: 10),
            _TextArea(label: 'WhatsApp / téléphone', controller: _phoneController, hint: '+212 6 00 00 00 00', lines: 1, keyboard: TextInputType.phone),
            const SizedBox(height: 10),
            _DropdownField(
              hint: 'Moyen privilégié pour vous répondre',
              value: _contactMethod,
              items: _contactMethods,
              onChanged: (value) => setState(() => _contactMethod = value),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: PillButton(label: 'Envoyer ma demande sur WhatsApp', onPressed: _submit),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text('Réponse personnelle sous 24h · Confidentiel · Sans engagement', style: TextStyle(color: brown, fontSize: 11)),
            ),
          ],
        ),
      );
}

class _StepHeader extends StatelessWidget {
  final String num;
  final String title;
  const _StepHeader({required this.num, required this.title});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Rule(),
          const SizedBox(width: 12),
          Text(num, style: const TextStyle(color: coral, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: espresso, fontSize: 20, fontWeight: FontWeight.w300)),
          ),
        ],
      );
}

class _TrustTag extends StatelessWidget {
  final String text;
  const _TrustTag({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(30), border: Border.all(color: blushDeep)),
        child: Text(text, style: const TextStyle(color: brown, fontSize: 10)),
      );
}

class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({required this.hint, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(14), border: Border.all(color: blushDeep)),
        child: DropdownButtonFormField<String>(
          key: ValueKey(value),
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(border: InputBorder.none, hintText: '', contentPadding: EdgeInsets.zero),
          hint: Text(hint, style: const TextStyle(color: brown, fontSize: 14)),
          style: const TextStyle(color: espresso, fontSize: 14),
          dropdownColor: cream,
          iconEnabledColor: coral,
          items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      );
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String hint;
  final VoidCallback onTap;

  const _DateField({required this.label, required this.date, required this.hint, required this.onTap});

  String _format(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(14), border: Border.all(color: blushDeep)),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 15, color: coral),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$label · ${date != null ? _format(date!) : hint}',
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

  const _CounterField({required this.label, required this.value, required this.min, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(14), border: Border.all(color: blushDeep)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: brown, fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepButton(icon: Icons.remove, onTap: () => value > min ? onChanged(value - 1) : null),
                Text('$value', style: const TextStyle(color: espresso, fontSize: 17, fontWeight: FontWeight.w700)),
                _StepButton(icon: Icons.add, onTap: () => onChanged(value + 1)),
              ],
            ),
          ],
        ),
      );
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: blush, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 17, color: espresso),
        ),
      );
}

class _TextArea extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int lines;
  final TextInputType? keyboard;

  const _TextArea({required this.label, required this.controller, required this.hint, required this.lines, this.keyboard});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(label, style: const TextStyle(color: brown, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: lines,
            style: const TextStyle(color: espresso, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: brown, fontSize: 13),
              filled: true,
              fillColor: cream,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: blushDeep)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: blushDeep)),
            ),
          ),
        ],
      );
}