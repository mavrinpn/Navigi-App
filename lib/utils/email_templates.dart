import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailTemplates {
  static const String _reportRecipient = 'pro@navigidz.online';

  static Email reportEmail(String userId) {
    final Email email = Email(
      body: '''
                    <p>Pourquoi voulez-vous signaler l'utilisateur:</p>
                    <p>User ID: $userId</p>
                    <p>--------------</p>
                  ''',
      subject: 'Signaler',
      recipients: [_reportRecipient],
      isHTML: true,
    );

    return email;
  }
}
