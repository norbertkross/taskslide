
import 'package:get/get.dart';
import 'package:dio/dio.dart' as packageDio;
import 'package:taskslide/state/BaseUrl.dart';

class ChatState extends GetxController{

  List messages = [].obs;

  var parentListItem = [].obs;

  var isLoadingChats = false.obs;

  var currentChatRoomId ="".obs;
  
  var allChatrooms = []..obs;

  var cancelRequestToken = packageDio.CancelToken();

  Future getAllMessageRooms({String email})async{
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl+'/collaborations_i_am_in';
    Map<String,dynamic> queryParams = {
      "userEmail": email.toString(),      
      };

    var response = await dio.post(url,queryParameters: queryParams,).catchError((err)async{
        //print("Error $err");
        return [];
    });

    return response.data.length ==0?[]:response.data;           
  }

  void setCurrentRoom({String roomId,var list}){

    currentChatRoomId.value = roomId;
    messages.clear();
    parentListItem.clear();
    parentListItem.add(list);

    // Make request
    makeRequestForMessages(roomId: roomId);
  }

  makeRequestForMessages({String roomId})async{
    packageDio.Dio dio = packageDio.Dio();
    var url = BaseUrl.baseUrl+'/read_messages';
    Map<String,dynamic> queryParams = {
      "roomid": roomId,      
      };

    
    if(isLoadingChats.value == true){
      try{          
          cancelRequestToken.cancel("Previous Request Cancelled");
        }catch(e){
          print(e);
      }
    }

    isLoadingChats.value = true;

    var response = await dio.post(url,queryParameters: queryParams,cancelToken: cancelRequestToken)
      .catchError((err)async{
        //print("Error $err");
        isLoadingChats.value = false;
        return [];
      })
      // .then((value){
      //   print("Finished Loading");
      //   isLoadingChats.value = false;
      // })
      ;

        messages = response.data;
        //print(messages);
        isLoadingChats.value = false;
        
        update();
  }

  void setParentItem(data){
    parentListItem.add(data);
  }

}