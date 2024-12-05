import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:presence_air_app/models/agendamento.dart';
import 'package:http_parser/http_parser.dart';

class AgendamentosService {
  final String baseUrl;

  AgendamentosService({String? baseUrl})
      : baseUrl = baseUrl ?? dotenv.env["url"] ?? "";

  var logger = Logger();

  Future<bool> cadastrarAgendamento(Agendamento agendamento) async {
    try {
      logger.d(agendamento.inicio);
      logger.d(agendamento.fim);

      final url = Uri.parse('$baseUrl/reservas');

      final DateTime now = DateTime.now();
      final String formattedDate =
          DateFormat('dd/MM/yyyy HH:mm:ss').format(now);

      logger.d(formattedDate);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'usuarioAtividade': agendamento.usuarioAtividade,
          'area': agendamento.area,
          'sala': agendamento.sala,
          'inicio': agendamento.inicio,
          'fim': agendamento.fim,
          'duracao': agendamento.duracao,
          'descricao': agendamento.descricao,
          'tipo': agendamento.tipo,
          'reservadoPor': agendamento.reservadoPor,
          'ultimaAtualizacao': formattedDate,
          'statusArcondicionado': agendamento.statusArcondicionado,
        }),
      );

      if (response.statusCode == 201) {
        logger.i('Agendamento cadastrado com sucesso.');
        return true;
      } else {
        logger.e('Falha ao cadastrar o agendamento: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e('Erro ao cadastrar agendamento: $e');
      return false;
    }
  }

  Future<bool> editarAgendamento(int id, Agendamento agendamento) async {
    try {
      final url = Uri.parse('$baseUrl/reservas/$id');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'usuarioAtividade': agendamento.usuarioAtividade,
          'area': agendamento.area,
          'sala': agendamento.sala,
          'inicio': agendamento.inicio,
          'fim': agendamento.fim,
          'duracao': agendamento.duracao,
          'descricao': agendamento.descricao,
          'tipo': agendamento.tipo,
          'reservadoPor': agendamento.reservadoPor,
          'ultimaAtualizacao': agendamento.ultimaAtualizacao,
          'statusArcondicionado': agendamento.statusArcondicionado,
        }),
      );

      if (response.statusCode == 200) {
        logger.i('Agendamento editado com sucesso.');
        return true;
      } else {
        logger.e('Falha ao editar o agendamento: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e('Erro ao editar agendamento: $e');
      return false;
    }
  }

  Future<bool> deletarAgendamento(int id) async {
    try {
      final url = Uri.parse('$baseUrl/reservas/$id');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        logger.i('Agendamento deletado com sucesso.');
        return true;
      } else {
        logger.e('Falha ao deletar o agendamento: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e('Erro ao deletar agendamento: $e');
      return false;
    }
  }

  Future<List<Agendamento>> listarAgendamentos({
    required startDate,
    required endDate,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reservas?p1=$startDate&p2=$endDate'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // .get(Uri.parse('$baseUrl/reservas?inicio=$startDate&fim=$endDate'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Agendamento.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> listarTempoDeUso({
    required startDate,
    required endDate,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reservas/consumo?p1=$startDate&p2=$endDate'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON
        final List<dynamic> data = jsonDecode(response.body);

        List<Map<String, dynamic>> tempoDeUso = [];
        for (var item in data) {
          tempoDeUso.add(Map<String, dynamic>.from(item));
        }

        return tempoDeUso;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Future<bool> enviarArquivoCSV({
    required Uint8List arquivoCSVBytes,
    required String nomeArquivo,
  }) async {
    final String url = '$baseUrl/upload-csv/';

    try {
      // Cria a requisição multipart
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Adiciona o arquivo CSV aos campos da requisição
      request.files.add(http.MultipartFile.fromBytes(
        'file', // Nome do campo esperado pela API
        arquivoCSVBytes,
        filename: nomeArquivo,
        contentType: MediaType('text', 'csv'),
      ));

      // Adiciona headers se necessário
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // Envia a requisição
      var response = await request.send();

      // Verifica o status da resposta
      if (response.statusCode == 200) {
        logger.i('Arquivo CSV enviado com sucesso!');
        return true;
      } else {
        final responseData = await response.stream.bytesToString();
        logger.e('Erro ao enviar o arquivo CSV: $responseData');
        return false;
      }
    } catch (e) {
      logger.e('Erro ao enviar o arquivo CSV: $e');
      return false;
    }
  }
}
