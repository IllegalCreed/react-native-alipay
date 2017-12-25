//
//  RCTAlipay.h
//  RCTAlipay
//
//  Created by kant iou on 2016/11/16.
//  Copyright © 2016年 iou90. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface RCTAlipay : NSObject <RCTBridgeModule>

+(void) handleCallback:(NSURL *)url;

@end
