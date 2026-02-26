import 'package:phase_2_project/models/cvprojectmodel.dart';
import 'package:phase_2_project/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phase_2_project/utils/theme/main_theme.dart';

class EditCVScreen extends StatefulWidget {
  final CVProjectModel? initialCV;
  const EditCVScreen({super.key, this.initialCV});

  @override
  State<EditCVScreen> createState() => _EditCVScreenState();
}

class _EditCVScreenState extends State<EditCVScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _summaryController;

  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialCV?.fullName);
    _emailController = TextEditingController(text: widget.initialCV?.email);
    _phoneController = TextEditingController(text: widget.initialCV?.phone);
    _addressController = TextEditingController(text: widget.initialCV?.address);
    _summaryController = TextEditingController(text: widget.initialCV?.summary);

    _experiences = widget.initialCV?.experiences ?? [];
    _education = widget.initialCV?.education ?? [];
    _skills = widget.initialCV?.skills ?? [];
  }

  void _addExperience() {
    setState(() => _experiences.add(Experience(company: '', role: '', duration: '')));
  }

  void _addEducation() {
    setState(() => _education.add(Education(institution: '', degree: '', year: '')));
  }

  void _addSkill() {
    setState(() => _skills.add(''));
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context);
    final user = FirebaseAuth.instance.currentUser;
    final theme = cvTheme.lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit CV'),
          backgroundColor: theme.colorScheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          )
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Full Name'),
                          validator: (val) => val == null || val.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val == null || val.isEmpty ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                          validator: (val) => val == null || val.isEmpty ? 'Enter phone' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(labelText: 'Address'),
                          validator: (val) => val == null || val.isEmpty ? 'Enter address' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _summaryController,
                          decoration: const InputDecoration(labelText: 'Professional Summary'),
                          maxLines: 3,
                          validator: (val) => val == null || val.isEmpty ? 'Enter summary' : null,
                        ),
                      ],
                    ),
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
                        const Text('Experiences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ..._experiences.asMap().entries.map((entry) {
                          int idx = entry.key;
                          Experience exp = entry.value;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue: exp.company,
                                    decoration: const InputDecoration(labelText: 'Company'),
                                    onChanged: (val) => _experiences[idx].company = val,
                                    validator: (val) => val == null || val.isEmpty ? 'Enter company' : null,
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    initialValue: exp.role,
                                    decoration: const InputDecoration(labelText: 'Role'),
                                    onChanged: (val) => _experiences[idx].role = val,
                                    validator: (val) => val == null || val.isEmpty ? 'Enter role' : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          setState(() => _experiences.removeAt(idx));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _addExperience,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Experience'),
                          ),
                        ),
                      ],
                    ),
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
                        const Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ..._education.asMap().entries.map((entry) {
                          int idx = entry.key;
                          Education edu = entry.value;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue: edu.institution,
                                    decoration: const InputDecoration(labelText: 'Institution'),
                                    onChanged: (val) => _education[idx].institution = val,
                                    validator: (val) => val == null || val.isEmpty ? 'Enter institution' : null,
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    initialValue: edu.degree,
                                    decoration: const InputDecoration(labelText: 'Degree'),
                                    onChanged: (val) => _education[idx].degree = val,
                                    validator: (val) => val == null || val.isEmpty ? 'Enter degree' : null,
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    initialValue: edu.year,
                                    decoration: const InputDecoration(labelText: 'Year'),
                                    onChanged: (val) => _education[idx].year = val,
                                    validator: (val) => val == null || val.isEmpty ? 'Enter year' : null,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          setState(() => _education.removeAt(idx));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _addEducation,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Education'),
                          ),
                        ),
                      ],
                    ),
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
                        const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ..._skills.asMap().entries.map((entry) {
                          int idx = entry.key;
                          return Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _skills[idx],
                                  decoration: const InputDecoration(labelText: 'Skill'),
                                  onChanged: (val) => _skills[idx] = val,
                                  validator: (val) => val == null || val.isEmpty ? 'Enter skill' : null,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => setState(() => _skills.removeAt(idx)),
                              ),
                            ],
                          );
                        }).toList(),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _addSkill,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Skill'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && user != null) {
                        CVProjectModel cv = CVProjectModel(
                          id: user.uid,
                          fullName: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          address: _addressController.text,
                          summary: _summaryController.text,
                          experiences: _experiences,
                          education: _education,
                          skills: _skills,
                        );
                        await dbService.updateCV(user.uid, cv);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save CV', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}