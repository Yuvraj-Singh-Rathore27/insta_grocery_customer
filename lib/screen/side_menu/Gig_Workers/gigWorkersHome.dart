import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/screen/side_menu/Gig_Workers/MyGigs.dart';
import 'package:insta_grocery_customer/screen/side_menu/Gig_Workers/gigSearchScreen.dart';
import 'package:insta_grocery_customer/screen/side_menu/Gig_Workers/gigWorkerAddProfile.dart';
import './gigProfileScreen.dart';
import '../../../controller/gigs_works_controller.dart';
import '../../../model/gigs_works_model.dart';
import './gigCategoryDetail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GigHub',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const GigHubHomeScreen(),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(GigsController());
      }),
    );
  }
}

class GigHubHomeScreen extends StatefulWidget {
  const GigHubHomeScreen({super.key});

  @override
  State<GigHubHomeScreen> createState() => _GigHubHomeScreenState();
}

class _GigHubHomeScreenState extends State<GigHubHomeScreen> {
  int _selectedIndex = 0;
  final GigsController gigsController = Get.put(GigsController());

  final List<Widget> _screens = [
    const HomeScreen(),
    // const GigSearchScreen(),
    const CreateProfileScreen(),
    const MyGigsScreen(),
     ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gigsController.getSuperCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColor().colorPrimary,
        unselectedItemColor: const Color(0xFF94A3B8),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search_outlined),
          //   activeIcon: Icon(Icons.search),
          //   label: 'Search',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'My Gigs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GigsController controller = Get.find<GigsController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.flash_on,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "GigHub",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const GigSearchScreen());
            },
            icon: const Icon(Icons.search, size: 22),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu feature coming soon')),
              );
            },
            icon: const Icon(Icons.menu, size: 22),
          ),
        ],
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                color: Colors.white,
                child: Column(
                  children: [
                    const Center(
                     child: Text.rich(
                TextSpan(
                  text: "Find skilled ", // default style
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.black, // base color
                  ),
                  children: [
                    TextSpan(
                      text: "Gigworkers\n", // highlighted word
                      style: TextStyle(
                        color: Colors.red, // custom color for Gigworkers
                      ),
                    ),
                    TextSpan(
                      text: "across every sector", // rest of the text
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        "The fastest way to hire local talent or find your next gig.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        controller.getCurrentLocation();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Obx(() => Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.locationController.text.isEmpty 
                                  ? "Your city or remote" 
                                  : controller.locationController.text,
                                style: const TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (controller.isGettingLocation.value)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Browse Sectors Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Browse Sectors',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore by specialized industry',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('View all categories')),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor().colorPrimary,
                    ),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            
            // Super Categories Grid - Responsive 3x3 Grid
            Obx(() {
              if (controller.isSuperCategoryLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (controller.superCategoryList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No categories available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
              
              // Calculate responsive grid properties
              final screenWidth = MediaQuery.of(context).size.width;
              final crossAxisCount = screenWidth < 600 ? 3 : (screenWidth < 900 ? 4 : 6);
              final childAspectRatio = screenWidth < 600 ? 0.9 : 1.0;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: controller.superCategoryList.length,
                  itemBuilder: (context, index) {
                    final category = controller.superCategoryList[index];
                    return SuperCategoryCard(
                      category: category,
                      onTap: () {
                        controller.getCategory(
                          superCategoryId: category.id,
                          superCategoryName: category.name,
                        );
                        // Navigate to category detail screen
                        Get.to(() => const CategoryDetailScreen());
                      },
                    );
                  },
                ),
              );
            }),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Super Category Card Widget with simple icon and image support
class SuperCategoryCard extends StatelessWidget {
  final GigsSuperCategoryModel category;
  final VoidCallback onTap;

  const SuperCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 600 ? 12.0 : 14.0;
    final iconSize = screenWidth < 600 ? 28.0 : 32.0;
    final containerSize = screenWidth < 600 ? 50.0 : 60.0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor().colorPrimary.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(screenWidth < 600 ? 8.0 : 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image or Icon
                Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    color: AppColor().colorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: category.image != null && category.image!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              category.image!,
                              width: containerSize,
                              height: containerSize,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.category_outlined,
                                  size: iconSize,
                                  color: AppColor().colorPrimary,
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: SizedBox(
                                    width: iconSize,
                                    height: iconSize,
                                    child: const CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.category_outlined,
                            size: iconSize,
                            color: AppColor().colorPrimary,
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                // Category Name
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Category Detail Screen (to show subcategories when a super category is tapped)

// Update your GigsSuperCategoryModel to include image field
// Add this to your model file:
/*
class GigsSuperCategoryModel {
  final int id;
  final String name;
  final String? image; // Add this field for category image

  GigsSuperCategoryModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory GigsSuperCategoryModel.fromJson(Map<String, dynamic> json) {
    return GigsSuperCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      image: json['image'] ?? json['icon'] ?? json['photo'], // Adjust based on your API response
    );
  }
}
*/