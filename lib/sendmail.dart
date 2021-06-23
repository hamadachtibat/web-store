 import 'package:flutter/material.dart';
 import 'package:mailer/mailer.dart';
 import 'package:mailer/smtp_server.dart';

class sendemailToAdmin extends StatefulWidget {
  @override
  _sendemailToAdminState createState() => _sendemailToAdminState();
}

class _sendemailToAdminState extends State<sendemailToAdmin> {

  sendEmail()async{
    String username = 'achtibat.ahmed@gmail.com';
    String password = 'AHMEDchtibat1991';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Ahmed')
      ..recipients.add('achtibat.ahmed@gmail.com')
      ..subject = 'Order :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>YOU HAVE NEW ORDER</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

