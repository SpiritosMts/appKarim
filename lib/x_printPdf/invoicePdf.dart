/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
import 'examples.dart';

//time return
//prods return
//total return

Future<Uint8List> generateInvoice(PdfPageFormat pageFormat, CustomData data) async {

  Map<String,dynamic> invProds = invCtr.selectedInvoice.verified! ? invCtr.selectedInvoice.productsReturned!:invCtr.selectedInvoice.productsOut!;
  List<Productx> productListOfProductX = invProds.entries.map((prod) {

    String key = (int.parse(prod.key) +1).toString();
    Map<String, dynamic> productData = prod.value;

    return Productx(key, productData['name'], productData['priceSell'].toDouble(), productData['qty'].toInt(), productData['totalSell'].toDouble());
  }).toList();

  // final products = <Productx>[
  //   Productx('19874', lorem.sentence(4), 3.99, 2),
  //   Productx('98452', lorem.sentence(6), 15, 2),
  //   Productx('28375', lorem.sentence(4), 6.95, 3),
  //   Productx('95673', lorem.sentence(3), 49.99, 4),
  //   Productx('23763', lorem.sentence(2), 560.03, 1),
  //   Productx('55209', lorem.sentence(5), 26, 1),
  //
  //   Productx('07834', lorem.sentence(5), 12, 1),
  //   Productx('23547', lorem.sentence(5), 34, 1),
  //   Productx('98387', lorem.sentence(5), 7.99, 2),
  // ];

  final invoice = Invoicex(
    invoiceNumber: invCtr.selectedInvoice.id!,
    products: productListOfProductX,
    customerName: invCtr.selectedInvoice.deliveryName!,
    customerAddress: invCtr.selectedInvoice.deliveryAddress!,
    paymentInfo: 'id-facture: ${invCtr.selectedInvoice.id!}\naddress: ${societyAdress}\nMF: ${societyMf}\ntel: ${societyPhone}',
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

  final List<Productx> products;
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

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

 // double get _total => products.map<double>((p) => p.total).reduce((a, b) => a + b);

  //double get _grandTotal => _total * (1 + tax);

  String? _logo;

  String? _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    // _logo = await rootBundle.loadString('assets/logo.svg');
    // _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(

        margin: pw.EdgeInsets.only(top: 35, bottom: 30,left: 40,right: 35),/// padding,
      //   pageTheme: _buildTheme( /// this theme contain the padding of all page
      //     pageFormat,
      //     await PdfGoogleFonts.robotoRegular(),
      //     await PdfGoogleFonts.robotoBold(),
      //     await PdfGoogleFonts.robotoItalic(),
      //   ),

        header: _buildHeader,/// invoice type + date + society NAme + delivery info
       // footer: _buildFooter,
        build: (context) => [
          //_contentHeader(context),
          pw.SizedBox(height: 25),
          _contentTable(context),/// table of products
          pw.SizedBox(height: 20),
          _contentFooter(context),/// society informations + total
          //pw.SizedBox(height: 20),
          //_termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }
  pw.PageTheme _buildTheme(PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: false,///true
        //child: pw.SvgImage(svg: _bgShape!),
      ),
    );
  }
  pw.Widget _buildHeader(pw.Context context) {
    String invoiceType='';
    if(invCtr.selectedInvoice.type! == 'Multiple'){
      if( invCtr.selectedInvoice.verified! ) invoiceType = 'Retour';
      else invoiceType = 'Bande de Sortie';
    }else    if(invCtr.selectedInvoice.type! == 'Client'){
      invoiceType = 'Client';
    }else{
      invoiceType = 'Livraison';
    }

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
                    child: pw.Column(
                      children:  [
                        pw.Container(
                          padding: const pw.EdgeInsets.only(left: 0,right: 50),

                          child: pw.Text(
                            'Facture',
                            style: pw.TextStyle(
                              color: baseColor,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        pw.SizedBox(height:5),

                        pw.Container(
                          padding: const pw.EdgeInsets.only(left: 0,right: 50),

                          child: pw.Text(
                            invoiceType,
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 23,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 13),

                        pw.Container(
                          padding: const pw.EdgeInsets.only(left: 0,right: 50),

                          child: pw.Text(
                            'Date:   ${ extractDate(invCtr.selectedInvoice.verified! ? invCtr.selectedInvoice.timeReturn!:invCtr.selectedInvoice.timeOut!)}',
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        // pw.Container(
                        //   // decoration: pw.BoxDecoration(
                        //   //   borderRadius:
                        //   //   const pw.BorderRadius.all(pw.Radius.circular(2)),
                        //   //   color: accentColor,
                        //   // ),
                        //   padding: const pw.EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 80),
                        //   //alignment: pw.Alignment.centerLeft,
                        //   height: 50,
                        //   child: pw.DefaultTextStyle(
                        //     style: pw.TextStyle(
                        //       color: _accentTextColor,
                        //       fontSize: 12,
                        //     ),
                        //     child: pw.Column(
                        //      // mainAxisAlignment: pw.MainAxisAlignment.start,
                        //       //crossAxisAlignment: pw.CrossAxisAlignment.start,
                        //
                        //       // crossAxisCount: 1,
                        //       // childAspectRatio: 0.6,
                        //       //crossAxisSpacing: 0.6,
                        //       children: [
                        //         //pw.Text('Invoice #   ${invoiceNumber}',style: pw.TextStyle(color: PdfColors.black)),
                        //         //pw.Text(invoiceNumber,style: pw.TextStyle(color: PdfColors.black)),
                        //         pw.Text('Date:          ${extractDate(invCtr.selectedInvoice.timeReturn!)}',style: pw.TextStyle(color: PdfColors.black)),
                        //         //pw.Text(extractDate(invCtr.selectedInvoice.timeReturn!),style: pw.TextStyle(color: PdfColors.black)),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ]
                    )
                  ),

                ],
              ),
            ),
            pw.Expanded(
              child:  pw.Container(
                  alignment: pw.Alignment.topRight,
                  padding: const pw.EdgeInsets.only(bottom: 0, left: 0,right: 20), //height: 93,
                  child: pw.Column(
                      //mainAxisAlignment: pw.MainAxisAlignment.end,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          ' Gajgaji Karim',
                          style: pw.TextStyle(
                              color: baseColor,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 33,
                              fontItalic: pw.Font.courier()
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          '    Vente en Gros Eaux et Boisson Gazeuse',
                          style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 11,
                              fontItalic: pw.Font.courier()
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Divider(color: accentColor,indent: 8),
                        pw.SizedBox(height: 13),

                        _deliveryInfo(context),
                      ]
                  )
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
        child: pw.Column(
            children: [
              pw.RichText(
                  text: pw.TextSpan(
                      text: 'Facture ${ invCtr.selectedInvoice.type! != 'Multiple' ? 'à' : 'de'}: ',
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
            ]
        )
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    List tableHeaders = [
      'Index',
      'Nom du produit',
      'Prix($currency)',
      'Quantité',
      'Totale($currency)'
    ];

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
      )
    );
  }
  pw.Widget _contentFooter(pw.Context context) {
    return pw.Container(
        //padding: const pw.EdgeInsets.only(top: 10, bottom: 4,left: 20,right: 10),

        alignment: pw.Alignment.bottomLeft,
        child: pw.Row(
          // mainAxisAlignment: pw.MainAxisAlignment.end,
           crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Merci pour votre entreprise',
                    style: pw.TextStyle(
                      color: _darkColor,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                    child: pw.Text(
                      'Information de Paiement:',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    paymentInfo,
                    style: const pw.TextStyle(
                      fontSize: 8,
                      lineSpacing: 5,
                      color: _darkColor,
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.DefaultTextStyle(
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: _darkColor,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // pw.Row(
                    //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     pw.Text('Sub Total:'),
                    //     pw.Text(_formatCurrency(_total)),
                    //   ],
                    // ),
                    // pw.SizedBox(height: 5),
                    // pw.Row(
                    //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     pw.Text('Tax:'),
                    //     pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
                    //   ],
                    // ),
                    //pw.Divider(color: accentColor),
                    pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: baseColor,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Totale:'),
                          //pw.Text('${ formatNumberAfterComma2(invCtr.selectedInvoice.verified! ? invCtr.selectedInvoice.returnTotal!:invCtr.selectedInvoice.outTotal!)}'),
                          pw.Text('${  invCtr.outSellTotal}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: accentColor)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# $invoiceNumber',
            drawText: false,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }


}

class Productx {
  const Productx(
    this.sku,
    this.productName,
    this.price,
    this.quantity,
    this.totalSell,
  );

  final String sku;
  final String productName;
  final double price;
  final double totalSell;
  final int quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
        return formatNumberAfterComma2(price);
      case 3:
        return quantity.toString();
      case 4:
        return formatNumberAfterComma2(totalSell);
    }
    return '';
  }
}
