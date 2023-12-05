

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;
import 'package:gajgaji/_manager/myUi.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../_manager/bindings.dart';
import '../_manager/myVoids.dart';
import '../x_printPdf/examples.dart';

//time return
//prods return
//total return

Future<Uint8List> generateProds(PdfPageFormat pageFormat, CustomData data) async {

  //generate  prods list
  int index = 1;
  List<Productxx> productListOfProductX = prdCtr.productsList.map((prod) {
    String key = (index).toString();//prod index in inv
    index++;

    return Productxx(
        key,
        prod.name!,
        prod.currPrice!.toDouble(),
      prod.currBuyPrice!.toDouble(),

      prod.currQty!,
    );
  }).toList();


  /// ////////////// BUILD ///////////////////////////
  final invoice = Invoicex(
    invoiceNumber: '',
    products: productListOfProductX,//all products
    customerName: '',
    customerAddress: '',
    paymentInfo: '',
    tax: .0,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat);
}

class Invoicex {
  Invoicex({
    required this.products,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final List<Productxx> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.only(top: 35, bottom: 30, left: 40, right: 35),

        /// padding,
        //   pageTheme: _buildTheme( /// this theme contain the padding of all page
        //     pageFormat,
        //     await PdfGoogleFonts.robotoRegular(),
        //     await PdfGoogleFonts.robotoBold(),
        //     await PdfGoogleFonts.robotoItalic(),
        //   ),

        header: _buildHeader,

        /// invoice type + date + society NAme + delivery info
        // footer: _buildFooter,
        build: (context) => [
          //_contentHeader(context),
          pw.SizedBox(height: 25),

          _contentTable(context),/// table of products

          pw.SizedBox(height: 20),

          //_contentFooter(context),/// society informations + total

          //pw.SizedBox(height: 20),
          //_termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {


    return pw.Column(
      children: [
        pw.Row(
          //mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                      //height: 150,
                      alignment: pw.Alignment.topLeft,
                      child: pw.Column(children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.only(left: 0, right: 50),
                          child: pw.Text(
                            'Liste',
                            style: pw.TextStyle(
                              color: baseColor,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 5),

                        pw.Container(
                          padding: const pw.EdgeInsets.only(left: 0, right: 50),
                          child: pw.Text(
                            'Des Produits',
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 23,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 13),

                        pw.Container(
                          padding: const pw.EdgeInsets.only(left: 0, right: 50),
                          child: pw.Text(
                            'Date:   ${extractDate(todayToString())}',
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 17,
                            ),
                          ),
                        ),

                      ])),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Container(
                  alignment: pw.Alignment.topRight,
                  padding: const pw.EdgeInsets.only(bottom: 0, left: 0, right: 20), //height: 93,
                  child: pw.Column(
                      //mainAxisAlignment: pw.MainAxisAlignment.end,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          ' Gajgaji Karim',
                          style: pw.TextStyle(
                              color: baseColor, fontWeight: pw.FontWeight.bold, fontSize: 33, fontItalic: pw.Font.courier()),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          '    Vente en Gros Eaux et Boisson Gazeuse',
                          style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 11,
                              fontItalic: pw.Font.courier()),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Divider(color: accentColor, indent: 8),
                        pw.SizedBox(height: 13),
                        //_deliveryInfo(context),
                      ])
                  // child:
                  //     _logo != null ? pw.SvgImage(svg: _logo!) : pw.PdfLogo(),
                  ),
            ),
          ],
        ),
        //if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _deliveryInfo(pw.Context context) {
    return pw.Container(
        padding: pw.EdgeInsets.only(left: 10),
        //height: 70,
        child: pw.Column(children: [
          pw.RichText(
              text: pw.TextSpan(
                  text: 'Facture ${invCtr.selectedInvoice.type! != 'Multiple' ? 'à' : 'de'}: ',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                  children: [
                pw.TextSpan(
                  text: '${customerName}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
                const pw.TextSpan(
                  text: '\n',
                  style: pw.TextStyle(
                    fontSize: 8,
                  ),
                ),
                pw.TextSpan(
                  text: 'Mat.fiscale: ',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.TextSpan(
                  text: '${invCtr.selectedInvoice.deliveryMatFis}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
                const pw.TextSpan(
                  text: '\n',
                  style: pw.TextStyle(
                    fontSize: 8,
                  ),
                ),
                pw.TextSpan(
                  text: 'Address: ',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.TextSpan(
                  text: '${customerAddress}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
                const pw.TextSpan(
                  text: '\n',
                  style: pw.TextStyle(
                    fontSize: 8,
                  ),
                ),
                pw.TextSpan(
                  text: 'Tel: ',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.TextSpan(
                  text: '${customerAddress}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 10,
                  ),
                ),
              ])),
        ]));
  }

  pw.Widget _contentTable(pw.Context context) {
    List tableHeaders = ['Index', 'Nom du produit', 'Vente($currency)', 'Achat($currency)', 'Quantité'];

    return pw.Container(
        //padding: const pw.EdgeInsets.only(top: 10, bottom: 4,left: 15,right: 10),/// padding

        child: pw.TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => products[row].getIndex(col),
        ),
      ),
    ));
  }


}

class Productxx {
  const Productxx(
    this.ind,
    this.productName,
    this.sellPrice,
      this.buyPrice,

    this.currQty,
  );

  final String ind;
  final String productName;
  final double sellPrice;
  final double buyPrice;
  final int currQty;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return ind;
      case 1:
        return productName;
      case 2:
        return formatNumberAfterComma2(sellPrice);
      case 3:
        return formatNumberAfterComma2(buyPrice);

      case 4:
        return currQty.toString();

    }
    return '';
  }
}
