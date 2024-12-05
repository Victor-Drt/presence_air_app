import 'package:flutter/material.dart';
import 'package:presence_air_app/screens/agendamentos_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:presence_air_app/screens/importacao_agendamentos_screen.dart';
import 'package:presence_air_app/screens/tempo_ar_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PresenceAir',
      color: Color.fromRGBO(114, 187, 57, 1),
      home: MyHomePage(title: 'PresenceAir'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(114, 187, 57, 1),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
            child: Column(
          children: [
            ListTile(
              title: const Row(
                children: [Icon(Icons.schedule_outlined), Text("Agendamentos")],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgendamentosScreen(),
                    ));
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.table_view_outlined),
                  Text("Importar Planilha")
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImportacaoAgendamentoScreen(),
                    ));
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.equalizer_outlined),
                  Text("Tempo de Uso")
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TempoArScreen(),
                    ));
              },
            ),
            // ListTile(
            //   title: const Row(
            //     children: [
            //       Icon(Icons.notifications_none_outlined),
            //       Text("Notificações")
            //     ],
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => Placeholder(),
            //         ));
            //   },
            // ),
            ListTile(
              title: const Row(
                children: [Icon(Icons.logout_outlined), Text("Sair")],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Placeholder(),
                    ));
              },
            ),
          ],
        )),
        body: const AgendamentosScreen());
  }
}
