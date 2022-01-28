import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_timer/simple_timer.dart';


class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  bool isPlaying = false;

  @override
  void onInit() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SimpleTimer(
            progressIndicatorColor: Colors.blue,
            status: TimerStatus.start,
            duration: Duration(minutes: 1),
          )
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(
              Icons.refresh,
              size: 30.0,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              toggleIcon();
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              size: 35.0,
              progress: controller,
            ),
          ),
          FloatingActionButton(
              onPressed: () {},
              child: const Icon(
                Icons.timer,
                size: 30.0,
              )),
        ],
      ),
    );
  }

  void toggleIcon() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? controller.forward() : controller.reverse();
    });
  }
}
