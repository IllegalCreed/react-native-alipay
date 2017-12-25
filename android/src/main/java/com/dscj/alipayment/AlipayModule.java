package com.dscj.alipayment;

import com.alipay.sdk.app.PayTask;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

/**
 * Created by zhangxu on 2016/11/16.
 */

public class AlipayModule extends ReactContextBaseJavaModule {
    public AlipayModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "Alipay";
    }

    @ReactMethod
    public void pay(String payInfo, Promise promise) {
        PayTask alipay = new PayTask(getCurrentActivity());
        String result = alipay.pay(payInfo,true);
        promise.resolve(result);
    }
}
