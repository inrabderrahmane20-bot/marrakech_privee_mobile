import 'package:flutter/material.dart';

import 'app.dart';
import 'data/user_lists.dart';

export 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserLists.instance.load();
  runApp(const MarrakechPriveeApp());
}