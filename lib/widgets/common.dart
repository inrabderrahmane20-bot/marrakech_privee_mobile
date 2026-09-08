import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;
  const Eyebrow(this.text, {this.color = coral, super.key});

  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(color: color, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w500));
}

class Rule extends StatelessWidget {
  const Rule({super.key});

  @override
  Widget build(BuildContext context) => Container(width: 54, height: 1, color: coral);
}

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const PillButton({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: coral,
          foregroundColor: cream,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 11),
        ),
        child: Text(label),
      );
}

class ImageTile extends StatelessWidget {
  final String asset;
  final double height;
  const ImageTile(this.asset, this.height, {super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Image.asset('assets/$asset', width: double.infinity, height: height, fit: BoxFit.cover),
      );
}

class StepRow extends StatelessWidget {
  final String number;
  final String title;
  final String text;
  const StepRow(this.number, this.title, this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(number, style: const TextStyle(color: coral, fontSize: 13)),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: espresso, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(text, style: const TextStyle(color: brown, fontSize: 13, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      );
}

class ExperienceTile extends StatelessWidget {
  final String asset;
  final String title;
  const ExperienceTile(this.asset, this.title, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 17),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/$asset', width: 112, height: 112, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(color: espresso, fontSize: 20, fontWeight: FontWeight.w300))),
          ],
        ),
      );
}

class Stat extends StatelessWidget {
  final String value;
  final String label;
  const Stat(this.value, this.label, {super.key});

  @override
  Widget build(BuildContext context) =>
      Column(children: [Text(value, style: const TextStyle(color: coral, fontSize: 27, fontWeight: FontWeight.w300)), const SizedBox(height: 5), Text(label, style: const TextStyle(color: brown, fontSize: 11))]);
}

class FaqRow extends StatelessWidget {
  final String question;
  const FaqRow(this.question, {super.key});

  @override
  Widget build(BuildContext context) => ExpansionTile(
        title: Text(question, style: const TextStyle(color: espresso, fontSize: 15)),
        iconColor: coral,
        collapsedIconColor: coral,
        tilePadding: EdgeInsets.zero,
        children: const [
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text('Nous vous répondons avec une proposition personnalisée et un interlocuteur dédié.', style: TextStyle(color: brown, fontSize: 13, height: 1.5)),
          ),
        ],
      );
}

class SectionShell extends StatelessWidget {
  final Widget child;
  const SectionShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(23, 58, 23, 58), child: child);
}

class PageFrame extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? bottomBar;
  const PageFrame({required this.title, required this.child, this.bottomBar, super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: blush,
        appBar: AppBar(
          backgroundColor: blush,
          foregroundColor: espresso,
          elevation: 0,
          title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
        ),
        body: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(23, 15, 23, 40), child: child),
        bottomNavigationBar: bottomBar,
      );
}