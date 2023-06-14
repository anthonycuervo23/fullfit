import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/config/constants/constants.dart';

//PROVIDER
final openAIProvider =
    StateNotifierProvider<OpenAINotifier, OpenAIState>((ref) {
  return OpenAINotifier();
});

//NOTIFIER
class OpenAINotifier extends StateNotifier<OpenAIState> {
  late OpenAI _openAI;

  OpenAINotifier() : super(OpenAIState()) {
    initOpenAISdk();
  }

  ///[initOpenAISdk]
  void initOpenAISdk() {
    _openAI = OpenAI.instance.build(
      token: Environment.openAiApiKey,
      enableLog: true,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
  }

  void sendMessageWithPrompt() {
    ///messages of chat

    // Copia los mensajes actuales para modificarlos.
    List<Message> currentMessages = List.from(state.messages);

    // Añade el nuevo mensaje a la lista de mensajes.
    currentMessages
        .add(Message(isBot: false, message: getTextInput().value.text));

    // Actualiza el estado para mostrar el mensaje del usuario en la interfaz de usuario.
    state = state.copyWith(
        showLoading: true, isClear: false, messages: currentMessages);

    // Convierte todos los mensajes a la estructura requerida por la API.
    List<Messages> openAIMessages = currentMessages.map((message) {
      return Messages(
          role: message.isBot ? Role.system : Role.user,
          content: message.message);
    }).toList();

    // Añade un mensaje inicial para el rol `system` al principio de la lista de mensajes.
    openAIMessages.insert(
        0,
        Messages(
            role: Role.system,
            content:
                "You are a Personal Trainer and Nutritionist that will help the user to achieve their goals and answer all their questions about excercises and nutrition."));
    // Crea la solicitud para la API de OpenAI.
    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: openAIMessages,
      maxToken: 800,
    );

    // Limpia el campo de texto.
    getTextInput().text = "";

//     state = state.copyWith(
//         showLoading: true,
//         isClear: false,
//         messages: List.from(state.messages)
//           ..add(Message(isBot: false, message: getTextInput().value.text)));
// //GptTurboChatModel()
//     final request = ChatCompleteText(
//       model: GptTurboChatModel(),
//       messages: [
//         Messages(role: Role.user, content: getTextInput().value.text),
//       ],
//       maxToken: 800,
//     );

//     ///clear text
//     getTextInput().text = "";

    _openAI
        .onChatCompletionSSE(request: request, onCancel: onCancel)
        .transform(StreamTransformer.fromHandlers(handleError: handleError))
        .listen((it) {
      Message? message;
      for (final m in state.messages) {
        if (m.id == '${it.id}') {
          message = m;
          state =
              state.copyWith(messages: List.from(state.messages)..remove(m));
          break;
        }
      }

      ///+= message
      message?.message =
          '${message.message ?? ""}${it.choices.last.message?.content ?? ""}';
      state = state.copyWith(
          messages: List.from(state.messages)
            ..add(Message(
                isBot: true, id: '${it.id}', message: message?.message)));
    }, onDone: () {
      state = state.copyWith(
        showLoading: false,
        isBot: true,
      );
    });
  }

  /// text controller
  final _txtInput = TextEditingController();
  TextEditingController getTextInput() => _txtInput;

  void onStopGenerate() {
    state = state.copyWith(showLoading: false, isBot: true);

    mCancel?.cancelToken.cancel("canceled ");
  }

  void closeOpenAIError() {
    state = state.copyWith(openAIError: true);
  }

  void disposeController() {
    _txtInput.dispose();
  }

  void clearMessage() {
    state = state.copyWith(messages: [], isClear: true);
  }

  CancelData? mCancel;
  void onCancel(CancelData cancelData) {
    mCancel = cancelData;
  }

  void handleError(Object error, StackTrace t, EventSink<dynamic> eventSink) {
    state = state.copyWith(showLoading: false, isBot: true, openAIError: true);
  }
}

//STATE
class OpenAIState {
  final bool isBot;
  final bool showLoading;
  final bool openAIError;
  final bool isClear;
  final List<Message> messages;

  OpenAIState({
    this.isBot = true,
    this.showLoading = false,
    this.openAIError = false,
    this.isClear = true,
    this.messages = const [],
  });

  OpenAIState copyWith({
    bool? isBot,
    bool? showLoading,
    bool? openAIError,
    bool? isClear,
    List<Message>? messages,
  }) {
    return OpenAIState(
      isBot: isBot ?? this.isBot,
      showLoading: showLoading ?? this.showLoading,
      openAIError: openAIError ?? this.openAIError,
      isClear: isClear ?? this.isClear,
      messages: messages ?? this.messages,
    );
  }
}

class Message {
  final String? id;
  final bool isBot;
  String? message;

  Message({this.id, this.isBot = true, this.message});
}
