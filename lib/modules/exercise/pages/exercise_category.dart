import 'package:fitness_health_tracker/modules/exercise/pages/exercise_detail.dart';
import 'package:fitness_health_tracker/modules/exercise/widgets/exercise-category-tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/pages/settings.dart';
import '../../dashboard/pages/home_page.dart';

class ExerciseCategory extends StatefulWidget {
  const ExerciseCategory({super.key});

  @override
  State<ExerciseCategory> createState() => _ExerciseCategoryState();
}

class _ExerciseCategoryState extends State<ExerciseCategory> {
  final List<Map<String, dynamic>> exercises = [
    {
      "category": "Abs",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2Fabs.png?alt=media&token=7676f672-aef8-4c62-a21d-16cf538c37ce",
      "subtitle": "Core and stability exercises",
      "items": [
        {
          "name": "Crunches",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_a63q79a63q79a63q.jpeg?alt=media&token=7457684d-31fe-4a7a-bd42-eb3b1ad5b9f0"
        },
        {
          "name": "Leg Raises",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_dfj85idfj85idfj8.jpeg?alt=media&token=649c2593-2978-44e5-9ead-9580e2fecce8"
        },
        {
          "name": "Plank",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_gf4bfxgf4bfxgf4b.jpeg?alt=media&token=464ff648-ba1a-4904-a8da-29ac93d2c020"
        },
      ],
    },
    {
      "category": "Chest",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2Fchest.png?alt=media&token=572a97c1-e12b-4528-9a27-96cf39d3105c",
      "subtitle": "Push-ups and chest presses",
      "items": [
        {
          "name": "Push-ups",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_39nckd39nckd39nc.jpeg?alt=media&token=8d64ae15-1eb9-457c-81c8-bc7f228d4d90"
        },
        {
          "name": "Bench Press",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_x28gzux28gzux28g.jpeg?alt=media&token=1c4e5627-b6a3-41ed-b966-2cbf0e5c9bdd"
        },
        {
          "name": "Dumbbell Fly",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_33rqur33rqur33rq.jpeg?alt=media&token=addcac52-e2de-43d6-8bbc-42c306af6052"
        },
      ],
    },
    {
      "category": "Back",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2Fback.png?alt=media&token=5cb49fdd-a26a-4ab7-b776-f889a1c62cd7",
      "subtitle": "Pull-ups and rows",
      "items": [
        {
          "name": "Pull-ups",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_uk1fkiuk1fkiuk1f.jpeg?alt=media&token=cf17312e-f611-449c-858c-bac03bf40dc9"
        },
        {
          "name": "Deadlifts",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_feflqmfeflqmfefl.jpeg?alt=media&token=05cbb3ab-5ddf-44df-aaa4-92c34776a4df"
        },
        {
          "name": "Lat Pulldown",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_br4mlvbr4mlvbr4m.jpeg?alt=media&token=a2803b3c-5dc3-48ec-9087-79c52e055d5a"
        },
      ],
    },
    {
      "category": "Arms",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2Farms.png?alt=media&token=2bd3c169-a1e9-40a7-9851-51c846b8b9d2",
      "subtitle": "Curls and triceps extensions",
      "items": [
        {
          "name": "Bicep Curls",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_idsn4sidsn4sidsn.jpeg?alt=media&token=07b7c38f-b8c5-45f9-98ee-918a12cc35d5"
        },
        {
          "name": "Tricep Dips",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_b651hrb651hrb651.jpeg?alt=media&token=9fcd5830-65a9-43a7-8b55-5ae408ea67ba"
        },
        {
          "name": "Hammer Curls",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_yfsus5yfsus5yfsu.jpeg?alt=media&token=642a70cb-980b-46d5-b679-b60f12548b0b"
        },
      ],
    },
    {
      "category": "Legs",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2Flegs.png?alt=media&token=fbb67701-d58c-4ef2-9885-cba59f57702a",
      "subtitle": "Squats and lunges",
      "items": [
        {
          "name": "Squats",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_j439ltj439ltj439.jpeg?alt=media&token=516abbea-bce2-4da2-a197-f9bc853a8415"
        },
        {
          "name": "Lunges",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_vzc4e3vzc4e3vzc4.jpeg?alt=media&token=6395f629-a141-411b-83f3-176495916344"
        },
        {
          "name": "Leg Press",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_lxwqxjlxwqxjlxwq.jpeg?alt=media&token=efcd29ba-2b99-4c33-bdd4-50f01e1e38ff"
        },
      ],
    },
    {
      "category": "Shoulders",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2Fshoulders.png?alt=media&token=57d1b77a-94d8-4c3e-b7d3-754db086aaac",
      "subtitle": "Overhead presses",
      "items": [
        {
          "name": "Shoulder Press",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_lpkuimlpkuimlpku.jpeg?alt=media&token=91bc8b77-a874-4450-ada5-052c2bc86d2d"
        },
        {
          "name": "Lateral Raises",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_aq9qa4aq9qa4aq9q.jpeg?alt=media&token=bddd2051-4228-41ad-af69-06b57689303b"
        },
        {
          "name": "Front Raises",
          "image":
              "https://firebasestorage.googleapis.com/v0/b/adtip-1eb9e.appspot.com/o/health-tracker%2FGemini_Generated_Image_lcb9o1lcb9o1lcb9.jpeg?alt=media&token=b2bb1bdd-079c-41f9-8221-6ecf6bbb7f5c"
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Color(0xFFE8F4F8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, -3), // shadow above the container
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double iconSize = screenWidth * 0.08;
                  double fontSize = screenWidth * 0.03;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => HomePage());
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/home/home.png',
                              height: iconSize,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Home',
                              style: GoogleFonts.poppins(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => SettingsPage());
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/home/profile.png',
                              height: iconSize,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Profile',
                              style: GoogleFonts.poppins(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double padding = screenWidth * 0.05;
          double buttonHeight = screenWidth * 0.12;
          double fontSize = screenWidth * 0.04;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Choose the category',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final item = exercises[index];
                        return ExerciseCategoryTile(
                          image: item['image'],
                          title: item['category'],
                          subtitle: item['subtitle'],
                          function: () {
                            Get.to(() => ExerciseDetails(
                                  data: item['items'],
                                  title: item['category'],
                                ));
                          },
                        );
                      }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
