import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Plans {
  int id = 0;
  String home_country = "";
  String destination_city = "";
  String budget = "";
  String plan_possible = "";
  Plans(
      {required this.id,
      required this.home_country,
      required this.destination_city,
      required this.budget,
      required this.plan_possible});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'home_country': home_country,
      'destination_city': destination_city,
      'budget': budget,
      'plan_possible': plan_possible
    };
  }

  factory Plans.fromMap(Map<String, dynamic> map) {
    return Plans(
        id: map['id'],
        home_country: map['home_country'],
        destination_city: map['destination_city'],
        budget: map['budget'],
        plan_possible: map['plan_possible']);
  }
}

class DBHelper {
  static const String _databaseName = 'plans.db';
  static const int _databaseVersion = 1;
  String appDocumentsDirectory = '';
  DBHelper._(); // private constructor (can't be called from outside)

  static final DBHelper _singleton = DBHelper._();

  factory DBHelper() => _singleton;

  Database? _database;

  Future<Database> get db async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();

    appDocumentsDirectory = directory.path;
    final dbPath = path.join(appDocumentsDirectory, _databaseName);

    // Open the database
    final db = await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE plans(
              id INTEGER PRIMARY KEY,
              home_country TEXT,
              destination_city TEXT,
              budget TEXT,
              plan_possible TEXT
            )
          ''');
      },
    );

    return db;
  }

  // Insert a deck
  Future<int> insertPlans(Plans plan) async {
    final db = await this.db;
    final id = await db.insert(
      'plans',
      plan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Plans>> getPlans() async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps =
        await db.query('plans', orderBy: 'id');
    return List.generate(maps.length, (i) {
      return Plans.fromMap(maps[i]);
    });
  }

  Future<int> getPlansCount() async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query('plans');
    return maps.length;
  }
}
