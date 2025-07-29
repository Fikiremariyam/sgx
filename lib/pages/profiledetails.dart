import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AccountDetailsPage extends StatefulWidget {
  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _firstNameController =
      TextEditingController(text: 'No name');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'No last name');
  final TextEditingController _emailController =
      TextEditingController(text: 'no wemailmail');
  final TextEditingController _phoneController =
      TextEditingController(text: 'no number ');
  final TextEditingController _addressController =
      TextEditingController(text: 'no address');
  final TextEditingController _gender = TextEditingController(text: 'no city');
  String balance = '0.00';

  void setuserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _firstNameController.text = prefs.getString('FirstName') ?? 'Name';
      _lastNameController.text = prefs.getString('LastName') ?? 'Last Name ';
      _addressController.text = prefs.getString('email') ?? 'email';
      _addressController.text = prefs.getString('address') ?? 'no address';
      _emailController.text = prefs.getString('email') ?? 'no email';
      _phoneController.text = prefs.getString('phone') ?? 'no email';
      _gender.text = prefs.getString('gender') ?? 'no gender';
      balance = prefs.getString('acc_balance') ?? '1234';
    });
  }

  @override
  void initState() {
    super.initState();
    setuserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Account Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        /* Positioned(// for the camera icon on the right bottom of the profile picture
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: (){},
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Color(0xFF4CAF50), width: 2),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ),
                      */
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      _firstNameController.text +
                          ' ' +
                          _lastNameController.text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Personal Information Section
              _buildSectionTitle('Personal Information'),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      icon: Icons.person_outline,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      icon: Icons.person_outline,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 16),

              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 16),
              _buildTextField(
                controller: _gender,
                label: 'Gender',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              _buildTextField(
                controller: _addressController,
                label: 'Street Address',
                icon: Icons.location_on_outlined,
              ),

              SizedBox(height: 32),

              // Account Statistics Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Statistics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem('Member Since', 'Jan 2020'),
                        _buildStatItem('Balance', balance),
                        _buildStatItem('Total income  ', '5670'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Color(0xFF4CAF50),
                size: 34,
              ),
              SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  label,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 22, 22, 22),
                    fontSize: 16,
                  ),
                ),
                Text(
                  controller.text,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 2, 178, 242),
                    fontSize: 16,
                  ),
                ),
              ]),
            ],
          ),
        ));
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
