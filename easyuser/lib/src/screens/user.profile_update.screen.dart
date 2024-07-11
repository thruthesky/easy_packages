import 'package:date_picker_v2/date_picker.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

// there might some scenario that the user want to Use a unique name to display
// but still we want to keep the user real name for example in github they using
// user name as display name but keeping thier real name ex: dev123 (John Smith)
class UserProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/UserProfileUpdate';
  const UserProfileUpdateScreen({super.key});

  @override
  State<UserProfileUpdateScreen> createState() =>
      _UserProfileUpdateScreenState();
}

class _UserProfileUpdateScreenState extends State<UserProfileUpdateScreen> {
  final displayNameController = TextEditingController();
  final nameController = TextEditingController();
  String? gender;
  int? birthYear;
  int? birthMonth;
  int? birthDay;
  @override
  void initState() {
    super.initState();

    prepareData();
  }

  // prepare data add more condition if needed
  void prepareData() {
    displayNameController.text = my?.displayName ?? '';
    nameController.text = my?.name ?? '';
    birthYear = my?.birthYear ?? DateTime.now().year;
    birthMonth = my?.birthMonth ?? DateTime.now().month;
    birthDay = my?.birthDay ?? DateTime.now().day;
    gender = my?.gender;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    displayNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: UserUpdateAvatar(
                    size: 140,
                    radius: 75,
                    delete: true,
                  ),
                ),
                TextField(
                    decoration: const InputDecoration(
                      label: Text('displayName'),
                    ),
                    controller: displayNameController),
                TextField(
                  decoration: const InputDecoration(label: Text('name')),
                  controller: nameController,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    bottom: 2,
                  ),
                  child: Text(
                    'gender',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'M',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'F',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DatePicker(
                  endYear: DateTime.now().year,
                  beginYear: DateTime.now().year - 100,
                  ascendingYear: false,
                  initialDate: (
                    year: birthYear,
                    month: birthMonth,
                    day: birthDay
                  ),
                  onChanged: (year, month, day) {
                    birthYear = year;
                    birthMonth = month;
                    birthDay = day;
                    setState(() {});
                  },
                  labelYear: '   ${'year'}',
                  labelMonth: ' ${'month'}',
                  labelDay: ' ${'day'}',
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      my?.update(
                        name: nameController.text,
                        displayName: displayNameController.text,
                        birthYear: birthYear,
                        birthMonth: birthMonth,
                        birthDay: birthDay,
                        gender: gender,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          showCloseIcon: true,
                          content: Text('Profile Updated Successfully'),
                        ),
                      );
                    },
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
