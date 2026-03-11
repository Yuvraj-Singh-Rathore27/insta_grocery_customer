import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/candidate_resume_model.dart';
import '../../res/AppColor.dart';

class CandidateFullProfileScreen extends StatelessWidget {
  final CandidateData candidate;

  const CandidateFullProfileScreen({super.key, required this.candidate});

  String safe(dynamic value) {
    if (value == null) return "";
    final v = value.toString().trim();
    if (v.isEmpty || v.toLowerCase() == "null") return "";
    return v;
  }

  @override
  Widget build(BuildContext context) {

    String? imageUrl;

    if (candidate.photo != null && candidate.photo!.isNotEmpty) {
      imageUrl =
          candidate.photo!.first.fileUrl ?? candidate.photo!.first.path;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Candidate Profile"),
        backgroundColor: AppColor().colorPrimary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PROFILE HEADER
            _headerCard(imageUrl),

            const SizedBox(height:20),

            /// PERSONAL INFO
            _sectionTitle("Personal Information"),
            _infoCard([
              _infoRow("Gender", safe(candidate.gender)),
              _infoRow("Birth Date", safe(candidate.birthDate)),
              _infoRow("Phone", safe(candidate.contactNumber)),
              _infoRow("Email", safe(candidate.email)),
            ]),

            const SizedBox(height:20),

            /// QUALIFICATION
            _sectionTitle("Qualification"),
            _infoCard([
              _infoRow("Qualification", safe(candidate.qualification)),
              _infoRow("Experience", "${safe(candidate.experience)} Years"),
              _infoRow("Job Type", safe(candidate.jobType)),
              _infoRow("Category", safe(candidate.category?.name)),
              _infoRow("Subcategory", safe(candidate.subcategory?.name)),
            ]),

            const SizedBox(height:20),

            /// SKILLS
            if(candidate.skills != null && candidate.skills!.isNotEmpty)
            _sectionTitle("Skills"),

            if(candidate.skills != null && candidate.skills!.isNotEmpty)
            _chipWrap(candidate.skills!),

            const SizedBox(height:20),

            /// LANGUAGES
            if(candidate.languages != null && candidate.languages!.isNotEmpty)
            _sectionTitle("Languages"),

            if(candidate.languages != null && candidate.languages!.isNotEmpty)
            _chipWrap(candidate.languages!),

            const SizedBox(height:20),

            /// LOCATION
            _sectionTitle("Preferred Location"),
            _infoCard([
              _infoRow("Country", safe(candidate.preferredCountry)),
              _infoRow("State", safe(candidate.preferredState)),
              _infoRow("City", safe(candidate.preferredCity)),
            ]),

            const SizedBox(height:20),

            /// SALARY
            _sectionTitle("Expected Salary"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "₹${candidate.expectedSalary?.toStringAsFixed(0) ?? "0"}",
                style: const TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            const SizedBox(height:20),

            /// DOCUMENTS
            if(candidate.resume != null && candidate.resume!.isNotEmpty)
            _sectionTitle("Resume"),

            if(candidate.resume != null && candidate.resume!.isNotEmpty)
            _documentItem(candidate.resume!.first.fileUrl),

            const SizedBox(height:20),

            if(candidate.certificate != null && candidate.certificate!.isNotEmpty)
            _sectionTitle("Certificates"),

            if(candidate.certificate != null)
            ...candidate.certificate!.map((c)=>_documentItem(c.fileUrl)),

            const SizedBox(height:30),

            /// CONTACT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().colorPrimary,
                  padding: const EdgeInsets.symmetric(vertical:14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {

                  final phone = safe(candidate.contactNumber);

                  if(phone.isEmpty) return;

                  final uri = Uri.parse("tel:$phone");

                  await launchUrl(uri);

                },
                child: const Text(
                  "Call Candidate",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  /// HEADER
  Widget _headerCard(String? imageUrl){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius:40,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: Image.network(
                imageUrl ?? "",
                width:80,
                height:80,
                fit: BoxFit.cover,
                errorBuilder: (_,__,___){
                  return const Icon(Icons.person,size:40);
                },
              ),
            ),
          ),

          const SizedBox(width:16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  safe(candidate.fullName),
                  style: const TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height:6),

                Text(
                  safe(candidate.resumeHeadline),
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height:10),

                Row(
                  children: [

                    const Icon(Icons.location_on,size:16,color:Colors.grey),
                    const SizedBox(width:4),

                    Text(safe(candidate.preferredCity)),

                    const SizedBox(width:20),

                    const Icon(Icons.work,size:16,color:Colors.grey),
                    const SizedBox(width:4),

                    Text("${safe(candidate.experience)} years"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(bottom:10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize:18,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  /// INFO CARD
  Widget _infoCard(List<Widget> children){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  /// INFO ROW
  Widget _infoRow(String label,String value){
    if(value.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom:10),
      child: Row(
        children: [

          SizedBox(
            width:120,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600
              ),
            ),
          ),

          Expanded(child: Text(value))

        ],
      ),
    );
  }

  /// CHIP WRAP
  Widget _chipWrap(List list){
    return Wrap(
      spacing:8,
      runSpacing:8,
      children: list
          .where((e)=> e != null && e.toString().isNotEmpty)
          .map((e)=>Container(
        padding: const EdgeInsets.symmetric(
            horizontal:12, vertical:6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
  e.toString().replaceAll("[", "").replaceAll("]", ""),
),
      )).toList(),
    );
  }

  /// DOCUMENT ITEM
  Widget _documentItem(String? url){

    if(url == null || url.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom:10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [

          const Icon(Icons.picture_as_pdf),

          const SizedBox(width:10),

          const Expanded(child: Text("View Document")),

          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () async {

              final uri = Uri.parse(url);

              await launchUrl(uri,
                  mode: LaunchMode.externalApplication);

            },
          )
        ],
      ),
    );
  }
}