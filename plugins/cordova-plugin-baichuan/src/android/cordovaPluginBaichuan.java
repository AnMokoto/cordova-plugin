package com.mokoto.cordova.baichuan;

import android.content.Intent;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * This class echoes a string called from JavaScript.
 */
public class cordovaPluginBaichuan extends CordovaPlugin {


    private BaichuanProxy proxy;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        if (proxy == null)
            proxy = new BaichuanProxy(this, this.cordova, this.preferences);
        proxy.initialize();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (proxy != null)
            proxy.onDestroy();
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (proxy != null)
            return proxy.execute(action, args, callbackContext);
        else return false;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (proxy != null)
            super.onActivityResult(requestCode, resultCode, intent);
    }
}
