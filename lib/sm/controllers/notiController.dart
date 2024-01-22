import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/models/notiModel.dart';
import 'package:sm_project/sm/repositories/notiRepository.dart';


///notification controller provider to control all of the noti methods
final notiControllerProvider = Provider((ref) => NotiController(
    notiRepository: ref.watch(notiRepositoryProvider), ref: ref));

//to get all notifications of user as stream data
final getNotificationsOfUserProvider = StreamProvider((ref){
  return ref.watch(notiControllerProvider).getNotificationsOfUser();
});

///main Noti controller class
class NotiController {
  final NotiRepository notiRepository;
  final Ref ref;

  NotiController({required this.notiRepository, required this.ref});

  //send a noti message
  sendANotiMessage({required NotiModel noti}) {
    notiRepository.sendANotiMessage(noti);
  }


  //get all notimessages of a user
  Stream<List<NotiModel>> getNotificationsOfUser(){
    return notiRepository.getAllNotiofUser(currentUserId: FirebaseAuth.instance.currentUser!.uid);
  }
}
