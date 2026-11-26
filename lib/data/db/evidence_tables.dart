import 'package:drift/drift.dart';

import 'tables.dart';

class ImportJobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sourceAccountId => integer().references(Accounts, #id)();
  TextColumn get source => text().withDefault(const Constant('bank_csv'))();
  TextColumn get fileHash => text()();
  TextColumn get fileName => text()();
  IntColumn get parserVersion => integer()();
  TextColumn get mappingJson => text()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  IntColumn get openingMinor => integer()();
  IntColumn get closingMinor => integer()();
  IntColumn get debitMinor => integer()();
  IntColumn get creditMinor => integer()();
  IntColumn get rowCount => integer()();
  IntColumn get addedCount => integer().withDefault(const Constant(0))();
  IntColumn get matchedCount => integer().withDefault(const Constant(0))();
  IntColumn get skippedCount => integer().withDefault(const Constant(0))();
  TextColumn get error => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {source, sourceAccountId, fileHash},
  ];
  @override
  List<String> get customConstraints => [
    "CHECK (length(file_hash) = 64 AND file_hash NOT GLOB '*[^0-9a-f]*')",
    "CHECK (source = 'bank_csv' AND currency = 'INR' AND status IN ('completed','failed'))",
    "CHECK (typeof(opening_minor)='integer' AND typeof(closing_minor)='integer')",
    "CHECK (typeof(debit_minor)='integer' AND debit_minor >= 0 AND typeof(credit_minor)='integer' AND credit_minor >= 0)",
    "CHECK (row_count > 0 AND added_count >= 0 AND matched_count >= 0 AND skipped_count >= 0)",
    "CHECK (status != 'completed' OR (opening_minor + credit_minor - debit_minor = closing_minor AND added_count + matched_count + skipped_count = row_count))",
  ];
}

class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sha256 => text().unique()();
  TextColumn get encryptedFilePath => text().unique()();
  TextColumn get originalName => text()();
  TextColumn get documentType => text().withDefault(const Constant('invoice_pdf'))();
  IntColumn get byteLength => integer()();
  IntColumn get encryptionVersion => integer().withDefault(const Constant(1))();
  IntColumn get extractionVersion => integer().withDefault(const Constant(0))();
  TextColumn get extractionStatus => text().withDefault(const Constant('not_extracted'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
    "CHECK (length(sha256)=64 AND sha256 NOT GLOB '*[^0-9a-f]*')",
    "CHECK (document_type = 'invoice_pdf' AND byte_length > 0 AND byte_length <= 26214400)",
    "CHECK (encryption_version = 1 AND extraction_version >= 0)",
    "CHECK (extraction_status IN ('not_extracted','needs_review','extracted','failed'))",
    "CHECK (encrypted_file_path = sha256 || '.kpdf')",
  ];
}

class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId => integer().references(Documents, #id)();
  TextColumn get kind => text().withDefault(const Constant('invoice'))();
  TextColumn get supplierGstin => text().nullable()();
  TextColumn get recipientGstin => text().nullable()();
  TextColumn get vendorName => text()();
  TextColumn get invoiceNumber => text()();
  DateTimeColumn get invoiceDate => dateTime()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  IntColumn get taxableMinor => integer()();
  IntColumn get cgstMinor => integer().withDefault(const Constant(0))();
  IntColumn get sgstMinor => integer().withDefault(const Constant(0))();
  IntColumn get igstMinor => integer().withDefault(const Constant(0))();
  IntColumn get cessMinor => integer().withDefault(const Constant(0))();
  IntColumn get roundingMinor => integer().withDefault(const Constant(0))();
  IntColumn get totalMinor => integer()();
  TextColumn get arithmeticStatus => text().withDefault(const Constant('needs_review'))();
  TextColumn get gstEligibilityStatus => text().withDefault(const Constant('not_assessed'))();

  @override
  List<String> get customConstraints => [
    "CHECK (kind IN ('invoice','credit_note') AND currency = 'INR')",
    "CHECK (length(trim(invoice_number)) > 0 AND length(trim(vendor_name)) > 0)",
    "CHECK (typeof(taxable_minor)='integer' AND taxable_minor >= 0 AND typeof(total_minor)='integer' AND total_minor >= 0)",
    "CHECK (typeof(cgst_minor)='integer' AND cgst_minor >= 0 AND typeof(sgst_minor)='integer' AND sgst_minor >= 0)",
    "CHECK (typeof(igst_minor)='integer' AND igst_minor >= 0 AND typeof(cess_minor)='integer' AND cess_minor >= 0 AND typeof(rounding_minor)='integer')",
    "CHECK (igst_minor = 0 OR (cgst_minor = 0 AND sgst_minor = 0))",
    "CHECK (arithmetic_status IN ('needs_review','consistent','mismatch'))",
    "CHECK (arithmetic_status != 'consistent' OR taxable_minor + cgst_minor + sgst_minor + igst_minor + cess_minor + rounding_minor = total_minor)",
    "CHECK (gst_eligibility_status IN ('not_assessed','needs_ca_review','eligible','ineligible'))",
  ];
}

class InvoiceLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id, onDelete: KeyAction.cascade)();
  IntColumn get lineNumber => integer()();
  TextColumn get description => text()();
  TextColumn get hsnSac => text().nullable()();
  IntColumn get taxRateBps => integer()();
  IntColumn get taxableMinor => integer()();
  IntColumn get cgstMinor => integer().withDefault(const Constant(0))();
  IntColumn get sgstMinor => integer().withDefault(const Constant(0))();
  IntColumn get igstMinor => integer().withDefault(const Constant(0))();
  IntColumn get cessMinor => integer().withDefault(const Constant(0))();
  IntColumn get totalMinor => integer()();
  @override
  List<Set<Column>> get uniqueKeys => [
    {invoiceId, lineNumber},
  ];
  @override
  List<String> get customConstraints => [
    "CHECK (line_number > 0 AND typeof(tax_rate_bps)='integer' AND tax_rate_bps BETWEEN 0 AND 10000)",
    "CHECK (typeof(taxable_minor)='integer' AND taxable_minor >= 0 AND typeof(total_minor)='integer' AND total_minor >= 0)",
    "CHECK (typeof(cgst_minor)='integer' AND cgst_minor >= 0 AND typeof(sgst_minor)='integer' AND sgst_minor >= 0)",
    "CHECK (typeof(igst_minor)='integer' AND igst_minor >= 0 AND typeof(cess_minor)='integer' AND cess_minor >= 0)",
    "CHECK (igst_minor = 0 OR (cgst_minor = 0 AND sgst_minor = 0))",
    'CHECK (taxable_minor + cgst_minor + sgst_minor + igst_minor + cess_minor = total_minor)',
  ];
}

class SourceEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get source => text()();
  IntColumn get sourceAccountId => integer().references(Accounts, #id)();
  TextColumn get externalId => text()();
  TextColumn get contentHash => text()();
  DateTimeColumn get receivedAt => dateTime()();
  IntColumn get importJobId => integer().nullable().references(ImportJobs, #id)();
  IntColumn get transactionId => integer().nullable().references(Transactions, #id, onDelete: KeyAction.setNull)();
  TextColumn get encryptedEvidenceRef => text().nullable()();
  TextColumn get payloadJson => text()(); // Protected by SQLCipher; never logged.
  @override
  List<Set<Column>> get uniqueKeys => [
    {source, sourceAccountId, externalId},
  ];
  @override
  List<String> get customConstraints => [
    "CHECK (source IN ('bank_csv','notification','manual'))",
    "CHECK (length(external_id)>0 AND length(content_hash)=64 AND content_hash NOT GLOB '*[^0-9a-f]*')",
  ];
}

class Classifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().unique().references(Transactions, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('suggestedClassifications')
  IntColumn get suggestedCategoryId => integer().nullable().references(Categories, #id)();
  @ReferenceName('confirmedClassifications')
  IntColumn get confirmedCategoryId => integer().nullable().references(Categories, #id)();
  IntColumn get businessUseBps => integer()();
  TextColumn get businessPurpose => text().nullable()();
  TextColumn get provenance => text()();
  TextColumn get gstEligibilityStatus => text().withDefault(const Constant('not_assessed'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  List<String> get customConstraints => [
    "CHECK (typeof(business_use_bps)='integer' AND business_use_bps BETWEEN 0 AND 10000)",
    "CHECK (provenance IN ('rule','user','ca'))",
    "CHECK (gst_eligibility_status IN ('not_assessed','needs_ca_review','eligible','ineligible'))",
  ];
}

class BusinessRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get merchantPattern => text().unique()();
  IntColumn get businessUseBps => integer()();
  TextColumn get provenance => text().withDefault(const Constant('user'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  @override
  List<String> get customConstraints => [
    "CHECK (length(trim(merchant_pattern)) > 0 AND typeof(business_use_bps)='integer' AND business_use_bps BETWEEN 0 AND 10000)",
    "CHECK (provenance IN ('user','ca'))",
  ];
}

class PaymentAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get invoiceId => integer().references(Invoices, #id)();
  TextColumn get kind => text()();
  IntColumn get allocatedMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get provenance => text().withDefault(const Constant('user'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  @override
  List<Set<Column>> get uniqueKeys => [
    {transactionId, invoiceId, kind},
  ];
  @override
  List<String> get customConstraints => [
    "CHECK (kind IN ('payment','refund') AND currency = 'INR')",
    "CHECK (typeof(allocated_minor)='integer' AND allocated_minor > 0)",
    "CHECK (provenance IN ('user','ca'))",
  ];
}

class ReviewEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  TextColumn get action => text()();
  TextColumn get beforeJson => text()();
  TextColumn get afterJson => text()();
  TextColumn get provenance => text().withDefault(const Constant('user'))();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  @override
  List<String> get customConstraints => [
    'CHECK (length(entity_type)>0 AND entity_id >= 0 AND length("action")>0)',
    "CHECK (provenance IN ('rule','user','ca','system'))",
    'CHECK (json_valid(before_json) AND json_valid(after_json))',
  ];
}

class ExportRuns extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  IntColumn get formatVersion => integer()();
  IntColumn get includedCount => integer()();
  TextColumn get manifestSha256 => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  @override
  List<String> get customConstraints => [
    'CHECK (period_start < period_end AND format_version > 0 AND included_count >= 0)',
    "CHECK (length(manifest_sha256)=64 AND manifest_sha256 NOT GLOB '*[^0-9a-f]*')",
  ];
}

class ExportItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exportRunId => integer().references(ExportRuns, #id, onDelete: KeyAction.cascade)();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  TextColumn get snapshotJson => text()();
  TextColumn get contentHash => text()();
  @override
  List<Set<Column>> get uniqueKeys => [
    {exportRunId, entityType, entityId},
  ];
  @override
  List<String> get customConstraints => [
    "CHECK (entity_type IN ('transaction','invoice','document') AND entity_id > 0)",
    "CHECK (length(content_hash)=64 AND content_hash NOT GLOB '*[^0-9a-f]*')",
  ];
}
