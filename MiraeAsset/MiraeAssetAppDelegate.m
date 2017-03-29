//
//  AppDelegate.m
//  MiraeAsset
//
//  Created by Hyemin Kim on 2015. 5. 12..
//  Copyright (c) 2015년 Hyemin Kim. All rights reserved.
//

#import "MiraeAssetAppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize root;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
    
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/Covers/",NSHomeDirectory()];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:filePath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", filePath, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
    
//    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
    NSLog(@"sbusese %@",[[NSBundle mainBundle]infoDictionary][@"SBUsesNetwork"]);
    
    firstLaunch = YES;
    
    
    [self initPlist];
    [SQLiteDBManager initDB];
    [self initUserDefaults];
    //    alreadyBon = NO;
    didPush = NO;
    NSString *deviceID = [self readPlist:@"deviceid"];
    
    if ([deviceID length] > 0) {
        BOOL status = YES;
        if ([deviceID isEqualToString:@"dummydeviceid"]) {
            status = NO;
        }
        [SharedFunctions saveDeviceToken:deviceID status:status];
        [self writeToPlist:@"deviceid" value:@""];
    }
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        NSLog(@"register over 10");
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            NSLog(@"register over 8");
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                                 (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            NSLog(@"register under 8");
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
    }

    
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        [[UINavigationBar appearance] setBackgroundImage:[CustomUIKit customImageNamed:@"navibar_bg.png"] forBarMetrics:UIBarMetricsDefault];
        
    } else {
        
        [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
       
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    root = [[RootViewController alloc] init];
    
    [root.callManager isCallingByPush:NO];
    
    [root initAudioSession];
    
    [[Countly sharedInstance] start:@"5c54802ae1926350dd7f890abc882fee8971c0b9" withHost:@"http://analytics.lemp.kr:53381"];
    [Fabric with:@[[Crashlytics class]]];

//    [Crashlytics startWithAPIKey:@"a0e93fdaf82dfab37e7a75f3914ff871900b7c81"];
#ifdef DEBUG
    [Crashlytics sharedInstance].debugMode = YES;
#endif
    NSDictionary *myInfo = (NSDictionary*)[self readPlist:@"myinfo"];
    NSLog(@"myinfo %@",myInfo);
    if (myInfo) {
        [Crashlytics setUserIdentifier:myInfo[@"uid"]];
        [self initMyInfo];
    }
    
    
    NSLog(@"lastdate %@",[SharedAppDelegate readPlist:@"lastdate"]);
    if( [SharedAppDelegate readPlist:@"lastdate"] != nil && [[SharedAppDelegate readPlist:@"lastdate"]length]>0 && ![[SharedAppDelegate readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]){
        [self settingMain];        
    }
    else {
        [self settingLogin];
    }
    
    self.callCenter = [[CTCallCenter alloc] init];
    [self handleCall];
//    NSLog(@"getDeviceUUID %@",[root getDeviceUUID]);
    
    
    if([[SharedAppDelegate readPlist:@"echoswitch"]length]<1 || [SharedAppDelegate readPlist:@"echoswitch"] == nil)
        [SharedAppDelegate writeToPlist:@"echoswitch" value:@"1"];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)initMyInfo{
    
    if([self readPlist:@"myinfo"][@"uid"] != nil && [[self readPlist:@"myinfo"][@"uid"]length]>0){
        [[ResourceLoader sharedInstance] setMyUID:[self readPlist:@"myinfo"][@"uid"]];
        [[ResourceLoader sharedInstance] setMySessionkey:[self readPlist:@"myinfo"][@"sessionkey"]];
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    [self application:application didReceiveRemoteNotification:userInfo];
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    NSLog(@"didReceiveNotificationResponse");
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
    [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:response.notification.request.content.userInfo];
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"~~~~~~~~~~~~~ Failed to get token, error: %@", error);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def boolForKey:@"PushAlertLastStatus"] == 0 && [def objectForKey:@"PushAlertLastToken"] == nil) {
        // 최초 실행, APNS 등록 실패 시
        [SharedFunctions saveDeviceToken:nil status:NO];
    }
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([application applicationState] != UIApplicationStateActive && [def objectForKey:@"PushAlertLastToken"] != nil) {
        NSLog(@"cancel");
        return;
    }
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char *ptr = (const unsigned char *)[deviceToken bytes];
    for(int i =0; i <32; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
    NSLog(@"DeviceID %@",deviceId);
    
    NSLog(@"OLD %@ NEW %@",[def objectForKey:@"PushAlertLastToken"],deviceId);
   
    
    if ([def boolForKey:@"PushAlertLastStatus"] == NO
        && [[self readPlist:@"lastdate"]length] > 0
        && ![[self readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"]
        && root.login == nil) {
        // 마지막 푸시 상태가 OFF, 로그인 상태
        [self setProfileForDeviceToken:deviceId];
    } else {
        [SharedFunctions saveDeviceToken:deviceId status:YES];
    }
}
-(bool)isOnPhoneCall {
    /*
     
     Returns TRUE/YES if the user is currently on a phone call
     
     */
    CTCallCenter *aCallCenter;
    aCallCenter = [[CTCallCenter alloc] init];
    for (CTCall *call in  aCallCenter.currentCalls)  {
        if (call.callState == CTCallStateDisconnected)
        {
            NSLog(@"Call has been disconnected");
            
        }
        
        else if (call.callState == CTCallStateConnected)
        {
            NSLog(@"Call has just been connected");
            return YES;
        }
        
        else if(call.callState == CTCallStateIncoming)
        {
            
            NSLog(@"Call is incoming");
            return YES;
        }
        else if(call.callState == CTCallStateDialing)
        {
            NSLog(@"Call is Dialing");
        }
    }
    return NO;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"aps ALL info %@",userInfo);
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSLog(@"aps %@",aps);
    NSLog(@"userInfo alert : %@\n", [aps valueForKey:@"alert"]);
    NSLog(@"userInfo badge : %@\n", [aps valueForKey:@"badge"]);
    NSLog(@"userInfo sound : %@\n", [aps valueForKey:@"sound"]);
    NSLog(@"userInfo ptype   %@\n", [aps valueForKey:@"ptype"]);
    NSLog(@"userInfo cidnum : %@\n", [aps valueForKey:@"cid"]);
    NSLog(@"userInfo cidname : %@\n", [aps valueForKey:@"cname"]);
    NSLog(@"userInfo uniqueid : %@\n", [aps valueForKey:@"uniqueid"]);
    NSLog(@"userInfo rkey : %@\n", [aps valueForKey:@"rkey"]);
    NSLog(@"userInfo cidx : %@\n", [aps valueForKey:@"cidx"]);
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ViewType"] isEqualToString:@"Driver"]) {
        return;
    }
    
    NSString *kindOfPush = [aps valueForKey:@"ptype"];
    if(kindOfPush == nil || [kindOfPush length]<1){
        aps = userInfo;
        kindOfPush = [aps valueForKey:@"ptype"];
    }
    
    
    if([kindOfPush isEqualToString:@"v"]){
        
        NSLog(@"[self isOnPhoneCall] %@",[self isOnPhoneCall]?@"YES":@"NO");
        if([self isOnPhoneCall] == YES){
            [self.window addSubview:[root.callManager setFullIncoming:aps call:YES push:YES active:NO]];
            //            [root.callManager mvoipIncomingWith:aps call:YES];//setFullIncoming:aps active:YES]];
       
        }
        else{
        
//        [root removePassword];
        [self.window endEditing:TRUE];
        [root.callManager isCallingByPush:YES];
        
            if(application.applicationState == UIApplicationStateActive) {
                [self.window addSubview:[root.callManager setFullIncoming:aps call:NO push:YES active:YES]];
//            [root.callManager mvoipIncomingWith:aps call:NO];//setFullIncoming:aps active:YES]];
            } else {
                [self.window addSubview:[root.callManager setFullIncoming:aps call:NO push:YES active:NO]];
//                [root.callManager setFullIncoming:aps active:NO call:NO];
//            [root.callManager mvoipIncomingWith:aps call:NO];//setFullIncoming:aps active:NO]];
        }
        }
    }
    
}




- (BOOL)checkRemoteNotificationActivate
{
    
    BOOL currentStatus = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        currentStatus =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        if (UIRemoteNotificationTypeAlert == (type & UIRemoteNotificationTypeAlert)) {
            
            NSLog(@"alert");
            currentStatus = YES;
            
        }
        if (UIRemoteNotificationTypeSound == (type & UIRemoteNotificationTypeSound)) {
            
            NSLog(@"sound");
            currentStatus = YES;
            
        }
        
    }
    
    NSLog(@"currentStatus %@",currentStatus?@"YES":@"NO");
    return currentStatus;
    
}


