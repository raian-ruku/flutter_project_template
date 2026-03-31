import 'di_container.dart' as d;
import 'package:simplified_text_widget/configuration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await d.init();
  await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // OneSignal.initialize(dotenv.env['ONESIGNAL_APPID']!);
  // OneSignal.Notifications.requestPermission(true);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => d.i<ConnectivityBloc>()),
        BlocProvider(create: (context) => d.i<AuthBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SimplifiedTextWidgetConfig.config(
      responsiveFonts: true,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return ConnectivityWrapper(child: child!);
      },
      // ! set your home here
      // home: LoginPage(),
    );
  }
}
