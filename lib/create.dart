import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostFormScreen extends StatefulWidget {
  final DocumentSnapshot? post;

  PostFormScreen({this.post});

  @override
  _PostFormScreenState createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? scheduledDate;
  String? selectedSocialMedia;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      titleController.text = widget.post!['title'];
      descriptionController.text = widget.post!['description'];
      scheduledDate = DateFormat('dd MMMM yyyy, hh:mm:ss a').parse(widget.post!['scheduledDate']);

      selectedSocialMedia = widget.post!['redSocial'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? "Crear Publicación" : "Editar Publicación"),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Título", titleController),
              SizedBox(height: 16),
              _buildTextField("Descripción", descriptionController, maxLines: 3),
              SizedBox(height: 16),
              _buildDateTimePicker(),
              SizedBox(height: 16),
              _buildDropdown(),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () => _savePost(context),
                  child: Text("Guardar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.deepPurple.shade100.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.all(16),
      ),
      maxLines: maxLines,
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildDateTimePicker() {
    return GestureDetector(
      onTap: _selectDateTime,
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Fecha y Hora Programada',
            labelStyle: TextStyle(color: Colors.white70),
            hintText: scheduledDate != null
                ? DateFormat('dd MMMM yyyy, hh:mm:ss a').format(scheduledDate!)
                : 'Seleccionar Fecha y Hora',
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.deepPurple.shade100.withOpacity(0.2),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(16),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedSocialMedia,
      onChanged: (String? newValue) {
        setState(() {
          selectedSocialMedia = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'Red Social',
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.deepPurple.shade100.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: <String>['Facebook', 'WhatsApp', 'Instagram', 'TikTok']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      dropdownColor: Colors.deepPurple,
    );
  }

  Future<void> _selectDateTime() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: scheduledDate ?? now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(scheduledDate ?? now),
      );

      if (pickedTime != null) {
        scheduledDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {});
      }
    }
  }

  void _savePost(BuildContext context) async {
    final title = titleController.text;
    final description = descriptionController.text;
    String formattedDate = DateFormat('dd MMMM yyyy, hh:mm:ss a').format(scheduledDate ?? DateTime.now());

    if (widget.post == null) {
      await FirebaseFirestore.instance.collection('posts').add({
        'title': title,
        'description': description,
        'scheduledDate': formattedDate,
        'redSocial': selectedSocialMedia,
      });
    } else {
      await FirebaseFirestore.instance.collection('posts').doc(widget.post!.id).update({
        'title': title,
        'description': description,
        'scheduledDate': formattedDate,
        'redSocial': selectedSocialMedia,
      });
    }
    Navigator.pop(context);
  }
}
