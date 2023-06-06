#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>
#import <REIOSSDK/REIOSSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate,REiosNotificationReceiver,REiosSmartLinkReceiver>

@property (nonatomic, strong) UIWindow *window;

@end
