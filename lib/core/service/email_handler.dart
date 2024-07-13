import 'dart:async';
import 'dart:io';
import 'package:abiball_planer/core/managment/managerProviderEmail.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/cupertino.dart';


class EmailHandler {

  static final EmailHandler _instance = EmailHandler._internal();

  BuildContext? context;

  factory EmailHandler() => _instance;

  EmailHandler._internal() {
    initEmailConnection();
  }

  String email = 'pasirein@outlook.de';
  String password = r'plenadnouerizynd';

  MimeMessage buildMessage() {
    final builder = MessageBuilder.prepareMultipartAlternativeMessage(
      plainText: 'Hello world!',
      htmlText: '<p>Hello world!</p>',
    )
      ..from = [const MailAddress('Personal Name', 'sender@domain.com')]
      ..to = [
        const MailAddress('Recipient Personal Name', 'recipient@domain.com'),
        const MailAddress('Other Recipient', 'other@domain.com')
      ];
    return builder.buildMimeMessage();
  }

  Future<MimeMessage> buildMessageWithAttachment() async {
    final builder = MessageBuilder()
      ..from = [const MailAddress('Personal Name', 'sender@domain.com')]
      ..to = [
        const MailAddress('Recipient Personal Name', 'recipient@domain.com'),
        const MailAddress('Other Recipient', 'other@domain.com')
      ]
      ..addMultipartAlternative(
        plainText: 'Hello world!',
        htmlText: '<p>Hello world!</p>',
      );
    final file = File.fromUri(Uri.parse('file://./document.pdf'));
    await builder.addFile(file, MediaSubtype.applicationPdf.mediaType);
    return builder.buildMimeMessage();
  }

  void backgroundCheck(MailClient mailClient) async {
    mailClient.eventBus.on<MailLoadEvent>().listen((event) {
      ManagerProviderEmail.of(context!).addSingleMail(event.message);
    });
    await mailClient.startPolling();
  }

  Future<void> initEmailConnection() async {
    print('discovering settings for  $email...');
    final config = await Discover.discover(email, isLogEnabled: true);
    if (config == null) {
      print('Unable to auto-discover settings for $email');
      return;
    }
    print('connecting to ${config.displayName}.');
    final account = MailAccount.fromDiscoveredSettings(
      name: 'Pascal Reinmuth',
      email: email,
      password: password,
      config: config,
      userName: email,
    );
    final mailClient = MailClient(account, isLogEnabled: false);
    try {
      await mailClient.connect();
      print('connected');
      await mailClient.listMailboxesAsTree(createIntermediate: false);
      await mailClient.selectInbox();
      var messages = await mailClient.fetchMessages(count: 20);
      ManagerProviderEmail.of(context!).addAll(messages);
      backgroundCheck(mailClient);
    } on MailException catch (e) {
      print('High level API failed with $e');
    }
  }
}
