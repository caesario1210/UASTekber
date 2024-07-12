import 'package:flutter/material.dart';
import 'package:input_mahasiswa/dosen.dart';
import 'package:input_mahasiswa/home.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_rounded,
                size: 200,
                color: Colors.white,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Home(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Adjust button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Adjust button border radius
                  ),
                  backgroundColor: Color.fromARGB(255, 3, 36, 255) ,// Button background color
                ),
                child: Text(
                  "Input Mahasiswa",
                  style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white), 
                  // Adjust button text size
                ),

              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Dosen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Adjust button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Adjust button border radius
                  ),
                  backgroundColor: Color.fromARGB(255, 3, 36, 255) ,
                ),
                child: Text(
                  "Input Dosen",
                  style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold,
                    color: Colors.white), // Adjust button text size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
