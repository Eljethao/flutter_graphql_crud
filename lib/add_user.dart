import 'package:flutter/material.dart';
import 'package:flutter_graphql_crud/home.dart';
import 'package:flutter_graphql_crud/services/create_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  DateTime selectedDate = DateTime.now();
  DateTime dateTime = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController birthdayText = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();

  String gender = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
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
      ),
    );
  }

  Container saveButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      child: ElevatedButton(
        onPressed: () => _saveData(),
        child: Text('Save'),
      ),
    );
  }

  _saveData() async {
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

      var res = await createUser(data);
      if (res['id'] != null || res['id'] == '') {
        Fluttertoast.showToast(
            msg: "Create User Success!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      } else {
        debugPrint("cannot createUser");
      }
    } catch (e) {
      debugPrint("e ==>>> $e");
    }
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
}
