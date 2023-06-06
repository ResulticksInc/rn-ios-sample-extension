#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <Firebase.h>
#import <REIOSSDK/REIOSSDK.h>
#import "ReReactNativeSDK.h"

#import <os/log.h>

#ifdef FB_SONARKIT_ENABLED
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>
#import <FlipperKitReactPlugin/FlipperKitReactPlugin.h>

#import <UserNotifications/UserNotifications.h>



static void InitializeFlipper(UIApplication *application) {
  FlipperClient *client = [FlipperClient sharedClient];
  SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
  [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application withDescriptorMapper:layoutDescriptorMapper]];
  [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
  [client addPlugin:[FlipperKitReactPlugin new]];
  [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
  [client start];
}
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
//  [FIRApp configure];

#ifdef FB_SONARKIT_ENABLED
  InitializeFlipper(application);
#endif

  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"ReactSample"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
//  [REiosHandler setDebug: YES];
  
  [REiosHandler setDebug:YES];
  
//  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];

  [REiosHandler initSdkWithAppId:@"00ac6f67-a80d-4d8f-b5c0-66dab16df2b0" notificationCategory: nil success:^(NSInteger status) {
    NSLog(@"Success %i:", status);
    
  } failure:^(NSString * error) {
    NSLog(@"Error %@",error);
  }];
  
  [REiosHandler setNotificationDelegate:self];
  [REiosHandler setSmartLinkDelegate:self];
  
  
  
  [self registerNotificationForFcm:application];
  [FIRApp configure];
  [FIRMessaging messaging].delegate = self;
  
  
  return YES;
}

//- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
//{
//#if DEBUG
//  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
//#else
//  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
//#endif
//}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
  NSLog(@"FCM registration token: %@", fcmToken);
//  os_log(OS_LOG_DEFAULT, fcmToken);
  UIPasteboard * pasteboard=[UIPasteboard generalPasteboard];
  [pasteboard setString:fcmToken];
  // Notify about received token.
  NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
  [[NSNotificationCenter defaultCenter] postNotificationName:
   @"FCMToken" object:nil userInfo:dataDict];
  // TODO: If necessary send token to application server.
  // Note: This callback is fired at each app startup and whenever a new token is generated.
  
  NSDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:fcmToken forKey:@"token"];
  [dict setValue:@"siva@gmail.com" forKey:@"email"];
   
   [REiosHandler sdkRegistrationWithParams: dict success:^(NSInteger status) {
     NSLog(@"sdk reg Success %i:", status);
   } failure:^(NSString * error) {
     NSLog(@"sdk reg  Error %@",error);
   }];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [FIRMessaging messaging].APNSToken = deviceToken;
}

- (void)didReceiveResponseWithData:(NSDictionary<NSString *, id>*)data{
  [[[ReReactNativeSDK alloc] init]sendSmartLinkNotificationDict:data];
}
- (void)didReceiveSmartLinkWithData:(NSDictionary<NSString *, id>*)data{
  [[[ReReactNativeSDK alloc] init]sendSmartLinkNotificationDict:data];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
  //  [[RNFirebaseNotifications instance] didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  [REiosHandler setCustomNotificationWithUserInfo:userInfo];
 
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    willPresentNotification:(UNNotification *)notification
  withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
    {
      
        [REiosHandler setForegroundNotificationWithNotification:notification completionHandler:^(UNNotificationPresentationOptions opts) {
            completionHandler(opts);
        }];
//      completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge );
    
   }


//- (void)userNotificationCenter:(UNUserNotificationCenter *)center
//       willPresentNotification:(UNNotification *)notification
//         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
//
//  completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
//
////  [REiosHandler setForegroundNotificationWithNotification:notification completionHandler:^(UNNotificationPresentationOptions opts) {
////      completionHandler(opts);
////  }];
//}

-(void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
  
  [[[ReReactNativeSDK alloc] init]sendSmartLinkNotificationDict:response.notification.request.content.userInfo];  
  [REiosHandler setNotificationActionWithResponse:response];
  completionHandler();
}


- (void)registerNotificationForFcm:(UIApplication *)application {
  if ([UNUserNotificationCenter class] != nil) {
    // iOS 10 or later
    // For iOS 10 display notification (sent via APNS)
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    //[[UNUserNotificationCenter currentNotificationCenter]setDelegate:self];
    // [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
    UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter]
     requestAuthorizationWithOptions:authOptions
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
      // ...
      dispatch_async(dispatch_get_main_queue(), ^{
                                  [[UIApplication sharedApplication] registerForRemoteNotifications];
                              });
    }];
    
    //    [FIRMessaging messaging].delegate = self;
  } else {
    // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
  }
  
  
}



@end
