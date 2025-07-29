import 'package:flutter/material.dart';
import 'dart:async';

class AdvertisementBanner extends StatefulWidget {
  final List<AdBannerData> advertisements;
  final double height;
  final Duration autoSlideInterval;
  final bool showIndicators;
  final bool autoSlide;
  final Function(AdBannerData)? onAdTap;

  const AdvertisementBanner({
    Key? key,
    required this.advertisements,
    this.height = 160.0,
    this.autoSlideInterval = const Duration(seconds: 4),
    this.showIndicators = true,
    this.autoSlide = true,
    this.onAdTap,
  }) : super(key: key);

  @override
  _AdvertisementBannerState createState() => _AdvertisementBannerState();
}

class _AdvertisementBannerState extends State<AdvertisementBanner> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoSlide && widget.advertisements.isNotEmpty) {
      _startAutoSlide();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(widget.autoSlideInterval, (timer) {
      if (_currentIndex < widget.advertisements.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.advertisements.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      height: widget.height,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          // Main Banner Slider
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.advertisements.length,
              itemBuilder: (context, index) {
                final ad = widget.advertisements[index];
                return _buildAdBanner(ad);
              },
            ),
          ),

          // Page Indicators
          if (widget.showIndicators && widget.advertisements.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.advertisements.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

          // Manual Navigation Arrows (Optional)
          if (widget.advertisements.length > 1) ...[
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (_currentIndex > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (_currentIndex < widget.advertisements.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdBanner(AdBannerData ad) {
    return GestureDetector(
      onTap: () {
        if (widget.onAdTap != null) {
          widget.onAdTap!(ad);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ad.gradientColors ??
                [
                  Color(0xFF4CAF50),
                  Color(0xFF66BB6A),
                ],
          ),
        ),
        child: Stack(
          children: [
            // Background Image (if provided)
            if (ad.imageUrl != null)
              Positioned.fill(
                child: Image.network(
                  ad.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                    );
                  },
                ),
              ),

            // Overlay for better text readability
            if (ad.imageUrl != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),

            // Content
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (ad.title != null) ...[
                      Text(
                        ad.title!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                    if (ad.subtitle != null) ...[
                      Text(
                        ad.subtitle!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdBannerData {
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final String? imageUrl;
  final List<Color>? gradientColors;
  final bool showAdBadge;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  AdBannerData({
    this.title,
    this.subtitle,
    this.buttonText,
    this.imageUrl,
    this.gradientColors,
    this.showAdBadge = true,
    this.actionUrl,
    this.metadata,
  });
}

// Sample advertisement data
class AdBannerSamples {
  static List<AdBannerData> getSampleAds() {
    return [
      AdBannerData(
        title: "50% Off First Ride!",
        subtitle: "New users get half price on their first SGX tricycle ride",
        buttonText: "Claim Now",
        gradientColors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        actionUrl: "/promo/first-ride",
      ),
      AdBannerData(
        title: "Refer & Earn ₱100",
        subtitle:
            "Invite friends and earn rewards for every successful referral",
        buttonText: "Invite Friends",
        gradientColors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
        actionUrl: "/referral",
      ),
      AdBannerData(
        title: "Weekend Special",
        subtitle: "Free rides every Saturday from 6-8 AM",
        buttonText: "Learn More",
        gradientColors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
        actionUrl: "/weekend-promo",
      ),
      AdBannerData(
        title: "Go Green, Go SGX",
        subtitle: "Join the eco-friendly transportation revolution",
        buttonText: "Discover",
        gradientColors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
        actionUrl: "/about-green",
      ),
    ];
  }
}
