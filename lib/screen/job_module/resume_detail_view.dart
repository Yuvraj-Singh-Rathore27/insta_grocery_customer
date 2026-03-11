import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/AppColor.dart';

class ResumeDetailView extends StatefulWidget {
  final Map<String, dynamic> resume;

  const ResumeDetailView({super.key, required this.resume});

  @override
  State<ResumeDetailView> createState() => _ResumeDetailViewState();
}

class _ResumeDetailViewState extends State<ResumeDetailView> {
  bool _isContactUnlocked = false;
  bool _isEmailUnlocked = false;

  // 🔒 Safe getter for null-protection
  String safe(value) {
    if (value == null) return "";
    final v = value.toString().trim();
    if (v.isEmpty || v.toLowerCase() == "null") return "";
    return v;
  }

  // Capitalize first letter
  String capitalize(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      appBar: AppBar(
        title: const Text("Resume Details"),
        backgroundColor: AppColor().colorPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 24),

            _buildPersonalInfoSection(),
            const SizedBox(height: 24),

            _buildQualificationSection(),
            const SizedBox(height: 24),

            _buildSkillsSection(),
            const SizedBox(height: 24),

            _buildLanguagesSection(),
            const SizedBox(height: 24),

            _buildWorkLocationSection(),
            const SizedBox(height: 24),

            _buildDocumentsSection(),
          ],
        ),
      ),
    );
  }

  // ***************************************
  // HEADER SECTION
  // ***************************************
  Widget _buildHeaderSection() {
    final imageUrl = safe(widget.resume["image"]);
    final fullName = capitalize(safe(widget.resume["full_name"]));
    final headline = safe(widget.resume["resume_headline"]);
    final experience = safe(widget.resume["experience"]);
    final jobType = capitalize(safe(widget.resume["job_type"]));
    final city = capitalize(safe(widget.resume["preferred_city"]));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.person, size: 80),
                  )
                : const Icon(Icons.person, size: 80),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fullName.isNotEmpty)
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                if (headline.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    headline,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (city.isNotEmpty)
                      _buildInfoChip(city, Icons.location_pin, Colors.red),
                    if (jobType.isNotEmpty)
                      _buildInfoChip(jobType, Icons.work, Colors.blue),
                    if (experience.isNotEmpty)
                      _buildInfoChip("$experience Years", Icons.access_time,
                          Colors.green),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(fontSize: 14, color: color),
          ),
        ],
      ),
    );
  }

  // ***************************************
  // PERSONAL INFO
  // ***************************************
  Widget _buildPersonalInfoSection() {
    final rawGender = safe(widget.resume["gender"]).toLowerCase();
    String gender = "";
    if (rawGender == "m") {
      gender = "Male";
    } else if (rawGender == "f") {
      gender = "Female";
    }

    final birthDate = safe(widget.resume["birth_date"]);
    final contactNumber = safe(widget.resume["contact_number"]);
    final email = safe(widget.resume["email"]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.person, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Personal Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor().whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              if (gender.isNotEmpty) _buildInfoRow("Gender", gender),
              if (birthDate.isNotEmpty) const SizedBox(height: 12),
              if (birthDate.isNotEmpty)
                _buildInfoRow("Date of Birth", birthDate),
              if (contactNumber.isNotEmpty) const SizedBox(height: 12),
              if (contactNumber.isNotEmpty)
                _buildUnlockRow(
                  "Contact Number",
                  contactNumber,
                  isUnlocked: _isContactUnlocked,
                  onUnlock: () =>
                      setState(() => _isContactUnlocked = true),
                ),
              if (email.isNotEmpty) const SizedBox(height: 12),
              if (email.isNotEmpty)
                _buildUnlockRow(
                  "Email ID",
                  email,
                  isUnlocked: _isEmailUnlocked,
                  onUnlock: () =>
                      setState(() => _isEmailUnlocked = true),
                  isEmail: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockRow(
    String label,
    String value, {
    required bool isUnlocked,
    required VoidCallback onUnlock,
    bool isEmail = false,
  }) {
    if (value.isEmpty) return const SizedBox.shrink();

    final displayValue =
        isUnlocked ? value : (isEmail ? _maskEmail(value) : "••••••••••••");

    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 15,
                    color: isEmail && isUnlocked
                        ? Colors.white
                        : Colors.black54,
                    decoration: isEmail && isUnlocked
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
              if (!isUnlocked)
                ElevatedButton.icon(
                  onPressed: onUnlock,
                  icon: const Icon(
                    Icons.lock_open,
                    size: 16,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Unlock",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _maskEmail(String email) {
    if (email.isEmpty) return "Not provided";
    final at = email.indexOf('@');
    if (at <= 1) return "xxxx@xxxx.com";
    final visible = email.substring(email.length - 2);
    return "xxxxxx$visible";
  }

  // ***************************************
  // QUALIFICATION SECTION
  // ***************************************
  Widget _buildQualificationSection() {
    final qualification = capitalize(safe(widget.resume["qualification"]));
    final university = capitalize(safe(widget.resume["university"]));
    final years = safe(widget.resume["years"]);
    final experience = safe(widget.resume["experience"]);

    dynamic certData = widget.resume["certificate"];
    List<Map<String, String>> certificates = [];

    try {
      if (certData is List) {
        for (var c in certData) {
          certificates.add({
            "title": capitalize(safe(c["title"])),
            "issuer": capitalize(safe(c["issuer"])),
          });
        }
      } else if (certData is String) {
        certificates.add({
          "title": capitalize(certData),
          "issuer": "Unknown",
        });
      }
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.school, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Qualification",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (qualification.isNotEmpty)
                Text(
                  qualification,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (university.isNotEmpty)
                Text(
                  university,
                  style: const TextStyle(fontSize: 14),
                ),
              if (years.isNotEmpty)
                Text(
                  years,
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 16),
              if (experience.isNotEmpty)
                Text("Experience: $experience Years"),
              const SizedBox(height: 16),
              if (certificates.isNotEmpty)
                ...certificates.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "${c["title"]} - ${c["issuer"]}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              if (certificates.isEmpty)
                const Text("No certificates available"),
            ],
          ),
        ),
      ],
    );
  }

  // ***************************************
  // SKILLS SECTION
  // ***************************************
  Widget _buildSkillsSection() {
    final skills = _parseSkills(widget.resume["skills"]);
    final softSkills = _parseSkills(widget.resume["soft_skills"]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.settings, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Skills & Expertise",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (skills.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      skills.map((s) => _buildSkillChip(s)).toList(),
                )
              else
                const Text("No technical skills listed"),
              const SizedBox(height: 20),
              if (softSkills.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: softSkills
                      .map((s) => _buildSoftSkillChip(s))
                      .toList(),
                )
              else
                const Text("No soft skills available"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        skill,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildSoftSkillChip(String skill) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        skill,
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  List<String> _parseSkills(dynamic data) {
    try {
      if (data == null) return [];
      if (data is List) {
        return data
            .map((e) => capitalize(safe(e)))
            .where((e) => e.isNotEmpty)
            .toList();
      }
      if (data is String && data.contains(",")) {
        return data
            .split(",")
            .map((e) => capitalize(safe(e)))
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return [capitalize(safe(data))];
    } catch (_) {
      return [];
    }
  }

  // ***************************************
  // LANGUAGES SECTION
  // ***************************************
  Widget _buildLanguagesSection() {
    final raw = widget.resume["languages"];
    List<String> languages = [];

    try {
      if (raw is List) {
        languages = raw
            .map((e) => capitalize(safe(e)))
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (raw is String && raw.isNotEmpty) {
        languages = raw
            .replaceAll("[", "")
            .replaceAll("]", "")
            .split(",")
            .map((e) => capitalize(safe(e)))
            .where((e) => e.isNotEmpty)
            .toList();
      }
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.language, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Known Languages",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: languages.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: languages.map((lang) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 12),
                      child: Text(
                        lang,
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                )
              : const Text("No languages listed"),
        ),
      ],
    );
  }

  // ***************************************
  // WORK LOCATION
  // ***************************************
  Widget _buildWorkLocationSection() {
    final country =
        capitalize(safe(widget.resume["preferred_country"]));
    final state =
        capitalize(safe(widget.resume["preferred_state"]));
    final city =
        capitalize(safe(widget.resume["preferred_city"]));

    if (country.isEmpty && state.isEmpty && city.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.location_on, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Preferred Work Location",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              "$country > $state > $city",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ***************************************
  // DOCUMENTS SECTION
  // ***************************************
  Widget _buildDocumentsSection() {
    final photo = safe(widget.resume["photo"]);
    final resumeFiles =
        widget.resume["resume"] is List ? widget.resume["resume"] : [];

    if (photo.isEmpty && resumeFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.cloud_upload, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              "Uploaded Documents",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              if (photo.isNotEmpty)
                _buildDocumentItem(
                  icon: Icons.person,
                  title: "Profile Photo",
                  fileName: "profile.jpg",
                  url: photo,
                  isImage: true,
                  
                ),
              if (resumeFiles.isNotEmpty) const SizedBox(height: 16),
              if (resumeFiles.isNotEmpty)
              
                _buildDocumentItem(
                  icon: Icons.picture_as_pdf,
                  title: "Resume",
                  fileName: "resume.pdf",
                  url: (resumeFiles[0] is Map &&
                          (resumeFiles[0] as Map)
                              .containsKey("file_url"))
                      ? safe((resumeFiles[0] as Map)["file_url"])
                      : "",
                  isImage: false,
                  size: "File Available",
                  
                ),
                
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem({
    required IconData icon,
    required String title,
    required String fileName,
    required String url,
    required bool isImage,
    String? size,
  }) {
    if (url.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                fileName,
                style: const TextStyle(fontSize: 14),
              ),
              if (size != null)
                Text(
                  size,
                  style: const TextStyle(fontSize: 13),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_red_eye),
          onPressed: () async {
            final uri = Uri.tryParse(url);
            if (uri == null) return;
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            print("------------------------------------>$url");
          },
        ),
       IconButton(
  icon: const Icon(Icons.download),
  onPressed: () async {
    try {
      if (url.isEmpty ||
          url == "{}" ||
          !url.startsWith("http")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid file URL")),
        );
        return;
      }

      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot open file: $e")),
      );
    }
  },
),

      ],
    );
  }
}
