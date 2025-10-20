import 'dart:typed_data';

import 'package:builders_konnect/core/models/network/sales_order_details_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfReceiptGenerator {
  static Future<Uint8List> buildSalesOrderReceiptPdf({
    required SalesOrdersModel order,
    String logoAssetPath = 'assets/images/logo.png',
  }) async {
    final doc = pw.Document();

    // Load logo if available
    pw.MemoryImage? logoImage;
    try {
      final bytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    final dateFmt = DateFormat('yyyy-MM-dd HH:mm');
    final orderDate = order.date != null ? dateFmt.format(order.date!) : 'N/A';

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(24),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        build: (context) {
          return [
            _buildHeader(logoImage, order),
            pw.SizedBox(height: 12),
            _buildOrderInfo(orderDate, order),
            pw.SizedBox(height: 16),
            _buildCustomerInfo(order),
            pw.SizedBox(height: 16),
            _buildItemsTable(order),
            pw.SizedBox(height: 16),
            _buildSummary(order),
            pw.SizedBox(height: 24),
            _buildFooter(),
          ];
        },
      ),
    );

    return doc.save();
  }

  static pw.Widget _buildHeader(pw.MemoryImage? logoImage, SalesOrdersModel order) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Row(children: [
          if (logoImage != null)
            pw.Container(
              width: 48,
              height: 48,
              margin: const pw.EdgeInsets.only(right: 12),
              child: pw.Image(logoImage),
            ),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Builders Konnect', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text('Sales Order Receipt', style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
          ])
        ]),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('Order #${order.orderNumber ?? 'N/A'}', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          if (order.receiptNo != null)
            pw.Text('Receipt: ${order.receiptNo}', style: const pw.TextStyle(fontSize: 10)),
        ]),
      ],
    );
  }

  static pw.Widget _buildOrderInfo(String orderDate, SalesOrdersModel order) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          _kv('Sales Type', order.salesType?.toUpperCase() ?? 'N/A'),
          _kv('Date', orderDate),
        ]),
        pw.SizedBox(height: 6),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          _kv('Payment Status', order.paymentStatus ?? 'N/A'),
          _kv('Status', order.status ?? 'N/A'),
        ]),
        if ((order.paymentMethods?.isNotEmpty ?? false)) ...[
          pw.SizedBox(height: 6),
          _kv('Payment Methods', order.paymentMethods!.map((e) => e.method ?? '').where((e) => e.isNotEmpty).join(', ')),
        ],
      ]),
    );
  }

  static pw.Widget _buildCustomerInfo(SalesOrdersModel order) {
    final customer = order.customer;
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('Customer', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        _kv('Name', customer?.name ?? 'N/A'),
        _kv('Email', customer?.email ?? 'N/A'),
        _kv('Phone', customer?.phone ?? 'N/A'),
        if ((order.billingAddress ?? '').isNotEmpty) _kv('Billing Address', order.billingAddress!),
        if ((order.shippingAddress ?? '').isNotEmpty) _kv('Shipping Address', order.shippingAddress!),
      ]),
    );
  }

  static pw.Widget _buildItemsTable(SalesOrdersModel order) {
    final headers = ['Product', 'SKU', 'Qty', 'Unit Cost', 'Discount', 'Total'];
    final data = (order.lineItems ?? []).map((li) => [
      li.product ?? '',
      li.productSku ?? '',
      (li.quantity ?? '').toString(),
      (li.unitCost ?? '').toString(),
      (li.discountedAmount ?? '').toString(),
      (li.totalCost ?? '').toString(),
    ]).toList();

    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text('Items', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 6),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(3),
          1: const pw.FlexColumnWidth(2),
          2: const pw.FlexColumnWidth(1),
          3: const pw.FlexColumnWidth(2),
          4: const pw.FlexColumnWidth(2),
          5: const pw.FlexColumnWidth(2),
        },
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: headers
                .map((h) => pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: pw.Text(h, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ))
                .toList(),
          ),
          ...data.map(
            (row) => pw.TableRow(
              children: row
                  .map((cell) => pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: pw.Text(cell, style: const pw.TextStyle(fontSize: 10)),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    ]);
  }

  static pw.Widget _buildSummary(SalesOrdersModel order) {
    String vatLabel = order.fees?.tax != null ? 'VAT (${order.fees!.tax} VAT)' : 'VAT';
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(children: [
        _kv('Subtotal', order.subtotal ?? 'N/A', boldValue: false),
        _kv('Discount', order.discountBreakdown?.orderDiscount ?? 'N/A', boldValue: false),
        _kv(vatLabel, order.fees?.tax?.toString() ?? 'N/A', boldValue: false),
        _kv('Service Fee', order.fees?.serviceFee?.toString() ?? 'N/A', boldValue: false),
        _kv('Delivery Fee', order.fees?.deliveryFee?.toString() ?? 'N/A', boldValue: false),
        pw.Divider(color: PdfColors.grey300),
        _kv('Total', order.amount ?? 'N/A', boldValue: true),
      ]),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Text(
        'Thank you for your business!',
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
      ),
    );
  }

  static pw.Widget _kv(String k, String v, {bool boldValue = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(k, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          pw.Text(v, style: pw.TextStyle(fontSize: 10, fontWeight: boldValue ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }
}