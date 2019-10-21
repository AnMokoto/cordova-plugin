package com.mokoto.cordova.baichuan;

import android.content.Intent;
import android.util.Log;

import com.ali.auth.third.core.model.Session;
import com.alibaba.baichuan.android.trade.AlibcTradeSDK;
import com.alibaba.baichuan.android.trade.callback.AlibcTradeInitCallback;
import com.alibaba.baichuan.trade.biz.login.AlibcLogin;
import com.alibaba.baichuan.trade.biz.login.AlibcLoginCallback;
import com.alibaba.fastjson.JSON;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaPreferences;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * 处理百川sdk业务
 */
public class BaichuanProxy {

    private CordovaInterface cordova;
    private CordovaPlugin plugin;
    private CordovaPreferences preferences;
    private final String TAG = this.getClass().getSimpleName();
    private boolean isInitialize = false;

    BaichuanProxy(CordovaPlugin plugin, CordovaInterface cordova, CordovaPreferences preferences) {
        this.cordova = cordova;
        this.plugin = plugin;
        this.preferences = preferences;
        this.initialize();
    }

    void initialize() {
        if (isInitialize) return;
        String channelType = this.preferences.getString("CHANNEL_TYPE", null);
        String channelName = this.preferences.getString("CHANNEL_NAME", null);
        if (channelType != null && channelName != null) {
            AlibcTradeSDK.setChannel(channelType, channelName);
        }
        AlibcTradeSDK.asyncInit(cordova.getActivity().getApplication(),
                new AlibcTradeInitCallback() {
                    @Override
                    public void onSuccess() {
                        isInitialize = true;
                        Log.i(TAG, "阿里百川初始化成功");
                    }

                    @Override
                    public void onFailure(int i, String s) {
                        isInitialize = false;
                        Log.e(TAG, "阿里百川初始化失败\n错误码--> [" + i + "] \n错误信息---> [" + s + "]");
                    }
                });
    }

    void onDestroy() {
        AlibcTradeSDK.destory();
        this.isInitialize = false;
        this.cordova = null;
        this.plugin = null;
        this.preferences = null;
    }

    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.startsWith("Login")) {
            return this.login(callbackContext);
        } else if (action.startsWith("Logout")) {
            return this.logout(callbackContext);
        } else if (action.startsWith("Session")) {
            return this.getSession(callbackContext);
        } else if (action.startsWith("IsLogin")) {
//            callbackContext.success(this.isLogin() ? 1 : 0);
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, this.isLogin()));
            return true;
        }
        return false;
    }

    /**
     * success:
     * <pre>
     *     {
     *         code:int,//0--登录初始化成功；1--登录初始化完成；2--登录成功
     *         openId:string,
     *         nickName:string
     *     }
     * </pre>
     * <p>
     * error:
     * <pre>
     *     {
     *         code:int,
     *         message:string
     *     }
     * </pre>
     *
     * @param callbackContext
     */
    private boolean login(CallbackContext callbackContext) {
        if (this.isLogin()) {
            return this.getSession(callbackContext);
        }
        AlibcLogin alibcLogin = AlibcLogin.getInstance();
        alibcLogin.showLogin(new AlibcLoginCallback() {
            @Override
            public void onSuccess(int i, String s, String s1) {
                BaichuanProxy.this.getSession(callbackContext);
            }

            @Override
            public void onFailure(int i, String s) {
                com.alibaba.fastjson.JSONObject obj = new com.alibaba.fastjson.JSONObject();
                obj.put("code", i);
                obj.put("message", s);
                callbackContext.error(obj.toJSONString());
            }
        });

        return true;
    }

    /**
     * success:
     * <pre>
     *     {
     *         code:3,
     *         openId:string
     *     }
     * </pre>
     * <p>
     * error:
     * <pre>
     *     {
     *         code:int,
     *         message:string
     *     }
     * </pre>
     *
     * @param callbackContext
     */
    private boolean logout(CallbackContext callbackContext) {
        if (!this.isLogin()) {
            callbackContext.success();
            return true;
        }
        AlibcLogin alibcLogin = AlibcLogin.getInstance();
        alibcLogin.logout(new AlibcLoginCallback() {
            @Override
            public void onSuccess(int i, String s, String s1) {
                com.alibaba.fastjson.JSONObject obj = new com.alibaba.fastjson.JSONObject();
                obj.put("code", i);
                obj.put("openId", s);
                callbackContext.success(obj.toJSONString());
            }

            @Override
            public void onFailure(int i, String s) {
                com.alibaba.fastjson.JSONObject obj = new com.alibaba.fastjson.JSONObject();
                obj.put("code", i);
                obj.put("message", s);
                callbackContext.error(obj.toJSONString());
            }
        });
        return true;
    }

    /**
     * toString 返回授权用户信息{@link Session}，结果逗号分隔
     *
     * @param callbackContext
     */
    private boolean getSession(CallbackContext callbackContext) {
        if (this.isLogin()) {
            Session session = AlibcLogin.getInstance().getSession();
            callbackContext.success(JSON.toJSONString(session));
        } else {
            callbackContext.error(0);
        }
        return true;
    }

    private boolean isLogin() {
        return AlibcLogin.getInstance().isLogin();
    }


    private void openByUrl(String url) {
//        AlibcShowParams showParams = new AlibcShowParams();
//        showParams.setOpenType(OpenType.Native);
//        showParams.setClientType("");
//        AlibcTrade.openByUrl(this.cordova.getActivity(),
//                url,
//                null,
//                null,
//                new WebViewClient(),
//                new WebChromeClient(),
//                null,
//                null,
//                null, new AlibcTradeInitCallback() {
//
//                    @Override
//                    public void onSuccess() {
//
//                    }
//
//                    @Override
//                    public void onFailure(int i, String s) {
//
//                    }
//                });
    }

    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        com.ali.auth.third.ui.context.CallbackContext.onActivityResult(requestCode, resultCode, intent);
    }
}
