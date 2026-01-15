import 'package:flutter/material.dart';

/// Section title for grouping profile information
class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final fontSize = isSmallScreen ? 16.0 : 18.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Card displaying user information (name, email, phone, address)
class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive values
    final cardPadding = isSmallScreen ? 14.0 : 16.0;
    final iconPadding = isSmallScreen ? 10.0 : 12.0;
    final iconSize = isSmallScreen ? 22.0 : 24.0;
    final spacing = isSmallScreen ? 12.0 : 16.0;
    final labelSize = isSmallScreen ? 11.0 : 12.0;
    final valueSize = isSmallScreen ? 15.0 : (isTablet ? 16.0 : 17.0);
    final borderRadius = isSmallScreen ? 14.0 : 16.0;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(iconPadding),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: labelSize,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Clickable action card (change password, logout)
class ProfileActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileActionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive values
    final cardPadding = isSmallScreen ? 14.0 : 16.0;
    final iconPadding = isSmallScreen ? 10.0 : 12.0;
    final iconSize = isSmallScreen ? 22.0 : 24.0;
    final spacing = isSmallScreen ? 12.0 : 16.0;
    final titleSize = isSmallScreen ? 15.0 : (isTablet ? 16.0 : 17.0);
    final subtitleSize = isSmallScreen ? 11.0 : 12.0;
    final chevronSize = isSmallScreen ? 22.0 : 24.0;
    final borderRadius = isSmallScreen ? 14.0 : 16.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.2)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: iconSize),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: isDestructive ? Colors.red : Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: chevronSize,
            ),
          ],
        ),
      ),
    );
  }
}

/// Profile header with gradient background and avatar
class ProfileHeader extends StatelessWidget {
  final String name;

  const ProfileHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive values - REDUCED HEIGHT
    final expandedHeight = isSmallScreen
        ? size.height *
              0.28 // Was 0.32, reduced by 4%
        : (isTablet
              ? size.height * 0.30
              : size.height * 0.32); // Was 0.35 & 0.38
    final avatarRadius = isSmallScreen
        ? size.width *
              0.12 // Slightly smaller avatar
        : (isTablet ? size.width * 0.11 : size.width * 0.09);
    final iconSize = isSmallScreen
        ? size.width *
              0.13 // Slightly smaller icon
        : (isTablet ? size.width * 0.12 : size.width * 0.10);
    final titleSize = isSmallScreen ? 18.0 : (isTablet ? 19.0 : 20.0);
    final nameSize = isSmallScreen
        ? 19.0
        : (isTablet ? 20.0 : 21.0); // Slightly smaller
    final spacing = isSmallScreen ? 8.0 : 10.0; // Reduced spacing

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: Colors.blue.shade700,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade700, Colors.blue.shade400],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: avatarRadius + 2,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.person,
                      size: iconSize,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              // Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: nameSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
