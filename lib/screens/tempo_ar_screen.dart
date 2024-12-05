import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:logger/logger.dart';
import 'package:presence_air_app/services/agendamentos_service.dart';

class TempoArScreen extends StatefulWidget {
  const TempoArScreen({super.key});

  @override
  _TempoArScreenState createState() => _TempoArScreenState();
}

class _TempoArScreenState extends State<TempoArScreen> {
  final AgendamentosService service = AgendamentosService();
  List<Map<String, dynamic>> tempoDeUso = [];

  DateTime? startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  bool isLoading = true;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchTempoDeUso();
  }

  Future<void> _fetchTempoDeUso() async {
    setState(() {
      isLoading = true;
    });
    try {
      final resultado = await service.listarTempoDeUso(
          startDate: startDate, endDate: endDate);
      setState(() {
        tempoDeUso = resultado;
        isLoading = false;
      });

    } catch (e) {
      logger.e(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  // Função para gerar os dados do gráfico conforme o período
  List<BarChartGroupData> _gerarDados(List<Map<String, dynamic>> dados) {
    return dados.map((data) {
      return BarChartGroupData(
        x: dados.indexOf(data), // Índice para cada grupo
        barRods: [
          BarChartRodData(
            fromY: 0, // Começa do eixo Y
            toY: (data['tempoLigadoMinutos'].toDouble() * 100).roundToDouble() /
                100, // O valor máximo de tempo (em minutos)
            color: Colors.blue,
            width: 25,
          ),
        ],
      );
    }).toList();
  }

  // Função mock para simular a requisição de dados por período
  void _alterarPeriodo(String periodo) {
    setState(() {
      if (periodo == "Mês") {
        startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
      } else if (periodo == "Dia") {
        startDate = DateTime.now();
        endDate = DateTime.now();
      } else if (periodo == "Semana") {
        DateTime today = DateTime.now();
        int weekday = today.weekday;
        startDate = today.subtract(Duration(days: weekday - 1));
        endDate = today.add(Duration(days: 7 - weekday));
      }
      _fetchTempoDeUso();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gráfico de Tempo de Uso em Minutos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botões para selecionar o período
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _alterarPeriodo("Mês"),
                  child: Text("Mês"),
                ),
                ElevatedButton(
                  onPressed: () => _alterarPeriodo("Dia"),
                  child: Text("Dia"),
                ),
                ElevatedButton(
                  onPressed: () => _alterarPeriodo("Semana"),
                  child: Text("Semana"),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Gráfico de Barras
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              getTitlesWidget: (value, meta) {
                                return Text(tempoDeUso[value.toInt()]["sala"]);
                              },
                              showTitles: true,
                            ),
                          ),
                          show: true,
                        ),
                        borderData: FlBorderData(show: true),
                        barGroups: _gerarDados(
                            tempoDeUso), // Passa os dados para o gráfico
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
