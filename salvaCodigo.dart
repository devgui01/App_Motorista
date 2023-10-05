// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_leitor_codigo/db_conexao.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SalvaCodigo extends StatefulWidget {
  const SalvaCodigo({super.key, this.leitor});

  final LeituraNf? leitor;

  @override
  State<SalvaCodigo> createState() => _SalvaCodigoState();
}

class _SalvaCodigoState extends State<SalvaCodigo> {
  // ignore: unused_field
  LeituraNf? _editedCodigo;

  // ignore: unused_field
  final _dataContoller = TextEditingController();
  final _codigoContoller = TextEditingController();
  final _codigoFocus = FocusNode();
  final nfeController = TextEditingController();

  DateTime dataAtual = DateTime.now();

  String scanBarcodeResult = '';
  String scanBarcodeImp = '';

  @override
  void initState() {
    // TODO: Controladores
    super.initState();
    if (widget.leitor == null) {
      _editedCodigo = LeituraNf();
    } else {
      _editedCodigo = LeituraNf.forMap(widget.leitor!.toMap());
      _codigoContoller.text = _editedCodigo!.codigo!;
      nfeController.text = _editedCodigo!.nfe!;
    }
  }

  get controller => null;

  void Shownumeronfe() async {
    var varscan = scanBarcodeResult; //scanBarcodeResult;
    varscan.split('');

    int valorcodigo1 = int.tryParse(varscan[28]) ?? 0;
    int valorcodigo2 = int.tryParse(varscan[29]) ?? 0;
    int valorcodigo3 = int.tryParse(varscan[30]) ?? 0;
    int valorcodigo4 = int.tryParse(varscan[31]) ?? 0;
    int valorcodigo5 = int.tryParse(varscan[32]) ?? 0;
    int valorcodigo6 = int.tryParse(varscan[33]) ?? 0;

    String strings1 = "$valorcodigo1";
    String strings2 = "$valorcodigo2";
    String strings3 = "$valorcodigo3";
    String strings4 = "$valorcodigo4";
    String strings5 = "$valorcodigo5";
    String strings6 = "$valorcodigo6";

    @override
    String Numnfe() {
      return strings1 +
          strings2 +
          strings3 +
          strings4 +
          strings5 +
          strings6.toString();
    }

    scanBarcodeImp = Numnfe();
  }

  void scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#0097A7", "cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = "Falha ao obter a versão da plataforma";
    }

    setState(() {
      scanBarcodeResult = barcodeScanRes;
    });
  } //Fim

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Código"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ignore: unnecessary_null_comparison
          if (_editedCodigo!.codigo! != null &&
              _editedCodigo!.codigo!.isNotEmpty &&
              _editedCodigo!.nfe! != null &&
              _editedCodigo!.nfe!.isNotEmpty) {
            Navigator.pop(context, _editedCodigo);
          } else {
            FocusScope.of(context).requestFocus(_codigoFocus);
          }
        },

        // ignore: sort_child_properties_last
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      style: BorderStyle.none,
                      color: Colors.black26,
                    ),
                    top: BorderSide(
                      style: BorderStyle.none,
                      color: Colors.black26,
                    ),
                    left: BorderSide(
                      style: BorderStyle.none,
                      color: Colors.black26,
                    ),
                    right: BorderSide(
                      style: BorderStyle.none,
                      color: Colors.black26,
                    ),
                  ),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: _editedCodigo!.img != null
                        ? FileImage(File(_editedCodigo!.img!))
                        : const AssetImage("img/barcodephot2.png")
                            as ImageProvider,
                  ),
                ),
              ),
              onTap: () {
                ImagePicker()
                    .pickImage(source: ImageSource.camera)
                    .then((file) {
                  if (file == null) {
                    return;
                  }
                  setState(() {
                    _editedCodigo!.img = file.path;
                  });
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    DateFormat(" 'Data:' dd/MM/yyyy").format(dataAtual),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Chave: $scanBarcodeResult',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "NF'e: $scanBarcodeImp",
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: scanBarcodeResult));
                    },
                    icon: Icon(Icons.copy),
                    label: Text("Copiar Chave"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25, width: 20),
            SizedBox(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: scanBarcodeImp));
                      },
                      icon: Icon(Icons.copy),
                      label: Text("Copiar Nf'e    "),
                    ),
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: null,
              autofocus: true,
              controller: _codigoContoller,
              focusNode: _codigoFocus,
              decoration: InputDecoration(labelText: "Chave:"),
              onChanged: (text) {
                setState(() {
                  _editedCodigo!.codigo = text;
                  Shownumeronfe();
                });
              },
            ),
            TextField(
              maxLines: null,
              controller: nfeController,
              decoration: InputDecoration(labelText: "NF'e:"),
              onChanged: (text) {
                setState(() {
                  _editedCodigo!.nfe = text;
                });
              },
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
              onPressed: scanBarcodeNormal,
              icon: Icon(Icons.barcode_reader),
              label: const Text("Iniciar Leitura"),
            ),
          ],
        ),
      ),
    );
  }

//
}
//ORIGEM
