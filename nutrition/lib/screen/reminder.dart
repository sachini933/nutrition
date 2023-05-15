import 'package:flutter/material.dart';
import 'package:nutrition/controllers/notification_controller.dart';
import 'package:nutrition/utils/alert_helper.dart';
import 'package:nutrition/utils/util_functions.dart';

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  bool _isEnabled = false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _description = '';

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (selectedTime != null && selectedTime != _selectedTime) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Create a reminder'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Enabled'),
                value: _isEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
              ),
              ListTile(
                title: const Text('Time'),
                subtitle: Text('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
                onTap: () => _selectTime(context),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_isEnabled) {
                    // Schedule the reminder
                    final now = DateTime.now();
                    final scheduledTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                    final difference = scheduledTime.difference(now);
                    final seconds = difference.inSeconds;

                    await NotificationController().scheduleNotification(scheduledTime, _description).then((value) {
                      AlertHelper.showSnackBar(context, "Reminder scheduleded");
                      UtilFunctions.goBack(context);
                    });

                    // You can use the seconds value to schedule the reminder using a package like flutter_local_notifications
                  } else {
                    // Remove the scheduled reminder if it exists
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
