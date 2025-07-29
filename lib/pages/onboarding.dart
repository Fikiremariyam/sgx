import 'package:flutter/material.dart';
import 'package:sgx/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: "Welcome to SGX Tricycle",
      description:
          "Experience the future of urban transportation with our eco-friendly electric tricycles designed for modern city living.",
      icon: Icons.electric_rickshaw,
      color: Color(0xFF4CAF50),
    ),
    OnboardingData(
      title: "Smart & Sustainable",
      description:
          "Our SGX tricycles combine cutting-edge technology with environmental consciousness for a cleaner tomorrow.",
      icon: Icons.eco,
      color: Color(0xFF66BB6A),
    ),
    OnboardingData(
      title: "Ready to Ride?",
      description:
          "Join thousands of riders who have already made the switch to smarter, greener transportation with SGX.",
      icon: Icons.directions_bike,
      color: Color(0xFF81C784),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _onboardingData[index]);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Color(0xFF4CAF50)
                              : Color(0xFF9E9E9E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        SizedBox(width: 60),
                      ElevatedButton(
                        onPressed: () async {
                          if (_currentPage < _onboardingData.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Navigate to main app
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool("seen", true);

                            Navigator.pushNamed(
                              context,
                              "/login",
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          _currentPage < _onboardingData.length - 1
                              ? 'Next'
                              : 'Get Started',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 100,
              color: data.color,
            ),
          ),
          SizedBox(height: 60),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(208, 76, 175, 79),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
