//Cpmpo das Variaveis do BD
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String conecTable = "conecTable";
const String idColumn = "idColumn";
const String codColumn = "codColumn";
const String nfeColumn = "nfeColumn";
const String imgColumn = "imgColumn";

// Inicio da Classe Conexão DB
class ConexaoDb {
  static final ConexaoDb _instacie = ConexaoDb.internal();
  factory ConexaoDb() => _instacie;
  ConexaoDb.internal();
  bool _createdDatabase = false;

  Database? _db;

  Future<Database?> get db async {
    if (_createdDatabase) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "conexao_oficial");
    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $conecTable($idColumn INTEGER PRIMARY KEY, $codColumn TEXT, $nfeColumn TEXT, $imgColumn TEXT)",
      );
      _createdDatabase = true;
    });
  }

  //Salvar
  Future<LeituraNf> saveLeituraNf(LeituraNf leituraNf) async {
    Database? dbConect = await db;
    leituraNf.id = await dbConect?.insert(conecTable, leituraNf.toMap());
    return leituraNf;
  }

  //Deletar
  Future<int> deleteLeituraNf(int id) async {
    Database? dbConect = await db;
    return await dbConect!.delete(
      conecTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  //Atualizar
  Future<int> updateLeituraNf(LeituraNf leituraNf) async {
    Database? dbConect = await db;
    return await dbConect!.update(
      conecTable,
      leituraNf.toMap(),
      where: "$idColumn = ?",
      whereArgs: [leituraNf.id],
    );
  }

  //Selecionar todos da Lista
  Future<List<LeituraNf>> getAllLeituraNf() async {
    Database? dbConect = await db;
    List listMap = await dbConect!.rawQuery("SELECT * FROM $conecTable");
    List<LeituraNf> listLeituraNf = [];
    for (Map m in listMap) {
      listLeituraNf.add(LeituraNf.forMap(m));
    }
    return listLeituraNf;
  }

  //Pega o Número do Código Barras da lista
  Future<int?> getNumero() async {
    Database? dbConect = await db;
    return Sqflite.firstIntValue(
        await dbConect!.rawQuery("SELECT * FROM $conecTable"));
  }

  //Pega as informações da lista
  Future<LeituraNf?> getLeituraNf(int id) async {
    Database? dbConect = await db;
    List<Map> maps = await dbConect!.query(conecTable,
        columns: [
          idColumn,
          codColumn,
          nfeColumn,
          imgColumn,
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    //Se não estiver vazio retorne a primeira lista(Card), Se não encontrar retorna Nullo.
    if (maps.isNotEmpty) {
      return LeituraNf.forMap(maps.first);
    } else {
      return null;
    }
  }

  //Fecha o Bancode Dados
  Future close() async {
    Database? dbConect = await db;
    dbConect!.close();
  }
}

class LeituraNf {
  int? id;
  String? codigo;
  String? nfe;
  String? img;

  LeituraNf();

  LeituraNf.forMap(Map map) {
    id = map[idColumn];
    codigo = map[codColumn];
    nfe = map[nfeColumn];
    img = map[imgColumn];
  }

  set text(String text) {}

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      codColumn: codigo,
      nfeColumn: nfe,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "LeituraNf(id: $id, codigo: $codigo, nfe_serie: $nfeColumn, img: $img )";
  }
}//Fim da Classe LeituraNf