import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(StudentsDataInformation());
}

/// The application that contains datagrid on it.
class StudentsDataInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students Information',
      theme:
      ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      home: JsonDataGrid(),
    );
  }
}

class JsonDataGrid extends StatefulWidget {
  @override
  _JsonDataGridState createState() => _JsonDataGridState();
}

class _JsonDataGridState extends State<JsonDataGrid> {
  late _JsonDataGridSource jsonDataGridSource;
  List<_Product> productlist = [];

  Future generateProductList() async {

    var client = new http.Client();
    try {

     final response = await client.get
        (Uri.parse(
         'http://mansoftonline.com:8080/schooladmin/core/school/listSemesterStudents/13eab9b0-b3f1-4471-a3c7-f2122ae0dd11/c4778e95-eca4-4646-ab2c-3b839dceb045'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Access-Control-Allow-Origin": "*",
            'Accept': '*/*'
          });

      final body = json.decode(response.body);
      final responseObject = body['response'];
     var list = responseObject['data'];

     List<TableRow> dataRows = [];
     for (var stud in list) {
       String studPf = stud['pfNo'].toString();
       String studName = stud['displayName'].toString();
       String studClass = stud['className'].toString();

       _Product prod = _Product();
       prod.className = studClass;
       prod.displayName = studName;
       prod.pfNo = studPf;

       print(prod.displayName);
       productlist.add(prod);

       TableRow row = TableRow(
           children: [
             TableCell(child: Text("S/N")),
             TableCell(child: Text("Name")),
             TableCell(child: Text("Address")),
             TableCell(child: Text("Nation"))
           ]
       );

       dataRows.add(row);
     }

   /*  productlist =
     await list.map<_Product>((json) => _Product.fromJson(json)).toList();*/

     jsonDataGridSource = _JsonDataGridSource(productlist);

    // return productlist;
     Table table =  new Table();



    }on Exception catch(error){
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }

  finally {
  client.close();
  }



    /*print("As");
    var responseCore = await http.get(Uri.parse(
        'https://mansoftonline.com/schooladmin/core/school/listSemesterStudents/13eab9b0-b3f1-4471-a3c7-f2122ae0dd11/c4778e95-eca4-4646-ab2c-3b839dceb045'));
    var responseData = json.decode(responseCore.body).cast<Map<String, dynamic>>();
    print("us");
    var responseParam = responseData['response'];
    print("jk");
    print(responseParam);

    var list = responseParam['data'];
    print(list);
    productlist =
    await list.map<_Product>((json) => _Product.fromJson(json)).toList();
    jsonDataGridSource = _JsonDataGridSource(productlist);
    return productlist;*/
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = ([
      GridColumn(
        columnName: 'pfNo',
        width: 70,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Adm No',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'displayName',
        width: 95,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: Text(
            'Name',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'className',
        width: 95,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Class Name',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      )
    ]);
    return columns;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Data'),
      ),
      body: Container(
          child: FutureBuilder(
              future: generateProductList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? SfDataGrid(
                    source: jsonDataGridSource, columns: getColumns())
                    : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
              })),
    );
  }
}

class _Product {
  factory _Product.fromJson(Map<String, dynamic> json) {
    return _Product(
        pfNo: json['pfNo'],
        displayName: json['displayName'],
        className: json['className']);
  }

  _Product(
      {this.pfNo,
        this.displayName,
        this.className});
  String? pfNo;
  String? displayName;
  String? className;
}

class _JsonDataGridSource extends DataGridSource {
  _JsonDataGridSource(this.productlist) {
    buildDataGridRow();
  }

  List<DataGridRow> dataGridRows = [];
  List<_Product> productlist = [];

  void buildDataGridRow() {
    dataGridRows = productlist.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'pfNo', value: dataGridRow.pfNo),
        DataGridCell<String>(
            columnName: 'displayName', value: dataGridRow.displayName),
        DataGridCell<String>(
            columnName: 'className', value: dataGridRow.className)
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}