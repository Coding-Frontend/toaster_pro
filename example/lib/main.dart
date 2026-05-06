import 'package:flutter/material.dart';
import 'package:toaster_pro/toaster_pro.dart';

void main() {
  runApp(const ToasterProExampleApp());
}

/// Root app — wires [ToasterPro.navigatorKey] once so toasts can be
/// shown from anywhere without a [BuildContext].
class ToasterProExampleApp extends StatefulWidget {
  const ToasterProExampleApp({super.key});

  @override
  State<ToasterProExampleApp> createState() => _ToasterProExampleAppState();
}

class _ToasterProExampleAppState extends State<ToasterProExampleApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToasterPro.navigatorKey = _navKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      title: 'ToasterPro Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Demo screen
// ─────────────────────────────────────────────────────────────────────────────

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  DelightSnackbarPosition _position = DelightSnackbarPosition.bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text('ToasterPro Demo'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Position toggle ─────────────────────────────────────────────
            _SectionLabel('Position'),
            const SizedBox(height: 8),
            SegmentedButton<DelightSnackbarPosition>(
              segments: const [
                ButtonSegment(
                  value: DelightSnackbarPosition.bottom,
                  label: Text('Bottom'),
                  icon: Icon(Icons.vertical_align_bottom),
                ),
                ButtonSegment(
                  value: DelightSnackbarPosition.top,
                  label: Text('Top'),
                  icon: Icon(Icons.vertical_align_top),
                ),
              ],
              selected: {_position},
              onSelectionChanged: (s) => setState(() => _position = s.first),
            ),

            const SizedBox(height: 32),

            // ── Convenience API ─────────────────────────────────────────────
            _SectionLabel('ToasterPro Convenience API'),
            const SizedBox(height: 12),
            _ToastButton(
              label: 'Success',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF4CAF50),
              onTap: () => ToasterPro.show(
                title: 'Success!',
                message: 'Your changes were saved.',
                type: ToastType.success,
                position: _position,
              ),
            ),
            const SizedBox(height: 10),
            _ToastButton(
              label: 'Error',
              icon: Icons.error_rounded,
              color: const Color(0xFFE8505B),
              onTap: () => ToasterPro.show(
                title: 'Error',
                message: 'Something went wrong. Please try again.',
                type: ToastType.error,
                position: _position,
              ),
            ),
            const SizedBox(height: 10),
            _ToastButton(
              label: 'Warning',
              icon: Icons.warning_rounded,
              color: const Color(0xFFFF9800),
              onTap: () => ToasterPro.show(
                title: 'Warning',
                message: 'Your session will expire in 5 minutes.',
                type: ToastType.warning,
                position: _position,
              ),
            ),
            const SizedBox(height: 10),
            _ToastButton(
              label: 'Info',
              icon: Icons.info_rounded,
              color: const Color(0xFF2196F3),
              onTap: () => ToasterPro.show(
                title: 'Info',
                message: 'A new update is available.',
                type: ToastType.info,
                position: _position,
              ),
            ),

            const SizedBox(height: 32),

            // ── With tap action ──────────────────────────────────────────────
            _SectionLabel('With Tap Action'),
            const SizedBox(height: 12),
            _ToastButton(
              label: 'Tap me!',
              icon: Icons.touch_app_rounded,
              color: const Color(0xFF6C63FF),
              onTap: () => ToasterPro.show(
                title: 'New Message',
                message: 'Tap this toast to open details.',
                type: ToastType.info,
                position: _position,
                onTap: () => _showDetails(context),
              ),
            ),

            const SizedBox(height: 32),

            // ── Long duration ────────────────────────────────────────────────
            _SectionLabel('Custom Duration'),
            const SizedBox(height: 12),
            _ToastButton(
              label: '8-second toast',
              icon: Icons.timer_rounded,
              color: const Color(0xFF607D8B),
              onTap: () => ToasterPro.show(
                title: 'Long Toast',
                message: 'This one sticks around for 8 seconds.',
                type: ToastType.info,
                position: _position,
                duration: const Duration(seconds: 8),
              ),
            ),

            const SizedBox(height: 32),

            // ── Stack demo ───────────────────────────────────────────────────
            _SectionLabel('Stacking (3 toasts at once)'),
            const SizedBox(height: 12),
            _ToastButton(
              label: 'Stack toasts',
              icon: Icons.layers_rounded,
              color: const Color(0xFF9C27B0),
              onTap: () {
                ToasterPro.show(
                  title: 'First',
                  message: 'I was first!',
                  type: ToastType.success,
                  position: _position,
                );
                Future.delayed(const Duration(milliseconds: 300), () {
                  ToasterPro.show(
                    title: 'Second',
                    message: 'I came second.',
                    type: ToastType.warning,
                    position: _position,
                  );
                });
                Future.delayed(const Duration(milliseconds: 600), () {
                  ToasterPro.show(
                    title: 'Third',
                    message: 'I am last!',
                    type: ToastType.error,
                    position: _position,
                  );
                });
              },
            ),

            const SizedBox(height: 32),

            // ── Low-level API ────────────────────────────────────────────────
            _SectionLabel('Low-level DelightToastBar API'),
            const SizedBox(height: 12),
            _ToastButton(
              label: 'Custom card',
              icon: Icons.widgets_rounded,
              color: const Color(0xFF00BCD4),
              onTap: () {
                DelightToastBar(
                  autoDismiss: true,
                  position: _position,
                  builder: (_) => ToastCard(
                    color: const Color(0xFF212121),
                    leading: const Icon(Icons.rocket_launch_rounded,
                        color: Colors.white, size: 22),
                    title: const Text(
                      'Custom Card',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Built with DelightToastBar directly.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ).show(context);
              },
            ),

            const SizedBox(height: 32),

            // ── Dismiss all ──────────────────────────────────────────────────
            FilledButton.tonal(
              onPressed: () => DelightToastBar.removeAll(),
              child: const Text('Dismiss All Active Toasts'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Message Details'),
        content: const Text(
            'You tapped the toast! This is the onTap handler at work.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
    );
  }
}

class _ToastButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ToastButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
