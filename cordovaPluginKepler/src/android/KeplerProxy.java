package com.mokoto.cordova.kepler;

import android.content.Intent;
import android.util.Log;

import com.kepler.jd.Listener.ActionCallBck;
import com.kepler.jd.Listener.AsyncInitListener;
import com.kepler.jd.Listener.LoginListener;
import com.kepler.jd.Listener.OpenAppAction;
import com.kepler.jd.login.KeplerApiManager;
import com.kepler.jd.sdk.bean.KelperTask;
import com.kepler.jd.sdk.bean.KeplerAttachParameter;
import com.kepler.jd.sdk.exception.KeplerBufferOverflowException;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaPreferences;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * 处理京东开普勒sdk业务
 */
public class KeplerProxy {

    private CordovaInterface cordova;
    private CordovaPlugin plugin;
    private CordovaPreferences preferences;
    private final String TAG = this.getClass().getSimpleName();
    private boolean isInitialize = false;
    private KelperTask task;


    KeplerProxy(CordovaPlugin plugin, CordovaInterface cordova, CordovaPreferences preferences) {
        this.cordova = cordova;
        this.plugin = plugin;
        this.preferences = preferences;
        this.initialize();
    }

    void initialize() {
        if (isInitialize) return;
        String appKey = this.preferences.getString("appkey", null);
        String appSecret = this.preferences.getString("appsecret", null);
        KeplerApiManager.asyncInitSdk(cordova.getActivity().getApplication(),
                appKey, appSecret,
                new AsyncInitListener() {
                    @Override
                    public void onSuccess() {
                        isInitialize = true;
                        Log.i(TAG, "Kepler asyncInitSdk onSuccess ");
//                        if (channelName != null) {
//                            try {
//                                AlibcTradeSDK.setChannel(channelType, channelName);
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                            }
//                        }
                    }

                    @Override
                    public void onFailure() {
                        isInitialize = false;
                        Log.e(TAG, "Kepler asyncInitSdk 授权失败，请检查lib 工程资源引用；包名,签名证书是否和注册一致");
                    }
                });

    }

    void onDestroy() {
        this.isInitialize = false;
        this.cordova = null;
        this.plugin = null;
        this.preferences = null;
        for (; task != null && !task.isCancel(); ) {
            task.setCancel(true);
        }

    }

    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.startsWith("keplerLogin")) {
            return this.login(callbackContext);
        } else if (action.startsWith("keplerLogout")) {
            return this.logout(callbackContext);
        } else if (action.startsWith("keplerSession")) {
            return this.checkLoginState(callbackContext);
        }
        return false;
    }

    /**
     * success: ignore
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
//        KeplerApiManager.getWebViewService().
        KeplerApiManager.getWebViewService().login(this.cordova.getActivity(),
                new LoginListener() {
                    @Override
                    public void authSuccess() {
//                        JSONObject json = new JSONObject();
//                try {
//                    json.putOpt("code", i);
//                    json.putOpt("openId", s);
//                    json.putOpt("nickName", s1);
//                } catch (JSONException e) {
//                    e.printStackTrace();
//                }
                        callbackContext.success();
                    }

                    @Override
                    public void authFailed(int i) {
                        JSONObject json = new JSONObject();
                        try {
                            json.putOpt("code", i);
                            json.putOpt("message", "登录异常,错误码: " + i);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        callbackContext.error(json);
                    }
                });


        return true;
    }

    /**
     * success:ignore
     *
     * @param callbackContext
     */
    private boolean logout(CallbackContext callbackContext) {
        KeplerApiManager.getWebViewService().cancelAuth(this.cordova.getContext());
//        AlibcLogin alibcLogin = AlibcLogin.getInstance();
//        alibcLogin.logout(new AlibcLoginCallback() {
//            @Override
//            public void onSuccess(int i, String s, String s1) {
//                JSONObject json = new JSONObject();
//                try {
//                    json.putOpt("code", i);
//                    json.putOpt("openId", s);
//                } catch (JSONException e) {
//                    e.printStackTrace();
//                }
//                callbackContext.success(json);
//            }
//
//            @Override
//            public void onFailure(int i, String s) {
//                JSONObject json = new JSONObject();
//                try {
//                    json.putOpt("code", i);
//                    json.putOpt("message", s);
//                } catch (JSONException e) {
//                    e.printStackTrace();
//                }
//                callbackContext.error(json);
//            }
//        });
        callbackContext.success();
        return true;
    }

    /**
     * @param callbackContext
     */
    private boolean checkLoginState(CallbackContext callbackContext) {
        KeplerApiManager.getWebViewService().checkLoginState(new ActionCallBck() {
            @Override
            public boolean onDateCall(int i, String s) {
                Log.i(TAG, "Kepler Login State : " + i + " ->>> " + s);
                JSONObject json = new JSONObject();
                try {
                    json.putOpt("code", i);
                    json.putOpt("message", s);
                } catch (Exception e) {
                    Log.e(TAG, "", e);
                } finally {
                    callbackContext.success(json);
                }
                return true;
            }

            @Override
            public boolean onErrCall(int i, String s) {
                Log.i(TAG, "Kepler Login State : " + i + " ->>> " + s);
                JSONObject json = new JSONObject();
                try {
                    json.putOpt("code", i);
                    json.putOpt("message", s);
                } catch (Exception e) {
                    Log.e(TAG, "", e);
                } finally {
                    callbackContext.error(json);
                }
                return true;
            }
        });
        return true;
    }


    private void openUrl(String url, CallbackContext callbackContext) {
        try {
            task = KeplerApiManager.getWebViewService().openJDUrlPage(url,
                    new KeplerAttachParameter(),
                    cordova.getContext(),
                    i -> {
                        if (i == OpenAppAction.OpenAppAction_result_NoJDAPP) {
                            callbackContext.error("未安装京东App");
                        } else if (i == OpenAppAction.OpenAppAction_result_APP) {
                            callbackContext.success();
                        }
                    },
                    5
            );
        } catch (KeplerBufferOverflowException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
//        this.plugin.onActivityResult(requestCode, resultCode, intent);
    }
}
