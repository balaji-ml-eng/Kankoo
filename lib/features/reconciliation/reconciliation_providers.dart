import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../reconciliation/reconciliation_service.dart';
import '../imports/statement_import_providers.dart';

final reconciliationServiceProvider = Provider(
  (ref) => ReconciliationService(
    ref.watch(databaseProvider),
    verifyDocument: (document) async {
      final vault = await ref.read(pdfVaultProvider.future);
      await vault.readPdf(document);
    },
  ),
);

final reconciliationMonthProvider = StreamProvider.autoDispose.family<ReviewSnapshot, DateTime>(
  (ref, month) => ref.watch(reconciliationServiceProvider).watchMonth(month),
);
