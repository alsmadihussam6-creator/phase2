import 'package:phase_2_project/models/cvprojectmodel.dart';
import 'package:phase_2_project/screens/edit.dart';
import 'package:phase_2_project/services/auth.dart';
import 'package:phase_2_project/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phase_2_project/utils/theme/main_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final dbService = Provider.of<DatabaseService>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Theme(
      data: cvTheme.lightTheme,
      child: Scaffold(
        appBar: AppBar(

          title: const Text('My CV'),
          backgroundColor: cvTheme.lightTheme.colorScheme.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => authService.signOut(),
              color: Colors.white,

            ),

          ],
        ),
        body: StreamBuilder<CVProjectModel?>(
          stream: dbService.streamCV(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final cv = snapshot.data;

            if (cv == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No CV found. Create one!'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditCVScreen()),
                      ),
                      child: const Text('Create CV'),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: cvTheme.lightTheme.colorScheme.primary,
                    child: cv.fullName.isNotEmpty
                        ? Text(cv.fullName[0], style: const TextStyle(fontSize: 40, color: Colors.white))
                        : const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cv.fullName, style: cvTheme.lightTheme.textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 16),
                            const SizedBox(width: 4),
                            Text(cv.email),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 16),
                            const SizedBox(width: 4),
                            Text(cv.phone),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_city, size: 16),
                            const SizedBox(width: 4),
                            Text(cv.address),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (cv.summary.isNotEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Summary', style: cvTheme.lightTheme.textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          Text(cv.summary, style: cvTheme.lightTheme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                if (cv.experiences.isNotEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Experience', style: cvTheme.lightTheme.textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          ...cv.experiences.map((exp) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(exp.role),
                              subtitle: Text('${exp.company} • ${exp.duration}'),
                              leading: const Icon(Icons.work),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                if (cv.education.isNotEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Education', style: cvTheme.lightTheme.textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          ...cv.education.map((edu) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(edu.degree)),
                                Expanded(flex: 3, child: Text(edu.institution)),
                                Expanded(flex: 1, child: Text(edu.year, textAlign: TextAlign.right)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                if (cv.skills.isNotEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Skills', style: cvTheme.lightTheme.textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: cv.skills.map((skill) => Chip(label: Text(skill))).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditCVScreen(initialCV: cv)),
                    ),
                    child: const Text('Edit CV', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}