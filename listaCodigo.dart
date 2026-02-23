import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_leitor_codigo/db_conexao.dart';
import 'package:flutter_app_leitor_codigo/salvaCodigo.dart';
//import 'package:path/path.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  //Conexão BD
  ConexaoDb conexao = ConexaoDb();
  //Adição da Lista
  List<LeituraNf> leitor = [];

//Iniciando   a lista pegando todas da lista
  @override
  void initState() {
    super.initState();
    _getAllLeituraNf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "img/logo_ger.png",
          width: 100,
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLista();
        },
        // ignore: sort_child_properties_last
        child: const Icon(Icons.add),
        //backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: leitor.length,
        itemBuilder: (context, index) {
          return _CodigoCard(context, index);
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _CodigoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder(
                future: getLeituraImage(leitor[index].img),
                // ignore: non_constant_identifier_names
                builder: (Context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      final img = snapshot.data as ImageProvider<Object>;
                      return Container(
                        alignment: Alignment.bottomCenter,
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: img,
                            )),
                      );
                    } else {
                      return const SizedBox(
                        width: 80,
                        height: 80,
                      );
                    }
                  } else {
                    return const SizedBox(
                      width: 80,
                      height: 80,
                    );
                  }
                },
              ),
              //
              //Inicio Text Codico e data atual
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Text Data Atual
                    // Text(
                    //   leitor[index].dataAtual ?? "",
                    //   style: const TextStyle(
                    //     fontSize: 10,
                    //   ),
                    // ),
                    //Text Código de barras
                    Text(
                      leitor[index].nfe ?? "",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      leitor[index].codigo ?? "",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  Future<ImageProvider<Object>> getLeituraImage(String? path) async {
    if (path != null) {
      FileImage img = FileImage(File(path));
      try {
        await img.file.readAsBytes();
        return FileImage(File(path));
      } catch (e) {
        return const AssetImage("img/barcodeimg.png");
      }
    } else {
      return const AssetImage("img/barcodeimg.png");
    }
  }

//Fyunção para chamar a lista através das telas
  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          conexao.deleteLeituraNf(leitor[index].id!);
                          setState(() {
                            leitor.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          "Excluir",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _showLista({LeituraNf? leitor}) async {
    final recCodigo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalvaCodigo(
          leitor: leitor,
        ),
      ),
    );
    if (recCodigo != null) {
      if (leitor != null) {
        await conexao.updateLeituraNf(recCodigo);
      } else {
        await conexao.saveLeituraNf(recCodigo);
      }
      _getAllLeituraNf();
    }
  }

//funçao que carrega todos a Lista
  void _getAllLeituraNf() {
    conexao.getAllLeituraNf().then((list) {
      setState(() {
        leitor = list;
      });
    });
  }
}
//ORIGEM
