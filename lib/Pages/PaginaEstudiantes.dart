import 'package:flutter/material.dart';

class TablaEstudiantes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TablaEstudiantesState();
}

class TablaEstudiantesState extends State<TablaEstudiantes> {
  // Lista de estudiantes (simulada, puede reemplazar con datos reales)
  final List<Map<String, String>> estudiantes = [
    {
      "id": "1",
      "nombre": "Juan Pérez",
      "fechaNacimiento": "2000-04-01",
      "matricula": "M001",
      "grado": "Licenciatura",
      "fechaIngreso": "2019-01-15",
    },
    {
      "id": "2",
      "nombre": "Ana Gómez",
      "fechaNacimiento": "1998-08-22",
      "matricula": "M002",
      "grado": "Maestría",
      "fechaIngreso": "2020-02-20",
    },
    {
      "id": "3",
      "nombre": "Carlos López",
      "fechaNacimiento": "2001-02-14",
      "matricula": "M003",
      "grado": "Licenciatura",
      "fechaIngreso": "2018-09-10",
    },
    // Agregar más estudiantes si es necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tabla de Estudiantes"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la página
              Text(
                "Listado de Estudiantes",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              // Tabla de estudiantes
              DataTable(
                columns: [
                  DataColumn(label: Text("ID Estudiante")),
                  DataColumn(label: Text("Nombre Completo")),
                  DataColumn(label: Text("Fecha Nacimiento")),
                  DataColumn(label: Text("Matrícula")),
                  DataColumn(label: Text("Grado Académico")),
                  DataColumn(label: Text("Fecha Ingreso")),
                ],
                rows: estudiantes
                    .map(
                      (estudiante) => DataRow(
                    cells: [
                      DataCell(Text(estudiante["id"]!)),
                      DataCell(Text(estudiante["nombre"]!)),
                      DataCell(Text(estudiante["fechaNacimiento"]!)),
                      DataCell(Text(estudiante["matricula"]!)),
                      DataCell(Text(estudiante["grado"]!)),
                      DataCell(Text(estudiante["fechaIngreso"]!)),
                    ],
                  ),
                )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
