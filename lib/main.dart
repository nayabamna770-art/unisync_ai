import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const UniSyncApp());
}

class UniSyncApp extends StatelessWidget {
  const UniSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniSync AI — FYP Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A), // Dark Slate / Deep Navy
          primary: const Color(0xFF1E293B),
          secondary: const Color(0xFF059669), // Emerald Green
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentStep = 0; // 0: Auth, 1: Form, 2: Roadmap Dashboard
  bool _isLogin = true;
  bool _isLoading = false;

  // Controllers
  final _emailController = TextEditingController(text: 'student@uog.edu.pk');
  final _passwordController = TextEditingController(text: 'password123');
  final _nameController = TextEditingController();
  final _skillsController = TextEditingController();
  final _ideaController = TextEditingController();

  Map<String, dynamic>? _result;

  // Replace with your Google AI Studio Gemini Key
  final String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';

  Future<void> _analyzeProject() async {
    if (_nameController.text.isEmpty ||
        _skillsController.text.isEmpty ||
        _ideaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prompt =
        '''
You are an academic project advisor for university students. 
Analyze the student profile:
Student Name: ${_nameController.text}
Skills/Tech Stack: ${_skillsController.text}
Project Idea: ${_ideaController.text}

Return ONLY valid JSON with keys:
1. "compatibility_summary": A 2-sentence summary of the required partner profile.
2. "required_roles": A list of 3 specific technical roles needed.
3. "project_roadmap": A list of 4 maps, each with "stage" (String) and "task" (String).
4. "suggested_tags": A list of 4 hashtag strings.
''';

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String rawText = data['candidates'][0]['content']['parts'][0]['text'];
        rawText = rawText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final parsedJson = jsonDecode(rawText);

        setState(() {
          _result = parsedJson;
          _currentStep = 2; // Move to Results Screen
        });
      } else {
        _showFallback();
      }
    } catch (e) {
      _showFallback();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFallback() {
    setState(() {
      _result = {
        'compatibility_summary':
            'Ideal for a partner with backend & database expertise to pair with ${_nameController.text}\'s strengths in ${_skillsController.text}.',
        'required_roles': [
          'Backend & Database Engineer',
          'UI/UX & Frontend Lead',
          'Machine Learning Specialist',
        ],
        'project_roadmap': [
          {
            'stage': 'Phase 1',
            'task': 'Requirements Gathering & Architecture Design',
          },
          {
            'stage': 'Phase 2',
            'task': 'Core API Development & Model Prototyping',
          },
          {
            'stage': 'Phase 3',
            'task': 'Frontend UI Integration & User Testing',
          },
          {
            'stage': 'Phase 4',
            'task': 'Documentation, Thesis Writing & Final Deployment',
          },
        ],
        'suggested_tags': [
          '#FYP2026',
          '#FlutterAI',
          '#UOG_Hub',
          '#StudentProject',
        ],
      };
      _currentStep = 2; // Move to Results Screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Background
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.school, color: Color(0xFF10B981)),
            const SizedBox(width: 8),
            const Text(
              'UniSync AI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'UOG FYP Portal',
                style: TextStyle(fontSize: 11, color: Color(0xFF10B981)),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
        actions: [
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFF94A3B8)),
              //icon: const Icon(Icons.logout, color: Colors.slateBorder),
              tooltip: 'Sign Out',
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                });
              },
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentStep) {
      case 0:
        return _buildAuthCard();
      case 1:
        return _buildFormCard();
      case 2:
        return _buildRoadmapDashboardCard();
      default:
        return _buildAuthCard();
    }
  }

  // --- SCREEN 1: LOGIN / SIGNUP ---
  Widget _buildAuthCard() {
    return Card(
      key: const ValueKey(0),
      elevation: 4,
      color: const Color(0xFF1E293B), // Dark Slate Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isLogin ? 'Welcome Back to UniSync' : 'Create Student Account',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isLogin
                  ? 'Sign in with your university credentials to continue.'
                  : 'Register your email to find FYP partners and roadmaps.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'University Email',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF10B981)),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF10B981)),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 1; // Move to Project Input Form
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // Emerald
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_isLogin ? 'Sign In' : 'Register Account'),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin
                      ? "Don't have an account? Sign Up"
                      : 'Already registered? Sign In',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SCREEN 2: PROJECT INPUT FORM ---
  Widget _buildFormCard() {
    return Card(
      key: const ValueKey(1),
      elevation: 4,
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'FYP Profile & Concept Brief',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Fill out your project profile so our AI can match team roles and design your project timeline.',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Your Full Name',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF10B981)),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _skillsController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText:
                    'Tech Stack / Primary Skills (e.g., Flutter, Dart, Python)',
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF10B981)),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _ideaController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Project Idea / Brief Description',
                alignLabelWithHint: true,
                labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF10B981)),
                ),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyzeProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome, size: 18),
                label: Text(
                  _isLoading
                      ? 'Synthesizing Roadmap...'
                      : 'Generate AI Partner Match & Roadmap',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SCREEN 3: ROADMAP & RECOMMENDATION DASHBOARD ---
  Widget _buildRoadmapDashboardCard() {
    return Card(
      key: const ValueKey(2),
      elevation: 4,
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Project Roadmap & Strategy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF10B981)),
                  tooltip: 'New Analysis',
                  onPressed: () {
                    setState(() {
                      _currentStep = 1;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.psychology,
                    color: Color(0xFF10B981),
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _result?['compatibility_summary'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Required Teammate Roles:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List<Widget>.from(
                (_result?['required_roles'] as List? ?? []).map(
                  (role) => Chip(
                    label: Text(
                      role.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF334155),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Execution Roadmap (4 Phases):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ...List<Widget>.from(
              (_result?['project_roadmap'] as List? ?? []).map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${item['stage']}: ${item['task']}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF10B981),
                  side: const BorderSide(color: Color(0xFF10B981)),
                ),
                child: const Text('Edit Profile / Generate Another'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
