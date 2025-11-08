import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String _baseUrl = 'https://decisivebytes-skin.hf.space/gradio_api';

  Future<String?> getSkinType(File image) async {
    try {
      final imageBytes = await image.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      final mimeType = image.path.split('.').last;
      final dataUri = 'data:image/$mimeType;base64,$base64Image';

      // 2. Initial POST request to get event_id
      final postResponse = await http.post(
        Uri.parse('$_baseUrl/call/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data': [dataUri],
        }),
      );

      if (postResponse.statusCode != 200) {
        // Handle error
        debugPrint('Error posting initial request: ${postResponse.body}');
        return null;
      }

      final postBody = jsonDecode(postResponse.body);
      final eventId = postBody['event_id'];
      if (eventId == null) {
        debugPrint('Could not find event_id in response');
        return null;
      }

      final eventUrl = '$_baseUrl/call/predict/$eventId';
      final client = http.Client(); // IMPORTANT: Need a persistent client for streaming
      final request = http.Request('GET', Uri.parse(eventUrl));

      request.headers['Accept'] = 'text/event-stream';
      request.headers['Cache-Control'] = 'no-cache';
      request.headers['Connection'] = 'keep-alive';

      final streamedResponse = await client.send(request);

      await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
        // Check for the SSE "data:" prefix
        if (chunk.startsWith('data:')) {
          final jsonData = chunk.substring('data: '.length).trim();
          try {
            final data = jsonDecode(jsonData);
            if (data['msg'] == 'process_completed') {
              client.close();
              // The result is the first element of the data array
              final result = data['output']['data'][0];
              return result.toString();
            }
          } catch (e) {
            // Handle cases where the data part isn't valid JSON (e.g., pings or errors)
            debugPrint('Error parsing streaming event JSON: $e');
          }
        }
      }

      client.close();
      debugPrint('Stream closed before receiving process_completed.');
      return null;

    } catch (e) {
      debugPrint('An error occurred in getSkinType: $e');
      return null;
    }
  }
}