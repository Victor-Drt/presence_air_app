import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:presence_air_app/models/agendamento.dart';
import 'package:presence_air_app/services/agendamentos_service.dart';

List<String> salas = [
  "Comunicações Ópticas",
  "Lab. Programação I",
  "Lab. Programação IV",
  "MPCE",
  "Lab. Programação II",
  "Lab. Programação III",
  "Redes de Telecomunicações",
  "Sistemas de Telecom",
  "Indústria I",
  "Indústria II",
  "Indústria III",
  "Lab. FINEP",
  "Lab. FLL",
  "Lab. Prototipagem",
  "Laboratório de Biologia",
  "Laboratório de Desenho",
  "Laboratório de Eletrônica de Potência",
  "Lab. Robótica e Controle",
  "Lab. de Acionamentos/ CLP",
  "Lab. Hidrául./ Pneumática",
  "Lab. Metrologia",
  "Áudio e Vídeo",
  "Lab. de Automação",
  "Lab. de Física",
  "Lab. de Química",
];

class AgendamentoEdicaoScreen extends StatefulWidget {
  final Agendamento agendamento;

  const AgendamentoEdicaoScreen({super.key, required this.agendamento});

  @override
  State<AgendamentoEdicaoScreen> createState() =>
      _AgendamentoEdicaoScreenState();
}

class _AgendamentoEdicaoScreenState extends State<AgendamentoEdicaoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _atividadeController;
  late TextEditingController _areaController;
  late TextEditingController _salaController;
  late TextEditingController _inicioController;
  late TextEditingController _fimController;
  late TextEditingController _duracaoController;
  late TextEditingController _descricaoController;
  late TextEditingController _tipoController;
  late TextEditingController _reservadoPorController;

  DateTime? _inicioDateTime;
  DateTime? _fimDateTime;

  bool _statusArCondicionado = false;

  final AgendamentosService service = AgendamentosService();
  var logger = Logger();
  String dropdownValue = salas.first;

  @override
  void initState() {
    super.initState();
    _atividadeController =
        TextEditingController(text: widget.agendamento.usuarioAtividade);
    _areaController = TextEditingController(text: widget.agendamento.area);
    // _salaController = TextEditingController(text: widget.agendamento.sala);
    _inicioController = TextEditingController(text: widget.agendamento.inicio);
    _fimController = TextEditingController(text: widget.agendamento.fim);
    _duracaoController = TextEditingController(
        text: widget.agendamento.duracao?.toString() ?? '');
    _descricaoController =
        TextEditingController(text: widget.agendamento.descricao);
    _tipoController = TextEditingController(text: widget.agendamento.tipo);
    _reservadoPorController =
        TextEditingController(text: widget.agendamento.reservadoPor);

    _statusArCondicionado = widget.agendamento.statusArcondicionado ?? false;

    // Converte os valores iniciais de início e fim para DateTime
    _inicioDateTime = DateTime.tryParse(widget.agendamento.inicio ?? '');
    _fimDateTime = DateTime.tryParse(widget.agendamento.fim ?? '');

    dropdownValue = salas.firstWhere((e) => e == widget.agendamento.sala);

  }

  @override
  void dispose() {
    _atividadeController.dispose();
    _areaController.dispose();
    // _salaController.dispose();
    _inicioController.dispose();
    _fimController.dispose();
    _duracaoController.dispose();
    _descricaoController.dispose();
    _tipoController.dispose();
    _reservadoPorController.dispose();
    super.dispose();
  }

  void _calcularDuracao() {
    if (_inicioDateTime != null && _fimDateTime != null) {
      final duration =
          _fimDateTime!.difference(_inicioDateTime!).inMinutes / 60;
      setState(() {
        _duracaoController.text = duration.toStringAsFixed(2);
      });
    }
  }

  Future<void> _selectDateTime(
      TextEditingController controller, bool isInicio) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isInicio) {
            _inicioDateTime = fullDateTime;
            _inicioController.text =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime);
          } else {
            _fimDateTime = fullDateTime;
            _fimController.text =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime);
          }
        });

        _calcularDuracao();
      }
    }
  }

  void _salvarEdicao() async {
    if (_formKey.currentState!.validate()) {
      widget.agendamento.usuarioAtividade = _atividadeController.text;
      widget.agendamento.area = _areaController.text;
      widget.agendamento.sala = dropdownValue;
      // widget.agendamento.inicio = _inicioController.text;
      // widget.agendamento.fim = _fimController.text;
      widget.agendamento.inicio = _inicioController.text;
      widget.agendamento.fim = _fimController.text;
      widget.agendamento.duracao = double.tryParse(_duracaoController.text);
      widget.agendamento.descricao = _descricaoController.text;
      widget.agendamento.tipo = _tipoController.text;
      widget.agendamento.reservadoPor = _reservadoPorController.text;
      widget.agendamento.statusArcondicionado = _statusArCondicionado;

      try {
        bool response = await service.editarAgendamento(
            widget.agendamento.id!, widget.agendamento);

        if (response) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Não foi possível salvar o agendamento!')),
          );
        }
      } catch (e) {
        logger.e(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Agendamento',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(114, 187, 57, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Atividade', _atividadeController, true),
              _buildTextField('Área', _areaController, true),
              DropdownButton(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.green,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: salas.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()),

              // _buildTextField('Sala', _salaController, true),
              _buildDateTimePicker('Início', _inicioController, true),
              _buildDateTimePicker('Fim', _fimController, false),
              _buildTextField('Duração (horas)', _duracaoController, false,
                  isNumber: true),
              _buildTextField('Descrição', _descricaoController, false),
              _buildTextField('Tipo', _tipoController, true),
              _buildTextField('Reservado por', _reservadoPorController, true),
              SwitchListTile(
                title: const Text('Status Ar Condicionado'),
                value: _statusArCondicionado,
                onChanged: (value) {
                  setState(() {
                    _statusArCondicionado = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _salvarEdicao,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isRequired,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: isRequired
          ? (value) =>
              value == null || value.isEmpty ? 'Campo obrigatório' : null
          : null,
    );
  }

  Widget _buildDateTimePicker(
      String label, TextEditingController controller, bool isInicio) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(labelText: label),
      onTap: () => _selectDateTime(controller, isInicio),
      validator: (value) =>
          value == null || value.isEmpty ? 'Campo obrigatório' : null,
    );
  }
}
