import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  _StopWatchScreenState createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen>
    with SingleTickerProviderStateMixin {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  late AnimationController controller;
  bool isPlaying = false;
  bool lapClicked = false;
  double value = 190.0;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
    scrollController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: AnimatedContainer(
                margin: EdgeInsets.only(top: value),
                child: Center(
                    child: StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                        initialData: _stopWatchTimer.rawTime.value,
                        builder: (context, snapshot) {
                          final value = snapshot.data;
                          final displayTime = StopWatchTimer.getDisplayTime(
                              value!,
                              hours: _isHours);
                          return Text(
                            displayTime,
                            style: GoogleFonts.lato(
                                fontSize: 40.0, color: Colors.white),
                          );
                        })),
                width: 350.0,
                height: 450.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5.0),
                    shape: BoxShape.circle),
                duration: const Duration(milliseconds: 900),
                curve: Curves.decelerate,
              ),
            ),
            Visibility(
              visible: lapClicked,
              child: SizedBox(
                height: 210.0,
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    if (value!.isEmpty) {
                      return Container();
                    }
                    Future.delayed(const Duration(milliseconds: 100), () {
                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease);
                    });
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final data = value[index];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Lap ${index + 1}',
                                    style: GoogleFonts.lato(
                                        fontSize: 30.0, color: Colors.white70),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text('${data.displayTime}',
                                      style: GoogleFonts.lato(
                                          fontSize: 30.0,
                                          color: Colors.white70)),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Opacity(
                                opacity: 0.1,
                                child: Divider(
                                  thickness: 1.5,
                                  color: Colors.white70,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      controller: scrollController,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 29.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                onPressed: isPlaying
                    ? null
                    : () {
                        setState(() {
                          value = 190.0;
                          lapClicked = false;
                        });
                        controller.reverse();
                        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                      },
                child: const Icon(
                  Icons.refresh,
                  size: 30.0,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  toggleIcon();
                  if (isPlaying == true) {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                  } else {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  }
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  size: 35.0,
                  progress: controller,
                ),
              ),
              FloatingActionButton(
                onPressed: isPlaying
                    ? () {
                        setState(() {
                          value = 10.0;
                          lapClicked = true;
                        });
                        _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                      }
                    : null,
                child: const Icon(
                  Icons.timer,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
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
