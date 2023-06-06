//
//  ReReactNativeSDK.m
//  MyApp
//
//  Created by Sivakumar on 8/8/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <REIOSSDK/REIOSSDK.h>
#import "ReReactNativeSDK.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import <React/RCTUITextField.h>
#import <React/RCTTextView.h>
#import <React/RCTSegmentedControl.h>

#import <React/RCTSlider.h>
#import <React/RCTSwitch.h>


#import <React/RCTView.h>


#import <Foundation/Foundation.h>


@implementation ReReactNativeSDK

 //NotificationInboxViewController *inbox;



-(id)init{
    NSLog(@"Initializing...");
    return [super init];
}

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(struct _NSZone *)zone {
  static ReReactNativeSDK *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [super allocWithZone:zone];
  });
  
  
  return shared;
}



- (NSArray<NSString *> *)supportedEvents {
  return @[@"smartLinkNotificationData"];
}

- (void)sendSmartLinkNotificationData:(NSString *)data {
  
  [self sendEventWithName:@"smartLinkNotificationData" body:data];

}
- (void)sendSmartLinkNotificationDict:(NSDictionary<NSString *, id> *_Nonnull)dict{
  @try {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
     [self sendEventWithName:@"smartLinkNotificationData" body:jsonString];
  }
  @catch (NSException *exception) {
    
    NSDictionary *dict = @{@"error":@"json parsing error"};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendEventWithName:@"smartLinkNotificationData" body:jsonString];
     NSLog(@"%@", exception.reason);
  }
}





//MARK:- User registration
RCT_EXPORT_METHOD(userRegister:(NSString *)userRegister) {
  [REiosHandler registerUserData:userRegister];
}

//MARK:- Custom event
RCT_EXPORT_METHOD(customEvent:(NSString *)customEvent) {
  [REiosHandler addCustomEvent:customEvent];
}

//MARK:- Screen tracking
RCT_EXPORT_METHOD(screenNavigation:(NSString *)screenNavigation) {
  [REiosHandler setScreenName:screenNavigation];
}

//MARK:- Location update
RCT_EXPORT_METHOD(locationUpdate:(NSString *)locationUpdate) {
  [REiosHandler updateWithLocation:locationUpdate];
}

//MARK:- Get notification list
RCT_EXPORT_METHOD(getNotification:(RCTResponseSenderBlock)callback) {
  
  [REiosHandler getNotificationListWithSuccessHandler:^(NSArray* notificationList) {
    NSLog(@"Dict is %@",notificationList);
    callback(@[[NSNull null], notificationList]);
  }];
}

RCT_EXPORT_METHOD(updatePushToken:(NSString *)token) {
  [REiosHandler updatePushTokenWithToken:token];
}

- (void)deleteNotificationWithDict:(NSDictionary<NSString *, id> * _Nonnull)dict{
 // [[inbox view]removeFromSuperview];
   [self sendEventWithName:@"smartLinkNotificationData" body:@"Notification Delete"];
}
- (void)readNotificationWithDict:(NSDictionary<NSString *, id> * _Nonnull)dict{
  
}
- (void)unReadNotificationWithDict:(NSDictionary<NSString *, id> * _Nonnull)dict{
  
}

//MARK:- Get UnreadNotification count

RCT_EXPORT_METHOD(getUnReadNotificationCount:(RCTResponseSenderBlock)callback) {
  [REiosHandler getUnReadNotificationCountOnSuccess:^(NSInteger count)  {
    NSNumber *value = [NSNumber numberWithInteger:count];
   
    NSArray *countArr = [NSArray arrayWithObject:value];
    callback(countArr);
  }];
  
  
}
//MARK:- Read Notification With Notification ID

RCT_EXPORT_METHOD(readNotification:(NSString *)notificationId callback:(RCTResponseSenderBlock)callback) {

  [REiosHandler readNotificationWithNotificationId:notificationId onSuccess:^(NSInteger count) {
    NSNumber *value = [NSNumber numberWithInteger:count];
      
       NSArray *countArr = [NSArray arrayWithObject:value];
       
       callback(countArr);
  }];
}

RCT_EXPORT_METHOD(unReadNotification:(NSString *)notificationId callback:(RCTResponseSenderBlock)callback) {

  [REiosHandler unReadNotificationWithNotificationId:notificationId onSuccess:^(NSInteger count) {
    NSNumber *value = [NSNumber numberWithInteger:count];
         
          NSArray *countArr = [NSArray arrayWithObject:value];
          callback(countArr);
  }];
  
}

//MARK:- Get Read notification Count

RCT_EXPORT_METHOD(getReadNotificationCount:(RCTResponseSenderBlock)callback) {
  
  [REiosHandler getReadNotificationCountOnSuccess:^(NSInteger count) {
    NSNumber *value = [NSNumber numberWithInteger:count];
         
          NSArray *countArr = [NSArray arrayWithObject:value];
          callback(countArr);
  }];
  
}

RCT_EXPORT_METHOD(notificationCTAClicked:(NSString *) notificationId actionId:(NSInteger)actionId callback:(RCTResponseSenderBlock)callback) {

  [REiosHandler notificationCTAClickedWithNotificationId:notificationId actionId:actionId onSuccess:^(NSInteger count) {
    NSNumber *value = [NSNumber numberWithInteger:count];
    
     NSArray *countArr = [NSArray arrayWithObject:value];
     //callback(@[[countStr]]);
     callback(countArr);
  }];
  

  
}

