import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isRegistering = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentNumController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  String? _selectedCourse;
  String? _selectedYearSem;
  String? _selectedSection;
  String? _selectedSex;

  void _onStudentNumberChanged(String value) {
    if (value.isNotEmpty) {
      _emailController.text = '$value@spcba.edu.ph';
    } else {
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.spcbaGreen,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book_rounded, size: 64, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'ReviewSPC',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  _isRegistering ? 'Create Account' : 'AI-Powered Academic Reviewer\nSan Pedro College of Business Administration',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      if (_isRegistering) ...[
                        _buildTextField(_fullNameController, 'Full Name'),
                        const SizedBox(height: 12),
                      ],

                      TextField(
                        controller: _studentNumController,
                        keyboardType: TextInputType.number,
                        onChanged: _onStudentNumberChanged,
                        decoration: InputDecoration(
                          hintText: 'Student Number (e.g. 23100866)',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildTextField(_emailController, 'SPCBA Email', readOnly: true),
                      const SizedBox(height: 12),

                      if (_isRegistering) ...[
                        _buildDropdown('Select your course', ['BSIT', 'BSBA', 'BSA', 'BSHM', 'BSED'], _selectedCourse, (val) => setState(() => _selectedCourse = val)),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          'Select your year level with semester',
                          [
                            '1st Year - 1st Semester',
                            '1st Year - 2nd Semester',
                            '2nd Year - 1st Semester',
                            '2nd Year - 2nd Semester',
                            '3rd Year - 1st Semester',
                            '3rd Year - 2nd Semester',
                            '4th Year - 1st Semester',
                            '4th Year - 2nd Semester',
                          ],
                          _selectedYearSem,
                          (val) => setState(() => _selectedYearSem = val),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown('Select your section', ['Section 501', 'Section 502', 'Section 503'], _selectedSection, (val) => setState(() => _selectedSection = val)),
                        const SizedBox(height: 12),
                        _buildDropdown('Select your sex', ['Male', 'Female', 'Prefer not to say'], _selectedSex, (val) => setState(() => _selectedSex = val)),
                        const SizedBox(height: 12),
                      ],

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.spcbaGreen,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          String passedName = _fullNameController.text.trim();
                          if (passedName.isEmpty) passedName = 'Rein';

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardView(
                                userName: passedName,
                                studentStatus: 'Regular',
                              ),
                            ),
                          );
                        },
                        child: Text(_isRegistering ? 'Create Account' : 'Login', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => setState(() => _isRegistering = !_isRegistering),
                  child: Text(
                    _isRegistering ? 'Already have an account? Login' : "Don't have an account? Create Account",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const Text('Exclusively for SPCBA students', style: TextStyle(color: Colors.white60, fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: readOnly ? Colors.grey.shade200 : Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? currentValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
    );
  }
}