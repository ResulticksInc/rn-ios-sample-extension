package com.reactsample;//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

//package io.mob.resu.reandroidsdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.Toast;
import androidx.fragment.app.Fragment;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter;

import io.mob.resu.reandroidsdk.AppConstants;
import io.mob.resu.reandroidsdk.AppLifecyclePresenter;
import io.mob.resu.reandroidsdk.AppRuleListener;
import io.mob.resu.reandroidsdk.IDeepLinkInterface;
import io.mob.resu.reandroidsdk.IGetQRLinkDetail;
import io.mob.resu.reandroidsdk.MRegisterUser;
import io.mob.resu.reandroidsdk.ReAndroidSDK;
import io.mob.resu.reandroidsdk.SessionTimer;
import io.mob.resu.reandroidsdk.error.Log;
import java.util.ArrayList;
import java.util.Calendar;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ReReactNativeSDK extends ReactContextBaseJavaModule implements LifecycleEventListener, ActivityEventListener {
    static boolean appOpenFlag = false;
    private String OldScreenName = null;
    private String newScreenName = null;
    private Calendar oldCalendar = Calendar.getInstance();
    private Calendar sCalendar = Calendar.getInstance();

    public ReReactNativeSDK(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addLifecycleEventListener(this);
        reactContext.addActivityEventListener(this);
       // AppConstants.isReactNative = true;
        AppConstants.isHyBird = true;
        if (!appOpenFlag) {
            appOpenFlag = true;
        }

    }

    @ReactMethod
    public void getDeepLink(final Callback successCallback) {
        ReAndroidSDK.getInstance(this.getCurrentActivity()).getCampaignData(new IDeepLinkInterface() {
            public void onInstallDataReceived(String data) {
                successCallback.invoke(new Object[]{null, data});
            }

            public void onDeepLinkData(String data) {
                successCallback.invoke(new Object[]{null, data});
            }
        });
    }

    @ReactMethod
    public void handleQrLink(String smartlink, final Callback successCallback) {
        ReAndroidSDK.getInstance(this.getCurrentActivity()).handleQrLink(smartlink, new IGetQRLinkDetail() {
            public void onSmartLinkDetails(String Data) {
                successCallback.invoke(new Object[]{null, Data});
            }

            public void onError(String error) {
                successCallback.invoke(new Object[]{null, error});
            }
        });
    }

    @ReactMethod
    public void getUnReadNotificationCount(Callback successCallback) {
        try {
            successCallback.invoke(new Object[]{null, ReAndroidSDK.getInstance(this.getCurrentActivity()).getUnReadNotificationCount()});
        } catch (Exception var3) {
            Log.e("register Exception: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void getReadNotificationCount(Callback successCallback) {
        try {
            successCallback.invoke(new Object[]{null, ReAndroidSDK.getInstance(this.getCurrentActivity()).getReadNotificationCount()});
        } catch (Exception var3) {
            Log.e("register Exception: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void notificationCTAClicked(String obj) {
        try {
            JSONObject jsonObject = new JSONObject(obj);
            ReAndroidSDK.getInstance(this.getCurrentActivity()).notificationCTAClicked(jsonObject.optString("campaignId"), jsonObject.optString("actionId"));
            Log.e("notificationCTAClicked: ", "Sucessfully " + jsonObject.toString());
        } catch (Exception var3) {
            Log.e("notificationCTAClicked: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void readNotification(String obj) {
        try {
            JSONObject jsonObject = new JSONObject(obj);
            ReAndroidSDK.getInstance(this.getCurrentActivity()).readNotification(jsonObject.optString("campaignId"));
            Log.e("notificationCTAClicked: ", "Sucessfully " + jsonObject.toString());
        } catch (Exception var3) {
            Log.e("notificationCTAClicked: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void unReadNotification(String obj) {
        try {
            JSONObject jsonObject = new JSONObject(obj);
            ReAndroidSDK.getInstance(this.getCurrentActivity()).unReadNotification(jsonObject.optString("campaignId"));
            Log.e("notificationCTAClicked: ", "Sucessfully " + jsonObject.toString());
        } catch (Exception var3) {
            Log.e("notificationCTAClicked: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void userRegister(String message) {
        try {
            JSONObject jsonObject = new JSONObject(message);
            MRegisterUser registerUser = new MRegisterUser();
            registerUser.setUserUniqueId(jsonObject.optString("userUniqueId"));
            registerUser.setName(jsonObject.optString("name"));
            registerUser.setEmail(jsonObject.optString("email"));
            registerUser.setPhone(jsonObject.optString("phone"));
            registerUser.setAge(jsonObject.optString("age"));
            registerUser.setGender(jsonObject.optString("gender"));
            registerUser.setDeviceToken(jsonObject.optString("token"));
            registerUser.setProfileUrl(jsonObject.optString("profileUrl"));
            ReAndroidSDK.getInstance(this.getCurrentActivity()).onDeviceUserRegister(registerUser);
        } catch (Exception var4) {
            Log.e("register Exception: ", String.valueOf(var4.getMessage()));
        }

    }

    @ReactMethod
    public void updatePushToken(String message) {
        if (message != null) {
            try {
                ReAndroidSDK.getInstance(this.getCurrentActivity()).updatePushToken(message);
            } catch (Exception var3) {
                var3.printStackTrace();
            }
        }

    }

    @ReactMethod
    public void appConversionTrackingWithData(String message) {
        if (message != null) {
            try {
                JSONObject jsonObject = new JSONObject(message);
                ReAndroidSDK.getInstance(this.getCurrentActivity()).appConversionTracking(jsonObject);
            } catch (Exception var3) {
                var3.printStackTrace();
            }
        }

    }

    @ReactMethod
    public void appConversionTracking() {
        try {
            ReAndroidSDK.getInstance(this.getCurrentActivity()).appConversionTracking();
        } catch (Exception var2) {
            var2.printStackTrace();
        }

    }

    @ReactMethod
    public void customEvent(String message) {
        if (message != null) {
            try {
                JSONObject jsonObject = new JSONObject(message);
                String eventName = jsonObject.optString("eventName");
                JSONObject eventData = jsonObject.optJSONObject("data");
                if (TextUtils.isEmpty(eventName)) {
                    Toast.makeText(this.getCurrentActivity(), "Event name can't be empty!", 0).show();
                    return;
                }

                if (TextUtils.isEmpty(eventData.toString())) {
                    ReAndroidSDK.getInstance(this.getCurrentActivity()).onTrackEvent(eventName);
                } else {
                    ReAndroidSDK.getInstance(this.getCurrentActivity()).onTrackEvent(eventData, eventName);
                }
            } catch (Exception var5) {
                Log.e("User events Exception: ", String.valueOf(var5.getMessage()));
            }
        } else {
            Log.e("User events Exception: ", "Expected one non-empty string argument.");
        }

    }

    @ReactMethod
    public void locationUpdate(String message) {
        if (message != null) {
            try {
                JSONObject jsonObject = new JSONObject(message);
                double latitude = jsonObject.optDouble("latitude");
                double longitude = jsonObject.optDouble("longitude");
                if (latitude != 0.0D && longitude != 0.0D) {
                    ReAndroidSDK.getInstance(this.getCurrentActivity()).onLocationUpdate(latitude, longitude);
                }
            } catch (Exception var7) {
                Log.e("User locationUpdate Exception: ", String.valueOf(var7.getMessage()));
            }
        } else {
            Log.e("User locationUpdate Exception: ", "Expected one non-empty string argument.");
        }

    }

    @ReactMethod
    public void screenNavigation(String screenName) {
        try {
            AppConstants.CURRENT_FRAGMENT_NAME = screenName;
            this.screenTracking(screenName);
            this.OldScreenName = this.newScreenName;
            AppRuleListener.LAST_FRAGMENT_NAME = this.OldScreenName;
            this.newScreenName = screenName;
            //SessionTimer.getInstance().startTimer(this.getCurrentActivity());
        } catch (Exception var3) {
            Log.e("userOnPause: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void getNotification(Callback successCallback) {
        try {
            ArrayList<JSONObject> jsonArrays = ReAndroidSDK.getInstance(this.getCurrentActivity()).getNotificationByObject();
            JSONArray jsonArray = new JSONArray(jsonArrays);
            successCallback.invoke(new Object[]{null, jsonArray.toString()});
            Log.e("getNotification: ", "Called ");
        } catch (Exception var4) {
            Log.e("getNotification: ", String.valueOf(var4.getMessage()));
        }

    }

    @ReactMethod
    public void deleteNotification(String obj) {
        try {
            JSONObject jsonObject = new JSONObject(obj);
            ReAndroidSDK.getInstance(this.getCurrentActivity()).deleteNotificationByObject(jsonObject);
            Log.e("deleteNotification: ", "Sucessfully " + jsonObject.toString());
        } catch (Exception var3) {
            Log.e("deleteNotification: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void deleteNotificationByCampaignId(String campaignId) {
        try {
            JSONObject jsonObject = new JSONObject(campaignId);
            ReAndroidSDK.getInstance(this.getCurrentActivity()).deleteNotificationByCampaignId(jsonObject.optString("campaignId"));
        } catch (Exception var3) {
            Log.e("deleteNotification: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void deleteNotificationByNotificationId(String notificationId) {
        try {
            JSONObject jsonObject = new JSONObject(notificationId);
            ReAndroidSDK.getInstance(this.getCurrentActivity()).deleteNotificationByNotificationId(jsonObject.optString("notificationId"));
        } catch (Exception var3) {
            Log.e("deleteNotification: ", String.valueOf(var3.getMessage()));
        }

    }

    @ReactMethod
    public void deleteNotificationByObject(String obj) {
        try {
            Log.e("deleteNotification: ", obj);
            JSONObject jsonObject = new JSONObject(obj);
            ReAndroidSDK.getInstance(this.getCurrentActivity()).deleteNotificationByObject(jsonObject);
        } catch (Exception var3) {
            Log.e("deleteNotification: ", String.valueOf(var3.getMessage()));
        }

    }

    public String getName() {
        return "ReReactNativeSDK";
    }

    public void onHostResume() {
        this.oldCalendar = Calendar.getInstance();
        this.sCalendar = Calendar.getInstance();

        try {
            this.notificationUpdate(this.getCurrentActivity());
        } catch (JSONException var2) {
            var2.printStackTrace();
        }

    }

    public void onHostPause() {
        this.screenTracking(this.newScreenName);
    }

    public void onHostDestroy() {
        ReAndroidSDK.getInstance(this.getCurrentActivity()).onTrackEvent("App Closed");
    }

    private void screenTracking(String screenName) {
        try {
            if (this.sCalendar == null) {
                this.sCalendar = Calendar.getInstance();
            }

            this.oldCalendar = this.sCalendar;
            this.sCalendar = Calendar.getInstance();
            if (this.OldScreenName != null) {
                AppLifecyclePresenter.getInstance().onSessionStop(this.getCurrentActivity(), this.oldCalendar, this.sCalendar, this.OldScreenName, (String)null, (String)null);
                AppLifecyclePresenter.getInstance().onSessionStartFragment(this.getCurrentActivity(), this.OldScreenName, (Fragment)null);
            }

            if (this.newScreenName == null) {
                this.newScreenName = screenName;
            }

            ReAndroidSDK.onPageChangeListener.onPageChanged(screenName, "No fragment available");
        } catch (Exception var3) {
        }

    }

    private void notificationUpdate(Context context) throws JSONException {
//        String value = SharedPref.getInstance().getStringValue(context, "notificationOpened");
//        if (!TextUtils.isEmpty(value)) {
//            try {
//                if (this.getCurrentActivity().getIntent().getExtras().containsKey("fragmentName")) {
//                    ((RCTDeviceEventEmitter)this.getReactApplicationContext().getJSModule(RCTDeviceEventEmitter.class)).emit("resulticksNotification", this.parseIntent(this.getCurrentActivity().getIntent()));
//                    SharedPref.getInstance().setSharedValue(context, "notificationOpened", "");
//                }
//            } catch (Exception var4) {
//                var4.printStackTrace();
//                android.util.Log.e("notificationUpdate", var4.getMessage());
//            }
//        }

    }

    private WritableMap parseIntent(Intent intent) {
        Bundle extras = intent.getExtras();
        WritableMap params;
        if (extras != null) {
            try {
                extras.putString("notificationAction", "Opened");
                params = Arguments.fromBundle(extras);
                Log.e("WritableMap", extras.toString());
                Log.e("WritableMap", extras.toString());
            } catch (Exception var5) {
                params = Arguments.createMap();
            }
        } else {
            params = Arguments.createMap();
        }

        return params;
    }

    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
    }

    public void onNewIntent(Intent intent) {
        try {
            if (intent.getExtras() != null && intent.getExtras().containsKey("fragmentName")) {
                ((RCTDeviceEventEmitter)this.getReactApplicationContext().getJSModule(RCTDeviceEventEmitter.class)).emit("resulticksNotification", this.parseIntent(intent));
               // SharedPref.getInstance().setSharedValue(this.getCurrentActivity(), "notificationOpened", "");
            }
        } catch (Exception var3) {
            var3.printStackTrace();
            android.util.Log.e("notificationUpdate", var3.getMessage());
        }

    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
    }
}
