import 'package:appwrite/appwrite.dart';
import 'package:cholo_bd/config/constant/apwrite_constant.dart';

class AppWriteProvider {
  final Client client = Client();
  late final Account account;
  late final Databases databases;
  late final Storage storage;

  AppWriteProvider() {
    client
        .setEndpoint(AppWriteConstants.endPoint)
        .setProject(AppWriteConstants.projectId);
    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
  }
}
