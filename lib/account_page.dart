import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(),

            const SizedBox(height: 20),

            // Account Options
            const Text('Account Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildAccountOption(
              icon: Icons.shopping_bag,
              title: 'My Orders',
              onTap: () {
                // Navigate to orders page
              },
            ),
            _buildAccountOption(
              icon: Icons.favorite,
              title: 'Wishlist',
              onTap: () {
                // Navigate to wishlist page
              },
            ),
            _buildAccountOption(
              icon: Icons.location_on,
              title: 'Address Book',
              onTap: () {
                // Navigate to address book page
              },
            ),
            _buildAccountOption(
              icon: Icons.payment,
              title: 'Payment Methods',
              onTap: () {
                // Navigate to payment methods page
              },
            ),

            const SizedBox(height: 20),

            // Settings & Support
            const Text('Settings & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildAccountOption(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                // Navigate to settings page
              },
            ),
            _buildAccountOption(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                // Navigate to help page
              },
            ),
            _buildAccountOption(
              icon: Icons.info,
              title: 'About Us',
              onTap: () {
                // Navigate to about page
              },
            ),

            const SizedBox(height: 20),

            // Logout Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle logout
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Section Widget
  Widget _buildProfileSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/profile.jpg'), // Replace with user's profile image
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('John Doe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('johndoe@example.com', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  // Account Option Tile
  Widget _buildAccountOption({required IconData icon, required String title, required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Add your logout logic here
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
