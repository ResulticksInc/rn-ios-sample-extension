//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package io.mob.resu.reandroidsdk;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.reactsample.ReReactNativeSDK;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class ReReactNativeSDKPackage implements ReactPackage {
    public ReReactNativeSDKPackage() {
    }

    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        return Arrays.asList(new ReReactNativeSDK(reactContext));
    }

    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
}