- (void)setProfileForDeviceToken:(NSString*)newToken
{
    if ([[self readPlist:@"was"] length] < 1) {
        return;
    }
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[self readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@lemp/info/setprofile.lemp",[self readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    NSDictionary *parameters = @{@"uid": [self readPlist:@"myinfo"][@"uid"],
                                 @"sessionkey": [self readPlist:@"myinfo"][@"sessionkey"],
                                 @"deviceid": newToken,
                                 @"olddeviceid":[SharedFunctions getDeviceIDForParameter]};
    NSLog(@"setProfileForDeviceToken param %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setprofile.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];

    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"NEWTOKEN %@ ResultDic %@",newToken,resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            // 갱신
            BOOL status = YES;
            if ([newToken length] < 1 || [newToken isEqualToString:@"dummydeviceid"]) {
                status = NO;
            }
            [SharedFunctions saveDeviceToken:newToken status:status];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HTTPExceptionHandler handlingByError:error];
    }];
    
    [operation start];
}


- (void) initUserDefaults
{
    NSDictionary *appDefaults = @{@"ReplySort": [NSNumber numberWithInteger:0],
                                  @"GlobalFontSize": [NSNumber numberWithInteger:15],
                                  @"mVoIPEnable": [NSNumber numberWithBool:YES],
                                  @"ViewType": @"Normal",
                                  };
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (void) initPlist {
    
    NSLog(@"initPlist");
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if (![documentsDirectory hasSuffix:@"/"]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    if (NO == [fileManager fileExistsAtPath:filePath]) {
        NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"myPlist.plist"];
        [fileManager copyItemAtPath:filePathFromApp toPath:filePath error:nil];
    }
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"SoundList.plist"];
    if (NO == [fileManager fileExistsAtPath:filePath]) {
        NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SoundList.plist"];
        [fileManager copyItemAtPath:filePathFromApp toPath:filePath error:nil];
    }
}



