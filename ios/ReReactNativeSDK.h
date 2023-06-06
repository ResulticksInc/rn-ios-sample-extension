//
//  ReReactNativeSDK.h
//  MyApp
//
//  Created by Sivakumar on 8/8/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
//#import "GreenDayEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReReactNativeSDK : RCTEventEmitter<RCTBridgeModule>
- (void)sendSmartLinkNotificationData:(NSString *)data;
- (void)sendSmartLinkNotificationDict:(NSDictionary<NSString *, id> *)dict;


@end

NS_ASSUME_NONNULL_END
