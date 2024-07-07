import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Жауаптар'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('responses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final responses = snapshot.data!.docs;
          int responseCount = responses.length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Response Count: $responseCount', style: TextStyle(fontSize: 20)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: responses.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data = responses[index].data() as Map<String, dynamic>;
                    final String docId = responses[index].id;

                    // Access createdAt timestamp and convert it to DateTime
                    Timestamp createdAtTimestamp = data['createdAt'];
                    DateTime createdAt = createdAtTimestamp.toDate();

                    // Format createdAt date to YYYY-MM-DD
                    String createdAtFormatted = DateFormat('yyyy-MM-dd').format(createdAt);

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(data['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Тілектер: ${data['wishes'] ?? '-'}'),
                            Text('Қатысу: ${data['participation']}'),
                            Text('Жіберген уақыты: $createdAtFormatted'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            FirebaseFirestore.instance.collection('responses').doc(docId).delete();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
