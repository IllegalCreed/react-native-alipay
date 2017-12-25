//
//  RCTAlipay.m
//  RCTAlipay
//
//  Created by kant iou on 2016/11/16.
//  Copyright © 2016年 iou90. All rights reserved.
//

#import "RCTAlipay.h"
#import "AlipaySDK.h"

@implementation RCTAlipay

RCT_EXPORT_MODULE()

RCTPromiseResolveBlock _resolve;

RCT_REMAP_METHOD(pay, orderInformation:(NSString *)orderInformation resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSArray *urls = [[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"];
    NSMutableString *appScheme = [NSMutableString string];
    BOOL multiUrls = [urls count] > 1;
    for (NSDictionary *url in urls) {
        NSArray *schemes = url[@"CFBundleURLSchemes"];
        if (!multiUrls ||
            (multiUrls && [@"alipay" isEqualToString:url[@"CFBundleURLName"]])) {
            [appScheme appendString:schemes[0]];
            
            break;
        }
    }
    
    if ([appScheme isEqualToString:@""]) {
        NSString *error = @"scheme cannot be empty";
        reject(@"10000", error, [NSError errorWithDomain:error code:10000 userInfo:NULL]);
        
        return;
    }
    
    _resolve = resolve;
    
    [[AlipaySDK defaultService] payOrder:orderInformation fromScheme:appScheme callback:^(NSDictionary *result) {
        [RCTAlipay handleResult:result];
    }];
}

+(void) handleResult:(NSDictionary *)result
{
    _resolve(result);
}

+(void) handleCallback:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleResult:resultDic];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handleResult:resultDic];
        }];
    }
}

@end
