import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(GrievanceApp());
}

enum Role { user, admin }

class GrievanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grievance App',
      theme: ThemeData(
        primaryColor: Color(0xff0CC3D2),
        scaffoldBackgroundColor: Color(0xffE5F8FB),
        fontFamily: 'Roboto', // Use as in Figma if specified
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xffE5F8FB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for logo/image
              Icon(Icons.fact_check, color: Color(0xff0CC3D2), size: 85),
              SizedBox(height: 32),
              Text(
                'Welcome to Grievance Portal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 14),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0CC3D2),
                  minimumSize: Size(180, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen())),
                child: Text("Get Started", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      );
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  Role selectedRole = Role.user;

  void login() {
    String email = _emailCtrl.text.trim();
    String pass = _passCtrl.text.trim();

    // Admin credentials fixed
    if (selectedRole == Role.admin &&
        email == 'admin@grievance.com' &&
        pass == 'admin123') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
      return;
    }

    // User login — dummy authentication
    if (selectedRole == Role.user && users.containsKey(email) && users[email]!.password == pass) {
      // Set logged-in user for demo
      userSession = users[email];
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserDashboard()));
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Invalid credentials')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5F8FB),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 46),
                Icon(Icons.fact_check, color: Color(0xff0CC3D2), size: 70),
                SizedBox(height: 30),
                Text('Welcome back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
                        leading: Radio<Role>(
                          groupValue: selectedRole,
                          value: Role.user,
                          onChanged: (v) => setState(() => selectedRole = v!),
                          activeColor: Color(0xff0CC3D2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Admin', style: TextStyle(fontWeight: FontWeight.bold)),
                        leading: Radio<Role>(
                          groupValue: selectedRole,
                          value: Role.admin,
                          onChanged: (v) => setState(() => selectedRole = v!),
                          activeColor: Color(0xff0CC3D2),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0CC3D2),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: login,
                  child: Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                SizedBox(height: 14),
                TextButton(
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegistrationScreen())),
                  child: Text("Don't have an account? Sign up",
                      style: TextStyle(color: Color(0xff0CC3D2))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _villageCtrl = TextEditingController();

  void register() {
    String email = _emailCtrl.text.trim();
    String pass = _passCtrl.text.trim();
    String village = _villageCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty || village.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fill all fields")));
      return;
    }
    if (users.containsKey(email) || email == 'admin@grievance.com') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email already exists or is reserved for admin")));
      return;
    }
    users[email] = UserInfo(email: email, password: pass, village: village);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered! Login now.")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5F8FB),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 30),
                Icon(Icons.fact_check, color: Color(0xff0CC3D2), size: 58),
                SizedBox(height: 18),
                Text('Register', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                TextField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 14),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 14),
                TextField(
                  controller: _villageCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter your Village',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0CC3D2),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: register,
                  child: Text("Register", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                SizedBox(height: 14),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Already have an account? Login", style: TextStyle(color: Color(0xff0CC3D2))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// User and complaint state storage
class UserInfo {
  String email, password, village;
  UserInfo({required this.email, required this.password, required this.village});
}
Map<String, UserInfo> users = {};
UserInfo? userSession;
List<Complaint> complaints = [];

class Complaint {
  String title, description, village, reportedBy, status;
  File? userPhoto, adminProofPhoto;

  Complaint({
    required this.title,
    required this.description,
    required this.village,
    required this.reportedBy,
    this.userPhoto,
    this.adminProofPhoto,
    this.status = "Pending",
  });
}

// User Dashboard (matches your Figma with panel buttons)
class UserDashboard extends StatefulWidget {
  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int selectedTab = 0; // 0: Total, 1: Pending, 2: Resolved
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    List<Complaint> myComplaints = complaints
        .where((c) => c.village == userSession?.village)
        .toList();
    List<Complaint> filtered = selectedTab == 1
        ? myComplaints.where((c) => c.status == "Pending").toList()
        : selectedTab == 2
            ? myComplaints.where((c) => c.status == "Completed").toList()
            : myComplaints;

    return Scaffold(
      backgroundColor: Color(0xffE5F8FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xff0CC3D2)),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_rounded),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("USER DETAILS"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_box, size: 46, color: Color(0xff0CC3D2)),
                    SizedBox(height: 12),
                    Text("EMAIL: ${userSession?.email ?? ""}"),
                    Text("VILLAGE: ${userSession?.village ?? ""}"),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: Column(
          children: [
            Text("Complaint Dashboard", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton("Total", 0),
                _buildTabButton("Pending", 1),
                _buildTabButton("Resolved", 2),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit_document, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, 40),
                      backgroundColor: Color(0xff0CC3D2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    ),
                    onPressed: () => _openComplaintDialog(context),
                    label: Text("Write a complaint", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.assignment_turned_in, color: Color(0xff0CC3D2)),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xff0CC3D2), width: 1.3),
                          backgroundColor: Colors.white),
                      onPressed: () {},
                      label: Text("Track complaints", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff0CC3D2))),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text("No complaints found"))
                  : ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  Complaint c = filtered[i];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    elevation: 2,
                    child: ListTile(
                      leading: c.userPhoto != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.file(c.userPhoto!, width: 48, height: 48, fit: BoxFit.cover))
                          : Icon(Icons.report_gmailerrorred, color: Color(0xff0CC3D2)),
                      title: Text(c.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.description),
                          SizedBox(height: 4),
                          Text("Status: ${c.status}",
                              style: TextStyle(
                                  color: c.status == "Pending" ? Colors.orange : Colors.green,
                                  fontWeight: FontWeight.bold)),
                          if (c.adminProofPhoto != null) ...[
                            SizedBox(height: 6),
                            Text("Resolution Proof:"),
                            Image.file(c.adminProofPhoto!, width: 48, height: 48)
                          ]
                        ],
                      ),
                    ),
                  );
                }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int idx) => Expanded(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: OutlinedButton(
          onPressed: () => setState(() => selectedTab = idx),
          style: OutlinedButton.styleFrom(
              backgroundColor: selectedTab == idx ? Color(0xff0CC3D2) : Colors.white,
              side: BorderSide(color: Color(0xff0CC3D2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: Text(label,
              style: TextStyle(
                color: selectedTab == idx ? Colors.white : Color(0xff0CC3D2),
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );

  void _openComplaintDialog(BuildContext context) async {
    final _titleCtrl = TextEditingController();
    final _descCtrl = TextEditingController();
    File? pickedPhoto;

    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Write a complaint"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _titleCtrl, decoration: InputDecoration(labelText: "Title")),
                  TextField(controller: _descCtrl, decoration: InputDecoration(labelText: "Description")),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.photo),
                        label: Text("Attach Photo"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0CC3D2),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final xFile = await picker.pickImage(source: ImageSource.gallery);
                          if (xFile != null) setState(() => pickedPhoto = File(xFile.path));
                        },
                      ),
                      SizedBox(width: 8),
                      if (pickedPhoto != null) Icon(Icons.image, color: Colors.green)
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      if (_titleCtrl.text.isNotEmpty && _descCtrl.text.isNotEmpty) {
                        setState(() {
                          complaints.add(Complaint(
                              title: _titleCtrl.text,
                              description: _descCtrl.text,
                              village: userSession?.village ?? '',
                              reportedBy: userSession?.email ?? '',
                              userPhoto: pickedPhoto));
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Submit")),
              ],
            ));
  }
}

// Admin dashboard, tab style, complete with photo proof
class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedTab = 0;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    List<Complaint> filtered = selectedTab == 1
        ? complaints.where((c) => c.status == "Pending").toList()
        : selectedTab == 2
            ? complaints.where((c) => c.status == "Completed").toList()
            : complaints;

    return Scaffold(
      backgroundColor: Color(0xffE5F8FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xff0CC3D2)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () =>
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen())),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: Column(
          children: [
            Text("Complaint Dashboard", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton("Total", 0),
                _buildTabButton("Pending", 1),
                _buildTabButton("Resolved", 2),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text("No complaints found"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        Complaint c = filtered[i];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          elevation: 2,
                          child: ListTile(
                            leading: c.userPhoto != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.file(c.userPhoto!,
                                        width: 48, height: 48, fit: BoxFit.cover))
                                : Icon(Icons.report_gmailerrorred, color: Color(0xff0CC3D2)),
                            title: Text("${c.title} (${c.village})"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.description),
                                Text("Reported by: ${c.reportedBy}"),
                                SizedBox(height: 4),
                                Text("Status: ${c.status}",
                                    style: TextStyle(
                                        color: c.status == "Pending" ? Colors.orange : Colors.green,
                                        fontWeight: FontWeight.bold)),
                                if (c.adminProofPhoto != null) ...[
                                  SizedBox(height: 6),
                                  Text("Resolution Proof:"),
                                  Image.file(c.adminProofPhoto!, width: 48, height: 48)
                                ]
                              ],
                            ),
                            trailing: c.status == "Pending"
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff0CC3D2),
                                        foregroundColor: Colors.white),
                                    onPressed: () => _resolveComplaint(i),
                                    child: Text("Mark Completed"),
                                  )
                                : Icon(Icons.check_circle, color: Colors.green),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int idx) => Expanded(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: OutlinedButton(
              onPressed: () => setState(() => selectedTab = idx),
              style: OutlinedButton.styleFrom(
                  backgroundColor: selectedTab == idx ? Color(0xff0CC3D2) : Colors.white,
                  side: BorderSide(color: Color(0xff0CC3D2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text(label,
                  style: TextStyle(
                    color: selectedTab == idx ? Colors.white : Color(0xff0CC3D2),
                    fontWeight: FontWeight.bold,
                  )),
            )),
      );

  void _resolveComplaint(int idx) async {
    final c = complaints[idx];
    XFile? proof = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      c.status = "Completed";
      if (proof != null) c.adminProofPhoto = File(proof.path);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Complaint marked as resolved!")));
  }
}
