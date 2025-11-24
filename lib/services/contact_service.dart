import 'package:dio/dio.dart';

import '../models/contact.dart';
import 'api_client.dart';

class ContactService {
  ContactService({Dio? client}) : _client = client ?? ApiClient.instance;

  final Dio _client;

  Future<void> sendContact(ContactRequest request) async {
    await _client.post('/contact', data: request.toJson());
  }

  Future<void> sendTopic(TopicRequest request) async {
    await _client.post('/forum/topics', data: request.toJson());
  }
}


