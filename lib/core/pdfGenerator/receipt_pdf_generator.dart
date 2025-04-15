import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

Future<void> generateAndSharePDF(Map<String, dynamic> receiptData,
    List<Map<String, String>> services) async {
  final pdf = pw.Document();

  final bold = pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);
  final normal = pw.TextStyle(fontSize: 12);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) =>
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.code128(),
                  data: receiptData["transactionId"] ?? "N/A",
                  width: 200,
                  height: 60,
                ),
              ),
              pw.SizedBox(height: 20),

              buildRow(
                  "Booking Date", receiptData["bookingDate"], normal, bold),
              buildRow("Car", receiptData["car"], normal, bold),
              buildRow("Estimated Service Duration",
                  receiptData["estimatedDuration"], normal, bold),
              buildRow(
                  "Service Type", receiptData["serviceType"], normal, bold),

              pw.Divider(),

              ...services.map((service) =>
                  buildRow(
                    service["name"] ?? "Service",
                    service["price"] ?? "-",
                    normal,
                    bold,
                  )),

              pw.Divider(),

              buildRow("Total", receiptData["total"], normal, bold),
              buildRow("Promo Code", receiptData["promoCode"], normal, bold),
              buildRow("Discount", receiptData["discount"], normal, bold),
              pw.Divider(),
              buildRow("Total Paid", receiptData["totalPaid"], bold, bold),
              buildRow(
                  "Payment Method", receiptData["paymentMethod"], normal, bold),
              buildRow("Date", receiptData["transactionDate"], normal, bold),
              buildRow(
                  "Transaction Id", receiptData["transactionId"], normal, bold),
            ],
          ),
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
    name: 'e-receipt.pdf',
  );
}

pw.Widget buildRow(String label, String? value, pw.TextStyle labelStyle,
    pw.TextStyle valueStyle) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: labelStyle),
        pw.Text(value ?? '-', style: valueStyle),
      ],
    ),
  );
}
