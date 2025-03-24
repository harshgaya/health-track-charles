import 'package:flutter/material.dart';

class WeightRulerScreen extends StatefulWidget {
  const WeightRulerScreen({Key? key}) : super(key: key);

  @override
  _WeightRulerScreenState createState() => _WeightRulerScreenState();
}

class _WeightRulerScreenState extends State<WeightRulerScreen> {
  final double minWeight = 50; // Min weight in lbs
  final double maxWeight = 300; // Max weight in lbs
  final double division = 1; // 1 lb increments
  final double itemWidth = 12; // Space between tick marks
  late ScrollController _scrollController;
  double selectedWeight = 160; // Default selected weight

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: (selectedWeight - minWeight) * itemWidth,
    );
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    double newWeight = (offset / itemWidth) + minWeight;
    setState(() {
      selectedWeight = newWeight.roundToDouble();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "How much do you weigh?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),

          // Selected weight display
          Text(
            "${selectedWeight.toInt()} lbs",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          // Horizontal Ruler
          Stack(
            alignment: Alignment.center,
            children: [
              // Scrollable Ruler
              SizedBox(
                height: 80,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      _onScroll();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: ((maxWeight - minWeight) / division).round() + 1,
                    itemBuilder: (context, index) {
                      double weight = minWeight + (index * division);
                      bool isMajor = weight % 10 == 0;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 2,
                            height: isMajor ? 40 : 20,
                            color: Colors.pinkAccent,
                          ),
                          if (isMajor)
                            Text(
                              weight.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Center Indicator
              Positioned(
                child: Container(
                  width: 3,
                  height: 50,
                  color: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
