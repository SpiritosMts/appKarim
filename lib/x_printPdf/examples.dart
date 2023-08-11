import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import 'invoicePdf.dart';


const examples = <Example>[

  Example('INVOICE', 'invoicePdf.dart', generateInvoice),
  // Example('RÉSUMÉ', 'resume.dart', generateResume),
  // Example('DOCUMENT', 'document.dart', generateDocument),
  // Example('REPORT', 'report.dart', generateReport),
  // Example('CALENDAR', 'calendar.dart', generateCalendar),
  // Example('CERTIFICATE', 'certificate.dart', generateCertificate, true),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}

class CustomData {
  const CustomData({this.name = '[your name]'});

  final String name;
}

