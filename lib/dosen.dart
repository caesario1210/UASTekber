import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class Dosen extends StatefulWidget {
  const Dosen({super.key});

  @override
  State<Dosen> createState() => _DosenState();
}

class _DosenState extends State<Dosen> {
  TextEditingController nppController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController matkulController = TextEditingController();
  List<dynamic> dosen = [];
  final dio = Dio();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieve();
  }

  void save() async {
    await supabase.from('dosen').insert({
      'npp': int.parse(nppController.text), // Ensure npp is int
      'nama': namaController.text,
      'matkul': matkulController.text,
    });
    nppController.clear();
    namaController.clear();
    matkulController.clear();
    retrieve();
  }

  void retrieve() async {
    final data = await supabase.from('dosen').select('*');
    setState(() {
      this.dosen = data;
    });
  }

  void deleteRow(id) async {
    await supabase.from('dosen').delete().eq('npp', id);
    retrieve();
  }

  void editRow(id, BuildContext context) async {
  // Retrieve existing data based on the id
  final existingData = await supabase.from('dosen').select('*').eq('npp', id).single();

  // Set the retrieved data to controllers for editing
  nppController.text = existingData['npp'].toString();
  namaController.text = existingData['nama'].toString();
  matkulController.text = existingData['matkul'].toString();

  // Show a dialog or perform any UI action to indicate editing mode
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Dosen'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nppController,
              decoration: InputDecoration(labelText: 'NPP'),
            ),
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: matkulController,
              decoration: InputDecoration(labelText: 'Mata Kuliah'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            // Perform update operation with updated values
            await supabase.from('dosen').update({
              'npp': nppController.text,
              'nama': namaController.text,
              'matkul': matkulController.text,
            }).eq('npp', id);

            // Clear controllers after update
            nppController.clear();
            namaController.clear();
            matkulController.clear();

            // Retrieve updated data
            retrieve();

            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Simpan'),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input dosen'),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 153, 255), Color.fromARGB(147, 0, 15, 153)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Form input fields
            TextField(
              controller: nppController,
              decoration: InputDecoration(
                labelText: "N P P",
                prefixIcon: Icon(Icons.quick_contacts_mail_rounded ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),

            ),
            SizedBox(height: 10),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: "Nama",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: matkulController,
              decoration: InputDecoration(
                labelText: "Mata Kuliah",
                prefixIcon: Icon(Icons.book),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromARGB(255, 3, 36, 255) ,
              ),
              child: Text(
                "Simpan",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                  border: TableBorder.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                    columns: [
                      DataColumn(
                        label: Text('NPP'),
                      ),
                       
                      DataColumn(
                        label: Text('Nama'),
                      ),
                     DataColumn(
                        label: Text('Mata Kuliah'),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: dosen
                        .map(
                          (e) => DataRow(
                            color: MaterialStateColor.resolveWith(
                            (states) {
                              // Set the color for the DataRow here
                              return Colors.grey.shade100; // Example color
                            },
                          ),
                            cells: [
                              DataCell(
                              Text(e['npp'].toString()),
                            ),
                              DataCell(
                              Text(e['nama'].toString()),
                            ),
                              DataCell(
                              Text(e['matkul'].toString()),
                            ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                    onPressed: () {
                                      editRow(e['npp'], context); // Memanggil editRow dengan context yang valid
                                    },
                                    icon: Icon(Icons.edit),
                                  ),

                                    IconButton(
                                      onPressed: () {
                                        deleteRow(e['npp']);
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}