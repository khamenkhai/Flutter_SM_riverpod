import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/models/notiModel.dart';
import 'package:sm_project/sm/utils/consts.dart';


final notiRepositoryProvider = Provider(
  (ref) => NotiRepository(
    firestore: FirebaseFirestore.instance,
    ref: ref,
  ),
);


///noti repository
class NotiRepository {
  final FirebaseFirestore firestore;
  final Ref ref;

  NotiRepository({
    required this.firestore,
    required this.ref,
  });


  CollectionReference get _notiMessageCollection => firestore.collection(Constants.noteMessageCollection);

  ///send a noti message
  Future sendANotiMessage(NotiModel noti) async {

    await _notiMessageCollection.doc(noti.notiId).set(noti.toMap());
  }

  ///get all noti datas of a user
  Stream<List<NotiModel>> getAllNotiofUser({required String currentUserId}){
    return _notiMessageCollection.where('userId',isEqualTo: currentUserId).orderBy('dateTime',descending: true).snapshots().map((event){
      return event.docs.map((e) => NotiModel.fromMap(e.data() as Map<String,dynamic>)).toList();
    } );
  }


  //clear all my noti
  clearAllMyNoti(String userId){
    
  }
}
