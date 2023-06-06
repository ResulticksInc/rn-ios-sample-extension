package com.reactsample;

import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

//import io.mob.resu.reandroidsdk.ReAndroidSDK;


public class MyFirebaseMessagingService extends FirebaseMessagingService {

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {

        if (remoteMessage == null)
            return;
        Log.e("getData", "" + remoteMessage.getData());

//        if (ReAndroidSDK.getInstance(this).onReceivedCampaign(remoteMessage.getData())) {
//            return;
//        }

    }

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        Log.e("onNewToken", token);
        Log.e("onNewToken", token);
        Log.e("onNewToken", token);
       // ReAndroidSDK.getInstance(this).updatePushToken(token);
    }


}