- (void)writeToPlist:(NSString *)key value:(id)value
{
    NSLog(@"key %@ value %@",key,value);
    
    if([value isKindOfClass:[NSNull class]] || value == nil)
        value = @"";
    
    if ([key isEqualToString:@"myinfo"]) {
        NSDictionary *myInfo = (NSDictionary*)value;
        if (myInfo) {
            [Crashlytics setUserIdentifier:myInfo[@"uid"]];
            [Crashlytics setUserEmail:myInfo[@"email"]];
            //			[Crashlytics setUserName:myInfo[@"name"]];
            //			[Crashlytics setObjectValue:[self readPlist:@"custid"] forKey:@"CompanyCode"];
        }
    } else if([key isEqualToString:@"custid"]) {
        NSString *companyCode = (NSString*)value;
        if (companyCode) {
//            [Crashlytics setUserName:companyCode];
        }
    }
    else if([key isEqualToString:@"employeinfo"]){
        
        NSString *newString = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
        value = [newString length]>0?value:@"";
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [plistDict setObject:value forKey:key];
    [plistDict writeToFile:filePath atomically: YES];
    
    
}


- (id)readPlist:(NSString *)key{
    
    //    NSLog(@"key %@",key);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    
    
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    id result = plistDict[key];
    
    //    NSLog(@"result %@",result);
    
    if(result == nil)
        result = @"";
    
    return result;
    /* You could now call the string "value" from somewhere to return the value of the string in the .plist specified, for the specified key. */
}



- (void)setIconBadge:(NSInteger)num{
    NSLog(@"setIconBadge %d",(int)num);
  
}



- (void)settingLogin{
    
    [root removeTab];
    
    self.window.rootViewController = root.login;
    
}
- (void)settingMain{
    
    [root removeLogin];
    
    [root settingTab];
    UINavigationController *nc1 = [[CBNavigationController alloc]initWithRootViewController:root];
    self.window.rootViewController = nc1;
    
    
    
    NSDictionary *myinfodic = [SharedAppDelegate readPlist:@"myinfo"];
    NSDictionary *searchmydic = [root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    NSLog(@"searchmydic %@",searchmydic);
    
    NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
    [newMyinfo setObject:myinfodic[@"cellphone"]!=nil?myinfodic[@"cellphone"]:@"" forKey:@"cellphone"];
    [newMyinfo setObject:myinfodic[@"name"]!=nil?myinfodic[@"name"]:@"" forKey:@"name"];
    [newMyinfo setObject:myinfodic[@"profileimage"]!=nil?myinfodic[@"profileimage"]:@"" forKey:@"profileimage"];
    [newMyinfo setObject:myinfodic[@"officephone"]!=nil?myinfodic[@"officephone"]:@"" forKey:@"officephone"];
    [newMyinfo setObject:myinfodic[@"uid"]!=nil?myinfodic[@"uid"]:@"" forKey:@"uid"];
    [newMyinfo setObject:myinfodic[@"sessionkey"]!=nil?myinfodic[@"sessionkey"]:@"" forKey:@"sessionkey"];
    [newMyinfo setObject:searchmydic[@"grade2"]!=nil?searchmydic[@"grade2"]:@"" forKey:@"position"];
    [newMyinfo setObject:searchmydic[@"newfield4"]!=nil?searchmydic[@"newfield4"]:@"" forKey:@"newfield4"];
    [newMyinfo setObject:searchmydic[@"newfield3"]!=nil?searchmydic[@"newfield3"]:@"" forKey:@"newfield3"];
    [newMyinfo setObject:searchmydic[@"newfield2"]!=nil?searchmydic[@"newfield2"]:@"" forKey:@"newfield2"];
    [newMyinfo setObject:searchmydic[@"email"]!=nil?searchmydic[@"email"]:@"" forKey:@"email"];
    [newMyinfo setObject:searchmydic[@"deptcode"]!=nil?searchmydic[@"deptcode"]:@"" forKey:@"deptcode"];
    [newMyinfo setObject:searchmydic[@"team"]!=nil?searchmydic[@"team"]:@"" forKey:@"team"];
    [SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
    
    
    
}
- (void)handleCall{
    NSLog(@"handleCall");
    self.callCenter.callEventHandler=^(CTCall* call)
    {
        
        if (call.callState == CTCallStateDisconnected)
        {
            
            NSLog(@"Call has been disconnected");
            
        }
        
        else if (call.callState == CTCallStateConnected)
        {
            
            NSLog(@"Call has just been connected");
            [self callReceived];
        }
        
        else if(call.callState == CTCallStateIncoming)
        {
            
            NSLog(@"Call is incoming");
            [self callReceived];
        }
        else if(call.callState == CTCallStateDialing)
        {
            NSLog(@"Call is Dialing");
        }
    };

}
- (void)callReceived
{
    NSLog(@"callReceived");
    
    [[VoIPSingleton sharedVoIP]callHangup:DHANGUP_3GCALL];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [root refreshSetupButton];
    
    NSLog(@"lastdate %@",[self readPlist:@"lastdate"]);
    NSLog(@"root.login %@",root.login);
    if([[self readPlist:@"lastdate"]length] > 0 && ![[self readPlist:@"lastdate"]isEqualToString:@"0000-00-00 00:00:00"] && root.login == nil)
    {
        // 로그인 되어있는가?
        [root startup];
    }
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6] ;
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSLog(@"pairs %@",pairs);
    for (NSString *pair in pairs) {
        NSLog(@"pairs %@",pair);
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSDictionary *myInfo = (NSDictionary*)[self readPlist:@"myinfo"];
    NSLog(@"myInfo uid %@",myInfo[@"uid"]);
                             
    if([myInfo[@"uid"]length]<1)
        return YES;
    
    
    NSLog(@"url recieved: %@", url);   
    NSLog(@"[url host] %@", [url host]);
         NSString *query = [[url host] substringWithRange:NSMakeRange(1, [[url host]length]-1)];
    NSDictionary *dict = [self parseQueryString:query];
    NSLog(@"query dict: %@", dict);
  
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         dict[@"number"],@"cellphone",
                         dict[@"name"],@"name",
                         @"",@"uid",
                         @"",@"position",
                         @"",@"profileimage",nil];
    
    UIView *view = [SharedAppDelegate.root.callManager setFullOutgoingWithDic:dic];
    [SharedAppDelegate.window addSubview:view];
    
    return YES;
}


@end
