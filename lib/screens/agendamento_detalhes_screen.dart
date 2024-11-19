import 'package:flutter/material.dart';
import 'package:presence_air_app/models/agendamento.dart';

class AgendamentoDetalheScreen extends StatefulWidget {
  final Agendamento agendamento;

  const AgendamentoDetalheScreen({super.key, required this.agendamento});

  @override
  State<AgendamentoDetalheScreen> createState() =>
      _AgendamentoDetalheScreenState();
}

class _AgendamentoDetalheScreenState extends State<AgendamentoDetalheScreen> {
  @override
  Widget build(BuildContext context) {
    // Usando o MediaQuery para tornar a tela responsiva
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Agendamento', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(114, 187, 57, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Exemplo de exibição dos detalhes do agendamento
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atividade: ${widget.agendamento.usuarioAtividade}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(114, 187, 57, 1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Área: ${widget.agendamento.area}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sala: ${widget.agendamento.sala}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Início: ${widget.agendamento.inicio}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fim: ${widget.agendamento.fim}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duração: ${widget.agendamento.duracao} horas',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Descrição: ${widget.agendamento.descricao ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tipo: ${widget.agendamento.tipo}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reservado por: ${widget.agendamento.reservadoPor}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Última atualização: ${widget.agendamento.ultimaAtualizacao}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status Ar Condicionado: ${widget.agendamento.statusArcondicionado! ? "Ligado" : "Desligado"}',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.agendamento.statusArcondicionado! ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Botão de ação, por exemplo, editar ou voltar
            ElevatedButton(
              onPressed: () {
                // Ação do botão, por exemplo, voltar
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Voltar',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
