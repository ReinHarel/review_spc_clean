import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isSignUp = false;

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  // Dropdown / Selection states
  String _selectedYearLevel = '1st Year';
  String _selectedSex = 'Male';
  String _studentStatus = 'Regular'; // 'Regular' or 'Irregular'
  String _selectedCourse = 'BSIT';

  final List<String> _yearLevels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];
  final List<String> _sexOptions = ['Male', 'Female', 'Prefer not to say'];
  final List<String> _courses = ['BSIT', 'BSBA', 'BSCpE', 'BSA', 'BSTM'];

  void _handleSubmit() {
    final String displayName = _isSignUp
        ? (_nameController.text.isNotEmpty ? _nameController.text : 'Student')
        : 'Rein';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardView(
          userName: displayName,
          isGuest: false,
          studentStatus: _isSignUp ? _studentStatus : 'Regular',
        ),
      ),
    );
  }

  void _handleGuestLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardView(
          userName: 'Guest User',
          isGuest: true,
          studentStatus: 'Guest',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Logo
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.spcbaGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 56,
                      color: AppColors.spcbaGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ReviewSPC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.spcbaGreen,
                  ),
                ),
                Text(
                  _isSignUp
                      ? 'Create your SPCian Student Profile'
                      : 'Welcome back, SPCian!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 28),

                // ==================== SIGN UP SPECIFIC FIELDS ====================
                if (_isSignUp) ...[
                  // Full Name
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Course & Year Level Row
                  Row(
                    children: [
                      // Course Dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCourse,
                          decoration: InputDecoration(
                            labelText: 'Course',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: _courses.map((course) {
                            return DropdownMenuItem(
                              value: course,
                              child: Text(course),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCourse = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Year Level Dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedYearLevel,
                          decoration: InputDecoration(
                            labelText: 'Year Level',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: _yearLevels.map((year) {
                            return DropdownMenuItem(
                              value: year,
                              child: Text(year),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedYearLevel = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Student Status (Modern Segmented Button)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Student Classification:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'Regular',
                              label: Text('Regular'),
                            ),
                            ButtonSegment(
                              value: 'Irregular',
                              label: Text('Irregular'),
                            ),
                          ],
                          selected: {_studentStatus},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              _studentStatus = newSelection.first;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Sex Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSex,
                    decoration: InputDecoration(
                      labelText: 'Sex / Gender',
                      prefixIcon: const Icon(Icons.wc),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _sexOptions.map((sex) {
                      return DropdownMenuItem(value: sex, child: Text(sex));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSex = val!),
                  ),
                  const SizedBox(height: 14),
                ],

                // ==================== COMMON CREDENTIAL FIELDS ====================
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Student Email',
                    hintText: 'student@spcba.edu.ph',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.spcbaGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _handleSubmit,
                    child: Text(
                      _isSignUp ? 'Create Student Account' : 'Log In',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Toggle Login / Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSignUp
                          ? 'Already have an account?'
                          : "Don't have an account?",
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                        });
                      },
                      child: Text(_isSignUp ? 'Log In' : 'Sign Up'),
                    ),
                  ],
                ),

                const Divider(height: 28),

                // Guest Login Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleGuestLogin,
                  icon: const Icon(Icons.person_search),
                  label: const Text('Continue as Guest'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
