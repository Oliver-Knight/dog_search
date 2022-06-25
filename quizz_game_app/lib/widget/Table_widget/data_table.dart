import 'package:flutter/material.dart';

class QuizDataTable extends StatefulWidget {
  final List<String> colunms;
  const QuizDataTable({ Key? key, required this.colunms }) : super(key: key);

  @override
  State<QuizDataTable> createState() => _QuizDataTableState();
}

class _QuizDataTableState extends State<QuizDataTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [],
      rows: [],
    );
  }
  List<DataColumn> dataColunms(){
    return widget.colunms.map((e) => DataColumn(label: Text(e))).toList();
  }
}