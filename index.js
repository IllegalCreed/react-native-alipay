import {
    NativeModules,
    Platform
} from 'react-native';

const nativeModule = NativeModules.Alipay;

export default class Alipay {
    static async pay(msg) {
        let alipayResult = await nativeModule.pay(msg);
        let result = {};
        if (Platform.OS === 'ios') {
            result.resultStatus = alipayResult.resultStatus;
            result.result = alipayResult.result;
            result.memo = alipayResult.memo;
        }
        else {
            let strs = alipayResult.split(';');
            for (index in strs) {
                if (this.startsWith(strs[index], 'resultStatus')) {
                    result.resultStatus = this.getValue(strs[index], 'resultStatus');
                }
                if (this.startsWith(strs[index], 'result')) {
                    result.result = this.getValue(strs[index], 'result');
                }
                if (this.startsWith(strs[index], 'memo')) {
                    result.memo = this.getValue(strs[index], 'memo');
                }
            }
        }

        switch (result.resultStatus) {
            case "9000":
                result.msg = "订单支付成功";
                break;
            case "8000":
                result.msg = "正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                break;
            case "4000":
                result.msg = "订单支付失败";
                break;
            case "6001":
                result.msg = "用户中途取消";
                break;
            case "6002":
                result.msg = "支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
                break;
            case "6004":
                result.msg = "订单支付成功";
                break;
            default:
                result.msg = "其它支付错误";
        }

        return result;
    }

    static startsWith(source, prefix) {
        return source.slice(0, prefix.length) === prefix;
    };

    static getValue(content, key) {
        let prefix = key + "={";
        return content.substring(content.indexOf(prefix) + prefix.length,
            content.lastIndexOf("}"));
    }
}