import 'package:flutter/material.dart';
import 'package:flutter_graphql_crud/home.dart';
import 'package:flutter_graphql_crud/services/update_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EditUser extends StatefulWidget {
  var data;
  EditUser({super.key, required this.data});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  DateTime selectedDate = DateTime.now();
  DateTime dateTime = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController birthdayText = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();

  String gender = '';
  var data = {};
  String id = '';

  @override
  void initState() {
    super.initState();
    data = widget.data;
    getUserData();
  }

  getUserData() {
    setState(() {
      firstNameController.text = data['firstName'];
      lastNameController.text = data['lastName'];
      birthdayText.text =
          formatter.format(DateTime.tryParse(data['birthday']) as DateTime);
      gender = data['gender'];
      id = data['id'];
    });
  }

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;
    TimeOfDay selectedTime = TimeOfDay.now();
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      birthdayText.text = formatter.format(dateTime);
    });
    debugPrint("dateTime: $dateTime");
  }

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      debugPrint("selectedDate: $selectedDate");
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  _editData() async {
    try {
      debugPrint("firstName: ${firstNameController.text}");
      debugPrint("lastName: ${lastNameController.text}");
      debugPrint("birthday: ${birthdayText.text}");
      debugPrint("gender: ${gender}");

      var data = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'birthday': birthdayText.text,
        'gender': gender
      };

      var _res = await updateUser(data, id);
      if (_res['id'] != null || _res['id'] == '') {
        Fluttertoast.showToast(
            msg: "Update User Success!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
            (route) => false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              firstNameText(context),
              const SizedBox(height: 16),
              lastNameText(context),
              const SizedBox(height: 16),
              chooseDateTime(context),
              const SizedBox(height: 20),
              genderText(),
              genderRadio(),
              const SizedBox(height: 40),
              saveButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Container saveButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      child: ElevatedButton(
        onPressed: () => _editData(),
        child: Text('Edit'),
      ),
    );
  }

  Widget genderRadio() {
    return Padding(
      padding: EdgeInsets.only(left: 30),
      child: Row(
        children: [
          Radio(
              value: "MALE",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              }),
          Text("Male"),
          Radio(
              value: "FEMALE",
              groupValue: gender,
              hoverColor: Colors.red,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              }),
          Text(
            "Female",
          ),
        ],
      ),
    );
  }

  Padding genderText() {
    return Padding(
      padding: EdgeInsets.only(left: 30),
      child: Row(
        children: [
          Text('Gender'),
        ],
      ),
    );
  }

  InkWell chooseDateTime(BuildContext context) {
    return InkWell(
      onTap: () => _selectDateTime(context),
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width * 0.8,
        child: IgnorePointer(
          child: TextFormField(
            controller: birthdayText,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                label: Text('Birthday'),
                suffixIcon: Icon(Icons.calendar_month)),
          ),
        ),
      ),
    );
  }

  Container lastNameText(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: lastNameController,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            label: Text('LastName')),
      ),
    );
  }

  Container firstNameText(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: firstNameController,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            label: Text('FirstName')),
      ),
    );
  }
}
