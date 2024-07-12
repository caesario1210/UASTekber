import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  List<dynamic> mahasiswa = [];
  final dio = Dio();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieve();
  }

  void save() async {
    await supabase.from('mahasiswa').insert({
      'nim': nimController.text, // Ensure npp is int
      'nama': namaController.text,
      'jurusan': jurusanController.text,
    });
    nimController.clear();
    namaController.clear();
    jurusanController.clear();
    retrieve();
  }

  void retrieve() async {
    final data = await supabase.from('mahasiswa').select('*');
    setState(() {
      this.mahasiswa = data;
    });
  }

  void deleteRow(id) async {
    await supabase.from('mahasiswa').delete().eq('nim', id);
    retrieve();
  }
void editRow(id, BuildContext context) async {
  // Retrieve existing data based on the id
  final existingData = await supabase.from('mahasiswa').select('*').eq('nim', id).single();

  // Set the retrieved data to controllers for editing
  nimController.text = existingData['nim'].toString();
  namaController.text = existingData['nama'].toString();
  jurusanController.text = existingData['jurusan'].toString();

  // Show a dialog or perform any UI action to indicate editing mode
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Mahasiswa'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nimController,
              decoration: InputDecoration(labelText: 'NIM'),
            ),
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: jurusanController,
              decoration: InputDecoration(labelText: 'Jurusan'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            // Perform update operation with updated values
            await supabase.from('mahasiswa').update({
              'nim': nimController.text,
              'nama': namaController.text,
              'jurusan': jurusanController.text,
            }).eq('nim', id);

            // Clear controllers after update
            nimController.clear();
            namaController.clear();
            jurusanController.clear();

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
        title: Text('Input Mahasiswa'),
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
            TextField(
              controller: nimController,
              decoration: InputDecoration(
                labelText: "N I M",
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
              controller: jurusanController,
              decoration: InputDecoration(
                labelText: "Jurusan",
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
                        label: Text('NIM'),
                      ),
                       
                      DataColumn(
                        label: Text('Nama'),
                      ),
                     DataColumn(
                        label: Text('Jurusan'),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: mahasiswa
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
                              Text(e['nim'].toString()),
                            ),
                              DataCell(
                              Text(e['nama'].toString()),
                            ),
                              DataCell(
                              Text(e['jurusan'].toString()),
                            ),
                              DataCell(
                                Row(
                                  children: [
                                      IconButton(
                                      onPressed: () {
                                        editRow(e['nim'], context); // Memanggil editRow dengan context yang valid
                                      },
                                      icon: Icon(Icons.edit),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        deleteRow(e['nim']);
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
