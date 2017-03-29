//
//  AppDelegate.h
//  MiraeAsset
//
//  Created by Hyemin Kim on 2015. 5. 12..
//  Copyright (c) 2015년 Hyemin Kim. All rights reserved.
//


#import "MiraeAssetRootViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
{
    BOOL firstLaunch;
    BOOL didPush;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RootViewController *root;
@property (nonatomic, strong) CTCallCenter* callCenter;

- (void)setProfileForDeviceToken:(NSString*)newToken;
- (void)initUserDefaults;
- (void)initPlist;
- (void)writeToPlist:(NSString *)key value:(id)value;
- (id)readPlist:(NSString *)key;
- (void)setIconBadge:(NSInteger)num;
- (void)settingMain;
- (void)settingLogin;
- (BOOL)checkRemoteNotificationActivate;

@end

