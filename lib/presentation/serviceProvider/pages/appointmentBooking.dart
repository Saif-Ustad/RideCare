import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridecare/core/configs/assets/app_images.dart';
import '../../../common/widgets/bottomBar/bottomBar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../widgets/headerSection.dart';
import '../widgets/serviceInfoSection.dart';

class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({super.key});

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  final List<String> images = List.filled(7, AppImages.serviceProvider1);
  String selectedServiceType = "Pick-Up";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController noteController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            HeaderSection(images: images),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const ServiceInfoSection(),
                    Divider(color: AppColors.lightGray, thickness: 1, height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("BOOK A SLOT"),
                          const SizedBox(height: 10),
                          _serviceTypeSelection(),
                          const SizedBox(height: 16),
                          _dateTimeSelection(context),
                          const SizedBox(height: 8),
                          _estimatedDuration(),
                          const SizedBox(height: 16),
                          _noteInputField(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        text: "Continue",
        onPressed: () {
          context.push("/select-vehicle");
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
    );
  }

  Widget _serviceTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Service Type"),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _serviceTypeButton("Pick-Up"),
            const SizedBox(width: 10),
            _serviceTypeButton("Self Service"),
          ],
        ),
      ],
    );
  }

  Widget _serviceTypeButton(String type) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          backgroundColor: selectedServiceType == type ? AppColors.primary : AppColors.lightGray,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => setState(() => selectedServiceType = type),
        child: Text(
          type,
          style: TextStyle(color: selectedServiceType == type ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _dateTimeSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Date and Time"),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(child: _datePicker(context)),
            const SizedBox(width: 12),
            Expanded(child: _timePicker(context)),
          ],
        ),
      ],
    );
  }

  Widget _datePicker(BuildContext context) {
    return _inputBox(
      text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      icon: Icons.calendar_today,
      onTap: () => _selectDate(context),
    );
  }

  Widget _timePicker(BuildContext context) {
    return _inputBox(
      text: selectedTime.format(context),
      icon: Icons.access_time,
      onTap: () => _selectTime(context),
    );
  }

  Widget _inputBox({required String text, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            Icon(icon, size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _estimatedDuration() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(width: 3, height: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text("Estimated Service Duration: 1.5 hours", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkGrey)),
        ],
      ),
    );
  }

  Widget _noteInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Note to Service Provider"),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: noteController,
            style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
            decoration: InputDecoration(hintText: "Enter Here", border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
          ),
        ),
      ],
    );
  }
}
