import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:presence_air_app/models/agendamento.dart';
import 'package:presence_air_app/screens/agendamento_cadastrar_screen.dart';
import 'package:presence_air_app/screens/agendamento_detalhes_screen.dart';
import 'package:presence_air_app/screens/agendamento_edicao_screen.dart';
import 'package:presence_air_app/services/agendamentos_service.dart';

class AgendamentosScreen extends StatefulWidget {
  const AgendamentosScreen({super.key});

  @override
  State<AgendamentosScreen> createState() => _AgendamentosScreenState();
}

class _AgendamentosScreenState extends State<AgendamentosScreen> {
  DateTime? startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');
  final service = AgendamentosService();
  var logger = Logger();

  List<Agendamento> listAgendamentos = [];
  List<Agendamento> filteredAgendamentos = [];
  bool isLoading = true;

  // Controladores para filtros
  final TextEditingController usuarioAtividadeFilter = TextEditingController();
  final TextEditingController areaFilter = TextEditingController();
  final TextEditingController salaFilter = TextEditingController();
  final TextEditingController tipoFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAgendamentos();
  }

  Future<void> _fetchAgendamentos() async {
    try {
      final agendamentos = await service.listarAgendamentos(
        startDate: startDate,
        endDate: endDate,
      );
      setState(() {
        listAgendamentos = agendamentos;
        filteredAgendamentos = listAgendamentos;
        isLoading = false;
      });
    } catch (e) {
      logger.e(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      filteredAgendamentos = listAgendamentos.where((agendamento) {
        final usuarioAtividade =
            agendamento.usuarioAtividade?.toLowerCase() ?? '';
        final area = agendamento.area?.toLowerCase() ?? '';
        final sala = agendamento.sala?.toLowerCase() ?? '';
        final tipo = agendamento.tipo?.toLowerCase() ?? '';

        final usuarioFilter = usuarioAtividadeFilter.text.toLowerCase();
        final areaFilterText = areaFilter.text.toLowerCase();
        final salaFilterText = salaFilter.text.toLowerCase();
        final tipoFilterText = tipoFilter.text.toLowerCase();

        return usuarioAtividade.contains(usuarioFilter) &&
            area.contains(areaFilterText) &&
            sala.contains(salaFilterText) &&
            tipo.contains(tipoFilterText);
      }).toList();
    });
  }

  Future<void> _deleteAgendamento(int? id) async {
    if (id != null) {
      bool sucesso = await service.deletarAgendamento(id);

      if (sucesso) {
        setState(() {
          listAgendamentos.removeWhere((agendamento) => agendamento.id == id);
          _applyFilters();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agendamento deletado com sucesso.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao deletar agendamento.')),
        );
      }
    }
  }

  void _editarAgendamento(Agendamento agendamento) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AgendamentoEdicaoScreen(agendamento: agendamento),
        ));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
      _fetchAgendamentos();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
      _fetchAgendamentos();
    }
  }

  _abrirDetalhes(Agendamento agendamento) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AgendamentoDetalheScreen(agendamento: agendamento),
        ));
  }

  List<DataRow> _buildDataRows() {
    return filteredAgendamentos.map((agendamento) {
      return DataRow(
        cells: <DataCell>[
          // DataCell(Text(agendamento.id?.toString() ?? '')),
          DataCell(Text(agendamento.usuarioAtividade ?? ''),
              onTap: () => _abrirDetalhes(agendamento)),
          DataCell(Text(agendamento.area ?? '')),
          DataCell(Text(agendamento.sala ?? '')),
          DataCell(Text(agendamento.inicio ?? '')),
          DataCell(Text(agendamento.fim ?? '')),
          // DataCell(Text(agendamento.duracao?.toString() ?? '')),
          // DataCell(Text(agendamento.descricao ?? '')),
          DataCell(Text(agendamento.tipo ?? '')),
          // DataCell(Text(agendamento.reservadoPor ?? '')),
          // DataCell(Text(agendamento.ultimaAtualizacao ?? '')),
          DataCell(Icon(
            Icons.fiber_manual_record_rounded,
            color:
                agendamento.statusArcondicionado! ? Colors.green : Colors.red,
          )),
          // DataCell(
          //     Text(agendamento.statusArcondicionado == true ? 'Sim' : 'Não')),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editarAgendamento(agendamento);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    _deleteAgendamento(agendamento.id);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    child: ElevatedButton(
                        onPressed: _adicionarLinha,
                        child: Text("Adicionar Agendamento")),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _selectStartDate(context),
                        child: Text("De: ${formattedDate.format(startDate!)}"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _selectEndDate(context),
                        child: Text("Até: ${formattedDate.format(endDate!)}"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: usuarioAtividadeFilter,
                          decoration: const InputDecoration(
                              labelText: 'Filtrar por Usuário'),
                          onChanged: (value) => _applyFilters(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: areaFilter,
                          decoration: const InputDecoration(
                              labelText: 'Filtrar por Área'),
                          onChanged: (value) => _applyFilters(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: salaFilter,
                          decoration: const InputDecoration(
                              labelText: 'Filtrar por Sala'),
                          onChanged: (value) => _applyFilters(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: tipoFilter,
                          decoration: const InputDecoration(
                              labelText: 'Filtrar por Tipo'),
                          onChanged: (value) => _applyFilters(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: const WidgetStatePropertyAll(
                          Color.fromRGBO(114, 187, 57, 1)),
                      headingTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      border: TableBorder.all(width: 1),
                      columns: const <DataColumn>[
                        // DataColumn(
                        //     label: Text('ID',
                        //         style: TextStyle(fontStyle: FontStyle.italic))),
                        DataColumn(
                            label: Text('Usuário / Atividade',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                        DataColumn(
                            label: Text('Área',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                        DataColumn(
                            label: Text('Sala',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                        DataColumn(
                            label: Text('Início',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                        DataColumn(
                            label: Text('Fim',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                        // DataColumn(
                        //     label: Text('Duração (h)',
                        //         style: TextStyle(fontStyle: FontStyle.italic))),
                        // DataColumn(
                        //     label: Text('Descrição',
                        //         style: TextStyle(fontStyle: FontStyle.italic))),
                        DataColumn(
                            label: Text('Tipo',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                        // DataColumn(
                        //     label: Text('Reservado Por',
                        //         style: TextStyle(fontStyle: FontStyle.italic))),
                        // DataColumn(
                        //     label: Text('Última Atualização',
                        //         style: TextStyle(fontStyle: FontStyle.italic))),
                        DataColumn(
                            label: Text('Status Ar',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                        DataColumn(
                            label: Text('Ação',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                      ],
                      rows: _buildDataRows(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _adicionarLinha() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgendamentoCadastrarScreen(),
        ));
  }
}
