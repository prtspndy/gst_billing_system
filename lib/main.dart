import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/bill_provider.dart';
import 'providers/business_profile_provider.dart';
import 'providers/item_provider.dart';
import 'providers/party_provider.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize unified database storage
  await DatabaseService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusinessProfileProvider()),
        ChangeNotifierProvider(create: (_) => PartyProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => BillProvider()),
      ],
      child: const GstBillingApp(),
    ),
  );
}