//MARK:- Get Total Notification Count

RCT_EXPORT_METHOD(getTotalNotificationCount:(RCTResponseSenderBlock)callback) {
  
  [REiosHandler getTotalNotificationCountOnSuccess:^(NSInteger count) {
    NSNumber *value = [NSNumber numberWithInteger:count];
         
          NSArray *countArr = [NSArray arrayWithObject:value];
          callback(countArr);
  }];
}

//MARK:- Delete notification from notification list
RCT_EXPORT_METHOD(deleteNotification:(NSString *)deleteNotification) {
  NSError *err = nil;
  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[deleteNotification dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
  NSLog(@"Dict is %@",dict);
  
  [REiosHandler deleteNotificationListWithDict:dict];
}

RCT_EXPORT_METHOD(deleteNotificationByObject:(NSString *)deleteNotification) {
  NSError *err = nil;
  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[deleteNotification dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
  NSLog(@"Dict is %@",dict);
    
  [REiosHandler deleteNotificationListWithDict:dict];
}

RCT_EXPORT_METHOD(deleteNotificationByCampaignId:(NSString *)deleteNotification) {
  NSError *err = nil;
  
  @try {
      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[deleteNotification dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
      NSLog(@"Dict is %@",dict);
      
      [REiosHandler deleteNotificationByCampaignIdWithCampaignId:dict[@"campaignId"]];
   }
   @catch (NSException *exception) {
      NSLog(@"%@", exception.reason);
   }
}

RCT_EXPORT_METHOD(deleteNotificationByNotificationId:(NSString *)deleteNotification) {
  
  NSError *err = nil;

  @try {
     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[deleteNotification dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
     NSLog(@"Dict is %@",dict);
     
     [REiosHandler deleteNotificationByNotificationIdWithNotificationId:dict[@"notificationId"]];
  }
  @catch (NSException *exception) {
     NSLog(@"%@", exception.reason);
  }
}


//MARK:- Pass notification data to SDK
RCT_EXPORT_METHOD(onNotificationPayloadReceiver:(NSString *)onNotificationPayloadReceiver state: (int)currentState) {
    
  if (currentState == 1) {
    NSError *jsonError;
    NSData *objectData = [onNotificationPayloadReceiver dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                          options:NSJSONReadingMutableContainers
                                            error:&jsonError];
    [REiosHandler setCustomNotificationWithUserInfo:json[@"data"]];
  

  } else if (currentState == 2) {
    [REiosHandler setNotificationActionWithStrResponse:onNotificationPayloadReceiver];

  } else if (currentState == 3) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 7 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [REiosHandler setNotificationActionWithStrResponse:onNotificationPayloadReceiver];
    });

  } else {
    NSLog(@"Unknown state");
  }
}

//MARK:- Get notification list
RCT_EXPORT_METHOD(sendDeeplinkUrl:(NSString *)deeplinkUrl data:(RCTResponseSenderBlock)callback) {
  
  @try {

    NSURL *url = [[NSURL alloc] initWithString:deeplinkUrl];
    
    [REiosHandler handleOpenlinkWithUrl:url successHandler:^(NSString* dict) {
      NSLog(@"Unknown state %@", dict);
      callback(@[[NSNull null], dict]);
    } failureHandler:^(NSString* error) {
      NSLog(@"Unknown state %@", error);
    }];
  }
  @catch (NSException *exception) {
     NSLog(@"%@", exception.reason);
  }
  
}

//MARK:- Get deeplinking data
RCT_EXPORT_METHOD(getDeeplinkingData:(RCTResponseSenderBlock)callback) {
    
  [REiosHandler getDeeplinkingDataWithSuccess:^(NSDictionary<NSString *,id> * dict) {
    callback(@[[NSNull null], dict]);
  } failure:^(NSString * error) {
    callback(@[[NSNull null], error]);
  }];
}

//MARK:- Get deeplinking data
RCT_EXPORT_METHOD(appConversionTracking) {
    
  [REiosHandler appConversionTracking];
}



RCT_EXPORT_METHOD(appConversionTrackingWithData:(NSString *) data) {
  NSError *jsonError;
  NSData *objectData = [data dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                        options:NSJSONReadingMutableContainers
                                          error:&jsonError];
  
  [REiosHandler appConversionTrackingWithDict:json];
  
}


//MARK:- Get QR data
RCT_EXPORT_METHOD(sendQRLinkUrl:(NSString *)qrUrl getQRData:(RCTResponseSenderBlock)callback) {
  
  [REiosHandler handleQrLinkWithUrl: qrUrl successHandler:^(NSDictionary<NSString *,id> * data) {
        callback(@[[NSNull null], data]);
  } failureHandler:^(NSString * error) {
        callback(@[[NSNull null], error]);
  }];
}

//MARK:- FormDataCapture
RCT_EXPORT_METHOD(formDataCapture:(NSString *)formDataCapture) {
  [REiosHandler formDataCaptureWithDict:formDataCapture];

}



@end




