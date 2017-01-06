//
//  RootViewController.m
//  MiraeAsset
//
//  Created by Hyemin Kim on 2015. 5. 12..
//  Copyright (c) 2015년 Hyemin Kim. All rights reserved.
//

#import "MiraeAssetRootViewController.h"
#import "SetupViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/types.h>
#include <sys/sysctl.h>
//#import "KeychainItemWrapper.h"
#import <objc/runtime.h>

//#import "ring.h"


//const char paramDic;


@implementation RootViewController

@synthesize dialer, callList, contact, login, allcontact, organize;
@synthesize callManager;
@synthesize mainTabBar;


- (id)init
{
    self = [super init];
    if (self) {
        
        // Creating the controllers
        NSLog(@"RootViewController init");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSetupButton) name:@"refreshPushAlertStatus" object:nil];
        
        
        mainTabBar = [[UITabBarController alloc]init];
        dialer = [[DialerViewController alloc]init];
        callList = [[CallListViewController alloc]init];
        contact = [[ContactViewController alloc]init];
        allcontact = [[AllContactViewController alloc]init];
        callManager = [[CallManager alloc]init];
        login = [[LoginViewController alloc]init];
        organize =  [[OrganizeViewController alloc]init];
        
        
        [[ResourceLoader sharedInstance] settingDeptList];
        [[ResourceLoader sharedInstance] settingContactList];
    }
    return self;
}


- (void)loadSetup{
    
    SetupViewController *setup;
    setup = [[SetupViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:setup];
           [self presentViewController:nc animated:YES completion:nil];
}

- (void)removeLogin{
    
    if(login){
        login = nil;
    }
    if(!mainTabBar)
    {
        mainTabBar = [[UITabBarController alloc]init];
    }
}

- (void)removeTab{
    
    if(mainTabBar){
        mainTabBar = nil;
    }
    if(!login)
    {
        login = [[LoginViewController alloc]init];
    }
    
}

- (void)settingTab{
    
//    [[UITabBar appearance] setBackgroundImage: [CustomUIKit customImageNamed:@"tabbar_bg_3line.png"]];
    
    UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,44)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,44/2-17/2,144,17)];
    imageView.image = [CustomUIKit customImageNamed:@"imageview_navigationbar_logo.png"];
    [tView addSubview:imageView];
    
    self.navigationItem.titleView = tView;
    
    UIButton *setupButton = [CustomUIKit buttonWithTitle:nil
                                                fontSize:0
                                               fontColor:nil
                                                  target:self
                                                selector:@selector(loadSetup)
                                                   frame:CGRectMake(0, 0, 32, 32)
                                        imageNamedBullet:nil
                                        imageNamedNormal:@"preferences_btn.png"
                                       imageNamedPressed:nil];
    setupButton.tag = 999;
    UIBarButtonItem *setupButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
    self.navigationItem.rightBarButtonItem = setupButtonItem;
    [self refreshSetupButton];

    
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        
            [[UITabBar appearance]setBarTintColor:RGB(145, 152, 160)];
    }
    else{
    [[UITabBar appearance] setBackgroundColor:RGB(145, 152, 160)];
    }
    [[UITabBar appearance] setSelectionIndicatorImage:[SharedFunctions imageWithColor:RGB(15, 63, 123) width:320/4 height:mainTabBar.tabBar.frame.size.height]];
    
//    UINavigationController *nc1 = [[CBNavigationController alloc]initWithRootViewController:dialer];
//    UINavigationController *nc2 = [[CBNavigationController alloc]initWithRootViewController:callList];
//    UINavigationController *nc3 = [[CBNavigationController alloc]initWithRootViewController:contact];
    
    [dialer.tabBarItem setFinishedSelectedImage:[CustomUIKit customImageNamed:@"imageview_tabbar_dialer.png"] withFinishedUnselectedImage:[CustomUIKit customImageNamed:@"imageview_tabbar_dialer.png"]];
    [callList.tabBarItem setFinishedSelectedImage:[CustomUIKit customImageNamed:@"imageview_tabbar_list.png"] withFinishedUnselectedImage:[CustomUIKit customImageNamed:@"imageview_tabbar_list.png"]];
    [allcontact.tabBarItem setFinishedSelectedImage:[CustomUIKit customImageNamed:@"imageview_tabbar_organize.png"] withFinishedUnselectedImage:[CustomUIKit customImageNamed:@"imageview_tabbar_organize.png"]];
    [contact.tabBarItem setFinishedSelectedImage:[CustomUIKit customImageNamed:@"imageview_tabbar_contact.png"] withFinishedUnselectedImage:[CustomUIKit customImageNamed:@"imageview_tabbar_contact.png"]];
    
    mainTabBar.viewControllers = [NSArray arrayWithObjects: dialer,callList,allcontact,contact,nil];
    
    [self.view addSubview:mainTabBar.view];
    
}



#pragma  mark - sound file


- (void)initAudioSession{
    // Retrieve session instance
//    AVAudioSession *session = [ AVAudioSession sharedInstance ];
//    
//    [session setDelegate: self];
//    [session setCategory: AVAudioSessionCategoryAmbient error: nil];
//    NSError *activationError = nil;
//    [session setActive: YES error: &activationError];
//    
//    if([[SharedAppDelegate readPlist:@"echoswitch"]isEqualToString:@"1"]){
//        
//    }
//    else{
//        
//    }
}


- (void)initSound{
    // 사운드 파일 생성
    NSString *sndPath = [[NSBundle mainBundle]pathForResource:@"notify2" ofType:@"caf" inDirectory:NO];
    // url 생성
    CFURLRef sndURL = (__bridge CFURLRef)[[NSURL alloc]initFileURLWithPath:sndPath];
    // 사운드 아이디 생성
    AudioServicesCreateSystemSoundID(sndURL, &getSoundOut);
    
    
    sndPath = [[NSBundle mainBundle]pathForResource:@"drip" ofType:@"wav" inDirectory:NO];
    sndURL = (__bridge CFURLRef)[NSURL fileURLWithPath:sndPath];
    AudioServicesCreateSystemSoundID(sndURL, &getSoundInChat);
    
    
    sndPath = [[NSBundle mainBundle]pathForResource:@"BlooperReelBeep" ofType:@"wav" inDirectory:NO];
    sndURL = (__bridge CFURLRef)[NSURL fileURLWithPath:sndPath];
    AudioServicesCreateSystemSoundID(sndURL, &sendSoundInChat);
    
    
    
    
    //    CFRelease(sndURL);
    
}



- (void)playRingSound {
    
    NSLog(@"playRingSound");//
    //    NSLog(@"playRingSound %@",isPlaying?@"YES":@"NO");
    //    if(isPlaying)
    //        return;
    //
    //    isPlaying = YES;
    NSString *bell = [SharedAppDelegate readPlist:@"bell"];
    if ([bell length] < 1) {
        bell = @"1.wav";
        [SharedAppDelegate writeToPlist:@"bell" value:bell];
    }
    NSString *sndPath = [[NSBundle mainBundle]pathForResource:bell ofType:nil inDirectory:NO];
    CFURLRef sndURL = (__bridge CFURLRef)[NSURL fileURLWithPath:sndPath];
    AudioServicesCreateSystemSoundID(sndURL, &ringSound);
    
    [self setAudioRoute:YES];
    //    sip_ring_start();
    AudioServicesPlaySystemSound(ringSound);
    sip_ring_init();
    
}

- (void)stopRingSound{
    
    NSLog(@"stopRingSound");// %@",isPlaying?@"YES":@"NO");
    //    if(!isPlaying)
    //        return;
    //
    //    isPlaying = NO;
    //        [self setAudioRoute:NO];
    AudioServicesDisposeSystemSoundID(ringSound);
    
    sip_ring_stop();
    sip_ring_deinit();
    // AudioServicesDisposeSystemSoundID
}


#pragma mark - audio

- (void)setAudioRoute:(BOOL)speaker
{
    NSLog(@"setAudioRoute %@",speaker?@"YES":@"NO");
    
    /****************************************************************
     작업자 : 박형준
     작업일자 : 2012/06/04
     작업내용 : 오디오 출력 세션을 스피커로 강제 설정하거나 해제
     param  - speaker(BOOL) : YES = 설정, NO = 해제
     연관화면 : 없음
     ****************************************************************/
    
    UInt32 audioRouteOverride;
    if(speaker == YES) audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    else audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    
    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    //	AudioSessionSetActive(TRUE);
    
}

#pragma mark - bell

- (void)setMyProfileInfo:(NSString *)info mode:(int)mode sender:(id)sender hud:(BOOL)hud con:(UIViewController *)con
{
    /*
     mode 0 : 내 정보 설정
     mode 1 : 벨소리 설정
     mode 2 : 알림음 설정
     */
    
    if(mode == 0 && [[SharedAppDelegate readPlist:@"employeinfo"] isEqualToString:info]){
        if (hud) {
            [SVProgressHUD showSuccessWithStatus:@"성공적으로 저장되었습니다."];
        }
        if (sender) {
            [sender setEnabled:YES];
        }
        
        if(con)
            [con performSelector:@selector(setMyInfo)];
        
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(hud) {
        [SVProgressHUD showWithStatus:nil];
    }
    
    
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mirae.lemp.co.kr/"]];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    switch (mode) {
        case 0:
            parameters = @{@"uid": [SharedAppDelegate readPlist:@"myinfo"][@"uid"],
                           @"sessionkey": [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],
                           @"employeinfo": [info length]==0?@" ":info};
            break;
        case 1:
            parameters = @{@"uid": [SharedAppDelegate readPlist:@"myinfo"][@"uid"],
                           @"sessionkey": [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],
                           @"ringsound": info};
            break;
        case 2:
            parameters = @{@"uid": [SharedAppDelegate readPlist:@"myinfo"][@"uid"],
                           @"sessionkey": [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],
                           @"pushsound": info};
            break;
        default:
            parameters = nil;
            break;
    }
    NSLog(@"parameters %@",parameters);
    
    if (parameters == nil) {
        return;
    }
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setprofile.lemp" parameters:parameters];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sender) {
            [sender setEnabled:YES];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            if(hud){
                [SVProgressHUD showSuccessWithStatus:@"성공적으로 저장되었습니다."];
            }
            
            switch (mode) {
                case 0:
                    if([info length] > 0){
                        [SharedAppDelegate writeToPlist:@"employeinfo" value:info];
                    } else {
                        [SharedAppDelegate writeToPlist:@"employeinfo" value:@""];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
                    
                    if(con)
                        [con performSelector:@selector(setMyInfo)];
                    break;
                case 1:
                    if([info length]>0){
                        [SharedAppDelegate writeToPlist:@"bell" value:info];
                    } else {
                        [SharedAppDelegate writeToPlist:@"bell" value:@""];
                    }
                    break;
                    
                case 2:
                    if([info length]>0){
                        [SharedAppDelegate writeToPlist:@"pushsound" value:info];
                    } else {
                        [SharedAppDelegate writeToPlist:@"pushsound" value:@""];
                    }
                    break;
                    
                default:
                    break;
            }
        } else {
            if(hud){
                [SVProgressHUD dismiss];
            }
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupAlertViewOK:nil msg:msg];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(hud){
            [SVProgressHUD showErrorWithStatus:@"저장에 실패했습니다. 잠시 후 다시 시도해주세요"];
            
        }
        if (sender) {
            [sender setEnabled:YES];
        }
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    [operation start];
}


- (void)refreshSetupButton
{
    
    NSLog(@"refresh!");
    
    BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];
    
    
    
    UIButton *button = (UIButton*)[self.navigationItem.rightBarButtonItem.customView viewWithTag:999];
    
    //
    if (currentStatus == YES) {
        //        alertImage.hidden = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"preferences_btn.png"] forState:UIControlStateNormal];
    } else {
        //        alertImage.hidden = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"prefealert_btn.png"] forState:UIControlStateNormal];
        
    }
    
}

- (void)call:(id)sender{
    
    [self settingYours:[[sender titleLabel]text]];
}


#pragma mark - login install varicode


- (void)registerToServer:(NSString *)type key:(NSString *)key{// bell:(NSString *)bell{//setDeviceInfo:(NSString *)bell{
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mirae.lemp.co.kr/"]];
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init] ;
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *cellphone = [SharedAppDelegate readPlist:@"myinfo"][@"cellphone"];
//    NSString *name = [SharedAppDelegate readPlist:@"myinfo"][@"name"];
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size + 4);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine]; //1.2 add
    free(machine);
    
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *osver = [dev systemVersion];
    NSLog(@"SAVED DEVICEID %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushAlertLastToken"]);
    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           cellphone,@"cellphone",
                           oscode,@"oscode",
                           type,@"installtype",
                           [SharedFunctions getDeviceIDForParameter],@"deviceid",
                           applicationName,@"app",
                           osver,@"osver",
                           [carrier mobileNetworkCode]?[carrier mobileNetworkCode]:@"00",@"mnc",
                           [carrier mobileCountryCode]?[carrier mobileCountryCode]:@"000",@"mcc",
                           platform,@"devicemodel",
                           [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"appver",
//                           name,@"name",
                           key,@"verify_key",
                           nil];
    
    NSLog(@"parameter %@",param);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/sms/sms_cellphone_join.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [login callButtonEnabled];
        
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            if([type isEqualToString:@"1"]){
                if([key length]>0){
                    
//                    NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
//                    NSData *data = [NSData dataWithContentsOfURL:url];
//                    NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
//                    [data writeToFile:filePath atomically:YES];
                    
                    
                    [SharedAppDelegate writeToPlist:@"voip" value:resultDic[@"server"][@"mvoip"]];
                    [SharedAppDelegate writeToPlist:@"sip" value:resultDic[@"server"][@"sip_domain"]];
                    [SharedAppDelegate writeToPlist:@"sip_trunk" value:resultDic[@"server"][@"sip_trunk"]];
                    [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"server"][@"was"]];
                    [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
                    
                    
                    NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
                    [newMyinfo setObject:resultDic[@"uid"] forKey:@"uid"];
                    [newMyinfo setObject:resultDic[@"sessionkey"] forKey:@"sessionkey"];
        
                    [SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
                    
                    [[ResourceLoader sharedInstance] setMyUID:resultDic[@"uid"]];
                    [[ResourceLoader sharedInstance] setMySessionkey:resultDic[@"sessionkey"]];
                    [login showLoginProgress];
                    [self getVoipInfo:resultDic[@"uid"] cell:@""];
//                    [self startup];
                }
                else{
                    [login inputVaricode];
                    
                }
                
            }

            
        }
        else if([isSuccess isEqualToString:@"0014"]){
            
//            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
//            [CustomUIKit popupAlertViewOK:nil msg:msg];
//            [SharedAppDelegate.root.login moveLogin];
        }
        else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            
            //            [CustomUIKit popupAlertViewOK:@"그린톡 메시지" msg:@"고객님 로그인 정보가 정확하지\n않습니다. 회원 등록 시, 입력한 정보를\n확인하신 후 정확히 입력해 주세요."];
            //
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [login callButtonEnabled];
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"로그인을 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}


#pragma mark - get profile


- (void)getVoipInfo:(NSString *)uid cell:(NSString *)cell{// bell:(NSString *)bell{//setDeviceInfo:(NSString *)bell{
    
    NSLog(@"uid %@ cell %@",uid,cell);
    
    
    if([uid length]<1 && [cell length]<1)
        return;
    
    if([[SharedAppDelegate readPlist:@"call_auth"]isEqualToString:@"0"]){
       
            
            if(![cell hasPrefix:@"6"] && ![cell hasPrefix:@"7"]){
                [SharedAppDelegate.root.callManager showWarning];
                return;
                
            }
        
        
        }
    
    
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mirae.lemp.co.kr/"]];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                           [ResourceLoader sharedInstance].myUID,@"uid",
//                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           [SharedAppDelegate readPlist:@"myinfo"][@"uid"],@"uid",
                           [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],@"sessionkey",
                           cell,@"cellphone",
                           uid,@"otheruid",
                           nil];
    
    NSLog(@"parameter %@",param);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/voipinfo.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([resultDic[@"info"] isKindOfClass:[NSDictionary class]])
            {
                
                NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
                [newMyinfo setObject:resultDic[@"info"][@"cellphone"]!=nil?resultDic[@"info"][@"cellphone"]:@"" forKey:@"cellphone"];
                [newMyinfo setObject:resultDic[@"info"][@"name"]!=nil?resultDic[@"info"][@"name"]:@"" forKey:@"name"];
                [newMyinfo setObject:resultDic[@"info"][@"position"]!=nil?resultDic[@"info"][@"position"]:@"" forKey:@"position"];
                [newMyinfo setObject:resultDic[@"info"][@"profileimage"]!=nil?resultDic[@"info"][@"profileimage"]:@"" forKey:@"profileimage"];
                [newMyinfo setObject:resultDic[@"info"][@"officephone"]!=nil?resultDic[@"info"][@"officephone"]:@"" forKey:@"officephone"];
                [newMyinfo setObject:resultDic[@"info"][@"uid"]!=nil?resultDic[@"info"][@"uid"]:@"" forKey:@"uid"];
                [newMyinfo setObject:[SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"] forKey:@"sessionkey"];
                [SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
           
                
            }
            else{
                
            }
            [self startup];
        }
        else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}


#pragma mark - startup


#define kBomb 1
#define kUpdate 2
#define kForceUpdate 3
#define kMvoip 4


//#define kInvite 4
//#define kAppExit 5

- (void)startup
{
    
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    if([SharedAppDelegate readPlist:@"initContact"] == nil || [[SharedAppDelegate readPlist:@"initContact"]length]<1){
        [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
        [SVProgressHUD showWithStatus:@"앱을 종료하지 말고\n기다려주세요." maskType:SVProgressHUDMaskTypeBlack];
    }
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mirae.lemp.co.kr/"]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                applicationName,@"app",
                                [SharedAppDelegate readPlist:@"lastdate"],@"lastupdate",
                                oscode,@"oscode",
                                [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],@"sessionkey",
                                [SharedFunctions getDeviceIDForParameter],@"deviceid",
                                nil];
    NSLog(@"startup parameters %@",parameters);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/startup.lemp" parameters:parameters];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if (![isSuccess isEqualToString:@"0"]) {
            
            
            
            if([isSuccess isEqualToString:@"0005"] || [isSuccess isEqualToString:@"0006"] || [isSuccess isEqualToString:@"0007"]){
                NSLog(@"bomb");
                UIAlertView *alert;
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
                alert.tag = kBomb;
                [alert show];
            }
            else{// if([isSuccess isEqualToString:@"0007"]){
                NSLog(@"no employer data %@",isSuccess);
                NSString *msg;
                if([isSuccess length]<1 || [isSuccess isKindOfClass:[NSNull class]])
                    msg = [NSString stringWithFormat:@"오류: 관리자에게 문의하세요."];
                else
                    msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                
                
                [CustomUIKit popupAlertViewOK:nil msg:msg];
                
            }
        }
        else {
//            NSLog(@"server ver %@ app ver %@",resultDic[@"appver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
            if ([resultDic[@"appver"] compare:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] options:NSNumericSearch] == NSOrderedDescending) {
                NSLog(@"updategogogogo");
                UIAlertView *alert;
                
                if ([resultDic[@"updatever"] compare:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] options:NSNumericSearch] == NSOrderedDescending) {
                    alert = [[UIAlertView alloc] initWithTitle:@"필수 업데이트" message:@"필수 업데이트가 있습니다. 업데이트를 하셔야 정상적인 서비스 이용이 가능합니다." delegate:self cancelButtonTitle:@"지금 업데이트" otherButtonTitles:nil];
                    alert.tag = kForceUpdate;
                } else {
                    alert = [[UIAlertView alloc] initWithTitle:@"업데이트" message:@"새로운 업데이트가 있습니다. 기능의 원활한 이용을 위해 최신 버전으로 지금 바로 업데이트해 보세요!" delegate:self cancelButtonTitle:@"나중에" otherButtonTitles:@"지금 업데이트", nil];
                    alert.tag = kUpdate;
                }
                
                [alert show];
                
                //                return;
            } else {
                NSLog(@"loghorizon");
            }
            
            
            [SharedAppDelegate writeToPlist:@"toptree" value:resultDic[@"toptree"]];
            [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"serverinfo"][@"was"]];
            [SharedAppDelegate writeToPlist:@"sip" value:resultDic[@"serverinfo"][@"sip_domain"]];
            [SharedAppDelegate writeToPlist:@"voip" value:resultDic[@"serverinfo"][@"mvoip"]];
            [SharedAppDelegate writeToPlist:@"sip_trunk" value:resultDic[@"serverinfo"][@"sip_trunk"]];
            
            
            
            
            
            
            NSString *lastDate = [NSString stringWithString:resultDic[@"lastsynctime"]];
            
            if([[SharedAppDelegate readPlist:@"lastdate"] isEqualToString:@"0000-00-00 00:00:00"]){
                
                
                [SQLiteDBManager addColumns];
                BOOL deptUpdateComplete = NO;
                BOOL contactUpdateComplete = NO;
                NSMutableArray *deptArray = resultDic[@"dept"];
                NSLog(@"deptArray count] %d",(int)[deptArray count]);
                
                if(deptArray != nil && [deptArray count]>0){
                    NSLog(@"addDept 2nd");
                    [SQLiteDBManager removeDeptWithCode:@"0" all:YES];
                    deptUpdateComplete = [SQLiteDBManager addDept:deptArray];
                    if(SharedAppDelegate.root.login){
                        dispatch_async(dispatch_get_main_queue(), ^{
                        [SharedAppDelegate.root.login changeText:@"중... 2/5" setProgressText:@"0.4"];
                        });
                    }
                } else {
                    deptUpdateComplete = YES;
                }
                
                
                
                [[ResourceLoader sharedInstance] settingDeptList];
                
                
                
                NSMutableArray *contactArray = resultDic[@"contact"];
                NSLog(@"contactArray count] %d",(int)[contactArray count]);
                
                if(contactArray != nil && [contactArray count]>0){
                    
                    [SQLiteDBManager removeContactWithUid:@"0" all:YES];
                    contactUpdateComplete = [SQLiteDBManager addContact:contactArray init:YES];
                    if(SharedAppDelegate.root.login){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SharedAppDelegate.root.login changeText:@"중... 3/5" setProgressText:@"0.4"];
                        });
                    }
                    
                } else {
                    contactUpdateComplete = YES;
                }
                
                
                
                
                [[ResourceLoader sharedInstance] settingContactList];
                
                                       if(SharedAppDelegate.root.login){
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [SharedAppDelegate.root.login changeText:@"중... 4/5" setProgressText:@"0.9"];
                                           });
                }
                
                
                NSLog(@"dept %@ contact %@",deptUpdateComplete?@"OK":@"NO",contactUpdateComplete?@"OK":@"NO");
                if (deptUpdateComplete && contactUpdateComplete) {
                    [SharedFunctions setLastUpdate:lastDate];
                    [self endRefresh];
                }
                
                
                if([SharedAppDelegate readPlist:@"initContact"] == nil || [[SharedAppDelegate readPlist:@"initContact"]length]<1){
                    [SVProgressHUD dismiss];
                    [SharedAppDelegate writeToPlist:@"initContact" value:@"YES_ios9"];
                }
                
            }
            else{
                
                if([resultDic[@"voipinfo"]count]>0){
                    
                        [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setFullIncoming:resultDic[@"voipinfo"][0] call:NO push:NO active:NO]];
                }else{
                    [SharedAppDelegate.root.callManager checkPush];
                }
            
                
                
                BOOL deptUpdateComplete = NO;
                BOOL contactUpdateComplete = NO;
                BOOL passThru = YES;
                
                if([resultDic[@"dept"] count] > 0){
                    
                    deptUpdateComplete = [self compareDept:resultDic[@"dept"]];
                    
                    passThru = NO;
                } else {
                    deptUpdateComplete = YES;
                }
                if([resultDic[@"contact"] count] > 0){
                    
                    
                    contactUpdateComplete = [self compareCompany:resultDic[@"contact"]];
                    
                    passThru = NO;
                } else {
                    contactUpdateComplete = YES;
                }
                if(passThru == NO){
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        [[ResourceLoader sharedInstance] settingDeptList];
                        [[ResourceLoader sharedInstance] settingContactList];
                        dispatch_async(dispatch_get_main_queue(), ^{
                        });
                    });
                }
                
                if (deptUpdateComplete && contactUpdateComplete && !passThru) {
                    [SharedFunctions setLastUpdate:lastDate];
                 
                }
            }
            
            NSLog(@"startup favoritelist %@",resultDic[@"Favorite"][@"member"]);
            if([resultDic[@"Favorite"][@"member"]count]>0)
            {
                [[ResourceLoader sharedInstance].favoriteList setArray:resultDic[@"Favorite"][@"member"]];
            } else {
                [[ResourceLoader sharedInstance].favoriteList removeAllObjects];
            }
            for(int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++){
                BOOL bFavorite = NO;
                NSString *chkUid = [ResourceLoader sharedInstance].allContactList[i][@"uniqueid"];
                for(int j = 0; j < [[ResourceLoader sharedInstance].favoriteList count]; j++){
                    NSString *aUid = [ResourceLoader sharedInstance].favoriteList[j];
                    if([aUid isEqualToString:chkUid]){
                        bFavorite = YES;
                        break;
                    }
                }
                
                if(bFavorite)
                    [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:@"1" key:@"favorite"]];
                else
                    [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:@"0" key:@"favorite"]];
                
            }
            
            for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++){
                BOOL bFavorite = NO;
                NSString *chkUid = [ResourceLoader sharedInstance].contactList[i][@"uniqueid"];
                for(int j = 0; j < [[ResourceLoader sharedInstance].favoriteList count]; j++){
                    NSString *aUid = [ResourceLoader sharedInstance].favoriteList[j];
                    if([aUid isEqualToString:chkUid]){
                        bFavorite = YES;
                        break;
                    }
                }
                
                if(bFavorite)
                    [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:@"1" key:@"favorite"]];
                else
                    [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:@"0" key:@"favorite"]];
                
            }
            
            
            
            
            


        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [SVProgressHUD dismiss];
        [CustomUIKit popupAlertViewOK:@"오류" msg:@"네트워크 접속이 원활하지 않습니다.\n요청한 동작이 수행되지 않을 수 있습니다.\n잠시 후 다시 시도해주세요."];
        
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"authenticate 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == kBomb){
//        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
//            NSLog(@"kBomb 1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
//            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//        }
//        
//        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
//            NSLog(@"kBomb 2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
//            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//        }
//        
//        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
//            NSLog(@"kBomb 3 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
//            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//        }
//        
//        if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
//            NSLog(@"kBomb 4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
//            [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//        }
//
//        
//        
//        [SQLiteDBManager removeRoom:@"0" all:YES];
        [SQLiteDBManager removeCallLogRecordWithId:0 all:YES];
        [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
//
//        //        if(self.slidingViewController.modalViewController)
//        //            [self.slidingViewController.modalViewController dismissModalViewControllerAnimated:NO];
//        //
//        //        if(self.slidingViewController.modalViewController)
//        //            [self.slidingViewController.modalViewController dismissModalViewControllerAnimated:NO];
//        //        
//        //        if(self.slidingViewController.modalViewController)
//        //            [self.slidingViewController.modalViewController dismissModalViewControllerAnimated:NO];
//        
        [SharedAppDelegate settingLogin];
    }
    else if(alertView.tag == kUpdate){
        if(buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];//@"itms-services://?action=download-manifest&url=http://app.thinkbig.co.kr:62230/file/ios/wjtb_teacher.plist"]];
        }
    }
    else if(alertView.tag == kForceUpdate){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];
        
    }
    else if(alertView.tag == kMvoip){
        if(buttonIndex == 1){
            
            UIView *view = [SharedAppDelegate.root.callManager setFullOutgoingWithDic:paramDic];
            [SharedAppDelegate.window addSubview:view];
            
            }
//    else if(alertView.tag == kInvite){
//        if(buttonIndex == 1){
//            
//            NSString *uid = objc_getAssociatedObject(alertView, &paramNumber);
//            NSLog(@"uid %@",uid);
//            [self inviteBySMS:[NSString stringWithFormat:@"%@,",uid]];
//            
//        }
//    }
}
}


#pragma mark - compare contact dept organizing


- (void)endRefresh{
    NSLog(@"endRefresh");
    
    [SVProgressHUD dismiss];
    
    if(SharedAppDelegate.root.login){
        [SharedAppDelegate.root.login changeText:@"완료" setProgressText:@"1.0"];
        [SharedAppDelegate.root.login removeView];
    }
    
    [SharedAppDelegate settingMain];
    
    
}

- (BOOL)compareCompany:(NSMutableArray *)aContact{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 추가/수정/삭제 여부를 결정한다. retirementvalue가 Y이면 삭제한다. N이면 내 DB와 비교해 새로운 정보인지 수정할 정보인지 구분한다. 구분해서 임시 배열에 넣은 뒤, DB와 변수 모두에 적용한다. 그리고 만약 내 정보가 수정된 정보에 들어오는데, deptcode나 grplvl이 변경된 것이라면, 새로 로그인한다는 알림을 띄운다.
     param  - list(NSMutableArray *) : 추가/수정/삭제된 주소록 배열
     연관화면 : 없음
     ****************************************************************/
    
    
    //        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //
    NSMutableArray *addArray = [NSMutableArray array];
    NSMutableArray *updateArray = [NSMutableArray array];
    NSMutableArray *deleteArray = [NSMutableArray array];
    
    for(NSDictionary *listDic in aContact)//int i = 0;i < [list count]; i++)
    {
        NSString *aUid = listDic[@"uid"];
        
        NSString *retirement = listDic[@"retirement"];
        if([retirement isEqualToString:@"Y"])
        {

            [deleteArray addObject:aUid];
            
            
            
        }
        
        else
        {
//            NSDictionary *mydic = [SharedAppDelegate readPlist:@"myinfo"];
            if([self checkUpdate:listDic] == YES)
            {
                NSLog(@" update data %@",aUid);
                
                
                
                [updateArray addObject:listDic];
            }
            
            else
            {
                
                NSLog(@" add data %@",aUid);
                [addArray addObject:listDic];
                
            }
            
        }
        
    }
    
    BOOL removeContact = NO;
    BOOL addContact = NO;
    BOOL updateContact = NO;
    
    if ([deleteArray count]>0) {
        removeContact = [SQLiteDBManager removeContact:deleteArray];
    } else {
        removeContact = YES;
    }
    if([addArray count]>0) {
        //        [self addContact:addArray];
        addContact = [SQLiteDBManager addContact:addArray init:NO];
    } else {
        addContact = YES;
    }
    if([updateArray count]>0) {
        //		[self updateContactArray:updateArray];
        updateContact = [SQLiteDBManager updateContactArray:updateArray];
    } else {
        updateContact = YES;
    }
    
    return (removeContact && addContact && updateContact);
}

- (BOOL)checkUpdate:(NSDictionary *)checkDic
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 DB에서 가져온 주소록 배열에서 딕셔너리 사번과 비교해 주소록에 있는 딕셔너리인지 아닌지 구분한다.
     param  - dic(NSDictionary *) : 주소록 딕셔너리
     연관화면 : 없음
     ****************************************************************/
    
    
    BOOL checkUpdate = NO;
    NSString *checkUid = checkDic[@"uid"];
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].contactList)
    {
        NSString *uniqueid = forDic[@"uniqueid"];
        if([uniqueid isEqualToString:checkUid])
        {
            checkUpdate = YES;
            break;
        }
    }
    
    return checkUpdate;
}




- (BOOL)compareDept:(NSMutableArray *)list
{
    NSLog(@"list %@",list);
    
    //    NSLog(@"reGetOrganizing",list);
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //
    NSMutableArray *updateArray = [NSMutableArray array];
    NSMutableArray *addArray = [NSMutableArray array];
    NSMutableArray *deleteArray = [NSMutableArray array];
    
    for(NSDictionary *listDic in list)//int i = 0;i < [list count]; i++)
    {
        NSString *close = listDic[@"close"];
        if([close isEqualToString:@"Y"])
        {
            
            [deleteArray addObject:listDic[@"deptcode"]];
            //            [SQLiteDBManager removeDeptWithCode:listDic[@"deptcode"] all:NO];
        }
        else
        {
            if([self checkOrganizingUpdate:listDic] == YES)
            {
                NSLog(@"update organize");
                [updateArray addObject:listDic];
            }
            else
            {
                NSLog(@"add organize");
                [addArray addObject:listDic];
            }
            
        }
        
    }
    
    BOOL removeDept = NO;
    BOOL addDept = NO;
    BOOL updateDept = NO;
    if ([deleteArray count]>0) {
        removeDept = [SQLiteDBManager removeDept:deleteArray];
    } else {
        removeDept = YES;
    }
    if([addArray count]>0) {
        addDept = [SQLiteDBManager addDept:addArray];
    } else {
        addDept = YES;
    }
    if([updateArray count]>0) {
        updateDept = [SQLiteDBManager updateDeptArray:updateArray];
    } else {
        updateDept = YES;
    }
    
    return (removeDept && addDept && updateDept);

    
    
    
}


- (BOOL)checkOrganizingUpdate:(NSDictionary *)checkDic
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 DB에서 가져온 조직도 배열에서 딕셔너리 mycode와 비교해 조직도에 있는 딕셔너리인지 아닌지 구분한다.
     param  - dic(NSDictionary *) : 조직도 딕셔너리
     연관화면 : 없음
     ****************************************************************/
    
    
    BOOL checkOrganizingUpdate = NO;
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].deptList) {
        NSString *mycode = forDic[@"mycode"];
        NSString *deptcode = checkDic[@"deptcode"];
        if([mycode isEqualToString:deptcode]) {
            checkOrganizingUpdate = YES;
            break;
        }
    }
    return checkOrganizingUpdate;
}



#pragma mark - image profile

- (void)getProfileImageWithURL:(NSString *)uid ifNil:(NSString *)ifnil view:(UIImageView *)profileImageView scale:(int)scale
{
    
    NSLog(@"getProfileImageWithURL %@ ifnil %@",uid,ifnil);

    profileImageView.image = [UIImage imageNamed:ifnil];
//    NSString *theUID = uid;//[[SharedFunctions minusMe:uid] componentsSeparatedByString:@","][0];
//    
//    NSURL *imgURL;
//    
//    if ([theUID isEqualToString:[ResourceLoader sharedInstance].myUID]) {
//        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",theUID];
//        NSLog(@"getMyProfile!!!! %@",documentPath);
//        imgURL = [NSURL fileURLWithPath:documentPath];
//    } else {
//        NSString *profileImageInfo = [ResourceLoader checkProfileImageWithUID:theUID];
//        NSLog(@"otherProfile!!!! %@",profileImageInfo);
//        imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:YES];
//    }
//    NSLog(@"imgURL %@",imgURL);
//    
//    [profileImageView setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:ifnil] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
//                              success:^(UIImage *image, BOOL cached) {
//                                  if (image != nil && scale != 0) {
//                                      NSLog(@"roundProfileImage");
//                                      [ResourceLoader roundCornersOfImage:image scale:scale block:^(UIImage *roundedImage) {
//                                          [profileImageView setImage:roundedImage];
//                                      }];
//                                  }
//                              } failure:^(NSError *error) {
//                                  NSLog(@"setImage Error %@",[error description]);
//                                  [HTTPExceptionHandler handlingByError:error];
//                                  
//                              }];
    
}

#pragma mark - Search List From DB
- (NSDictionary *)searchDicWithNumber:(NSString *)num{
    
    
    if([num isEqualToString:@""] || num == nil)
        return nil;
    
    num = [SharedFunctions getPureNumbers:num];
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].allContactList){
        
        NSString *cellphone = [SharedFunctions getPureNumbers:forDic[@"cellphone"]];
        NSString *companyphone = [SharedFunctions getPureNumbers:forDic[@"companyphone"]];
        if([cellphone rangeOfString:num].location != NSNotFound
           || [companyphone rangeOfString:num].location != NSNotFound
           )
        {
            dic = forDic;
            break;
        }
    }
    NSLog(@"num %@ searchContactDictionary %@",num,dic);
    return dic;
}

    
    

- (NSDictionary *)searchAppNo:(NSString *)fmc{
    
    //    NSLog(@"uid %@",uid);
    //
    if([fmc isEqualToString:@""])
    {
        return nil;
    }
    
    
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].allContactList){
        NSString *aFmc = forDic[@"newfield4"];
        NSString *aFmcSubstring = [aFmc substringWithRange:NSMakeRange(1, [aFmc length]-1)];
        if([aFmc isEqualToString:fmc] || [aFmcSubstring isEqualToString:fmc]) {
            dic = forDic;
            break;
        }
    }
    NSLog(@"uid %@ searchContactDictionary %@",fmc,dic);
    return dic;
}
- (NSDictionary *)searchContactDictionary:(NSString *)uid{
    
    //    NSLog(@"uid %@",uid);
    //
    if([uid isEqualToString:@""])
    {
        return nil;
    }
    else
        uid = [[SharedFunctions minusMe:uid] componentsSeparatedByString:@","][0];
    
    //    // select한 값을 배열로 저장
    
    if([uid hasSuffix:@","])
        uid = [uid substringToIndex:[uid length]-1];
    
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].allContactList){
        NSString *aUid = forDic[@"uniqueid"];
        if([aUid isEqualToString:uid]) {
            dic = forDic;
            break;
        }
    }
    NSLog(@"uid %@ searchContactDictionary %@",uid,dic);
    return dic;
    
    
}

#pragma mark - select contact

#define kCallSelect 100

- (void)settingYours:(NSString *)uid{
    
    NSLog(@"settingYours %@",uid);
    
    NSDictionary *dic = [self searchContactDictionary:uid];
    NSString *app_no = (dic[@"newfield4"] != nil && [dic[@"newfield4"]length]>0)?dic[@"newfield4"]:@"";
    NSString *fmc = [NSString stringWithFormat:@"FMC 전화 %@",app_no];
    NSString *officephone = [NSString stringWithFormat:@"내선전화 %@",[app_no length]>1?[app_no substringWithRange:NSMakeRange(1, [app_no length]-1)]:@""];
    NSString *cellphone = [NSString stringWithFormat:@"휴대폰전화 %@",[dic[@"cellphone"]length]>1?dic[@"cellphone"]:@""];
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"통화 하기" delegate:self cancelButtonTitle:@"취소"
                                destructiveButtonTitle:nil otherButtonTitles:fmc,officephone, cellphone, nil];
    actionSheet.tag = kCallSelect;
    [actionSheet showInView:SharedAppDelegate.window];
    actionSheet.accessibilityValue = uid;

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionsheet.tag %d",(int)actionSheet.tag);
    NSLog(@"actionsheet.tag %@",[actionSheet accessibilityValue]);
    
    if(paramDic){
        [paramDic release];
        paramDic = nil;
    }
    paramDic = [[NSDictionary alloc]initWithDictionary:[self searchContactDictionary:[actionSheet accessibilityValue]]];
    NSLog(@"paramDic %@",paramDic);
    
//    [self getVoipInfo:resultDic[@"uid"] cell:@"" itsme:YES];
//    UIAlertView *alert;
    if(actionSheet.tag == kCallSelect)
    {
        switch (buttonIndex)
        {

            case 0:{
                if([paramDic[@"available"]isEqualToString:@"0"] || [paramDic[@"available"]isEqualToString:@"4"]){
                    
                    [CustomUIKit popupAlertViewOK:nil msg:@"미래FMC 앱이 설치되지 않은 사용자 입니다."];
                    return;
                }
                
                if([paramDic[@"newfield4"]length]<2){
                    
                    [CustomUIKit popupAlertViewOK:nil msg:@"FMC 번호가 준비중입니다."];
                    return;
                }
                
                [self directAddOutgoing:paramDic num:paramDic[@"newfield4"]];
       
                
            }
                break;
            case 1:{
                if([paramDic[@"newfield4"]length]<2){
                    
                    [CustomUIKit popupAlertViewOK:nil msg:@"FMC 번호가 준비중입니다."];
                    return;
                }
                
                [self directAddOutgoing:paramDic num:[paramDic[@"newfield4"] substringWithRange:NSMakeRange(1, [paramDic[@"newfield4"]length]-1)]];
            
                
                
                
            }
                break;
            case 2:{
                
                if([paramDic[@"cellphone"]length]<2){
                    
                    [CustomUIKit popupAlertViewOK:nil msg:@"휴대폰 번호가 없습니다."];
                    return;
                }
                
                [self directAddOutgoing:paramDic num:paramDic[@"cellphone"]];
            
            }
                break;
            default:
                break;
        }
    }
    
}


//#pragma mark - uuid to keychain
//
//
//- (NSString *)getDeviceUUID{
//    KeychainItemWrapper *keychainItemWrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"uuid-itentifier" accessGroup:nil];
//    NSString *uuidValue = [keychainItemWrapper objectForKey:kSecAttrAccount];
//    NSLog(@"uuidValue %@",uuidValue);
//    NSString *uuidValue2 = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    if(uuidValue == nil || [uuidValue length]<=0){
//    
//        [keychainItemWrapper setObject:uuidValue2 forKey:kSecAttrAccount];
//        NSLog(@"uuidValue %@",uuidValue2);
//    }
//    else{
//        
//    }
//
//    return uuidValue;
//}

#pragma mark - load search


- (void)loadSearch:(int)tag// con:(UIViewController *)con
{
    //FromWhere:tag];
    search = [[SearchContactController alloc]init];
    [search setListAndTable:tag];
    UINavigationController *nav = [[CBNavigationController alloc]initWithRootViewController:search];
    if(self.modalViewController){
        [self.modalViewController presentModalViewController:nav animated:YES];
    }
    else
        [self presentModalViewController:nav animated:YES];
    
    [nav release];
    //    [con presentModalViewController:nav animated:YES];
    
}

#pragma mark - dash check 


- (NSString *)dashCheck:(NSString *)num
{
    NSString *returnNum = @"";//[[[NSString alloc]init]autorelease];
    NSLog(@"num %@",num);
//    if([num length]>6 && ([num hasPrefix:@"1"] || [num hasPrefix:@"2"] || [num hasPrefix:@"3"] || [num hasPrefix:@"4"] || [num hasPrefix:@"5"] || [num hasPrefix:@"6"] || [num hasPrefix:@"7"] || [num hasPrefix:@"8"] || [num hasPrefix:@"9"]))
//        num = [NSString stringWithFormat:@"0%@",num];
    
    returnNum = num;
    
    
    if([num hasPrefix:@"02"])
    {
        if([num hasPrefix:@"02-"])
            returnNum = num;
        
        
        else
        {
            if([num length]==10)
            {
                returnNum = [NSString stringWithFormat:@"%@-%@-%@",[num substringWithRange:NSMakeRange(0, 2)],[num substringWithRange:NSMakeRange(2, 4)],[num substringWithRange:NSMakeRange(6, 4)]];
            }
            else if([num length]==9)
            {
                returnNum = [NSString stringWithFormat:@"%@-%@-%@",[num substringWithRange:NSMakeRange(0, 2)],[num substringWithRange:NSMakeRange(2, 3)],[num substringWithRange:NSMakeRange(5, 4)]];
            }
            
        }
    }
    else if([num hasPrefix:@"070"] || [num hasPrefix:@"010"] || [num hasPrefix:@"011"] || [num hasPrefix:@"016"] ||
            [num hasPrefix:@"017"] || [num hasPrefix:@"019"] || [num hasPrefix:@"031"] || [num hasPrefix:@"032"] ||
            [num hasPrefix:@"033"] || [num hasPrefix:@"041"] || [num hasPrefix:@"042"] || [num hasPrefix:@"043"] ||
            [num hasPrefix:@"051"] || [num hasPrefix:@"052"] || [num hasPrefix:@"053"] || [num hasPrefix:@"054"] ||
            [num hasPrefix:@"055"] || [num hasPrefix:@"061"] || [num hasPrefix:@"062"] || [num hasPrefix:@"063"]
            || [num hasPrefix:@"064"])
    {
        
        if([num hasPrefix:@"070-"] || [num hasPrefix:@"010-"] || [num hasPrefix:@"011-"] || [num hasPrefix:@"016-"] ||
           [num hasPrefix:@"017-"] || [num hasPrefix:@"019-"] || [num hasPrefix:@"031-"] || [num hasPrefix:@"032-"] ||
           [num hasPrefix:@"033-"] || [num hasPrefix:@"041-"] || [num hasPrefix:@"042-"] || [num hasPrefix:@"043-"] ||
           [num hasPrefix:@"051-"] || [num hasPrefix:@"052-"] || [num hasPrefix:@"053-"] || [num hasPrefix:@"054-"] ||
           [num hasPrefix:@"055-"] || [num hasPrefix:@"061-"] || [num hasPrefix:@"062-"] || [num hasPrefix:@"063-"]
           || [num hasPrefix:@"064-"])
            returnNum = num;
        
        
        else
        {
            
            if([num length]==11)
            {
                returnNum = [NSString stringWithFormat:@"%@-%@-%@",[num substringWithRange:NSMakeRange(0, 3)],[num substringWithRange:NSMakeRange(3, 4)],[num substringWithRange:NSMakeRange(7, 4)]];
            }
            else if([num length]==10)
            {
                returnNum = [NSString stringWithFormat:@"%@-%@-%@",[num substringWithRange:NSMakeRange(0, 3)],[num substringWithRange:NSMakeRange(3, 3)],[num substringWithRange:NSMakeRange(6, 4)]];
            }
        }
    }
    return returnNum;
    
}


#pragma mark - call outgoing
    
    
    - (void)directAddOutgoing:(NSDictionary *)dic num:(NSString *)number{
        
        if([[SharedAppDelegate readPlist:@"call_auth"]isEqualToString:@"0"]){
            
            
            if(![number hasPrefix:@"6"] && ![number hasPrefix:@"7"]){
                [SharedAppDelegate.root.callManager showWarning];
                return;
                
            }
            
            
        }
        
        
        NSDictionary *calldic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 number,@"cellphone",
                                 dic[@"name"],@"name",
                                 dic[@"uniqueid"],@"uid",
                                 dic[@"position"],@"grade2",
                                 dic[@"profileimage"],@"profileimage",nil];
        
        if(paramDic){
            [paramDic release];
            paramDic = nil;
        }
        paramDic = [[NSDictionary alloc]initWithDictionary:calldic];
        NSLog(@"paramDic %@",paramDic);
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"무선 데이터 네트워크 상태가 고르지 못할 경우 (3G 혹은 신호강도가 약한 WiFi 에 연결) 통화품질이 낮을 수 있습니다. 가입하신 통신사의 3G/LTE 네트워크로 접속시 사용중인 요금제의 기본 제공 데이터가 소모됩니다.(1분 통화시 약 1.2MB)" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        alert.tag = kMvoip;
        //                objc_setAssociatedObject(alert, &paramDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alert show];
        [alert release];
        
        
    }
    
    - (void)makeDicOutgoing:(NSString *)uid num:(NSString *)num{
        
        if([uid length]<1 && [num length]<1)
            return;
        
        if([[SharedAppDelegate readPlist:@"call_auth"]isEqualToString:@"0"]){
            
            
            if(![num hasPrefix:@"6"] && ![num hasPrefix:@"7"]){
                [SharedAppDelegate.root.callManager showWarning];
                return;
                
            }
            
            
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             num,@"cellphone",
                             @"",@"name",
                             uid,@"uid",
                             @"",@"position",
                             @"",@"profileimage",nil];
        
        if(paramDic){
            [paramDic release];
            paramDic = nil;
        }
        paramDic = [[NSDictionary alloc]initWithDictionary:dic];
        NSLog(@"paramDic %@",paramDic);
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"무선 데이터 네트워크 상태가 고르지 못할 경우 (3G 혹은 신호강도가 약한 WiFi 에 연결) 통화품질이 낮을 수 있습니다. 가입하신 통신사의 3G/LTE 네트워크로 접속시 사용중인 요금제의 기본 제공 데이터가 소모됩니다.(1분 통화시 약 1.2MB)" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        //                objc_setAssociatedObject(alert, &paramDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        alert.tag = kMvoip;
        [alert show];
        [alert release];
    }
    

- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav
{
    //    NSLog(@"visible view con %@",self.centerController.visibleViewController);
    [search refreshSearchFavorite:uid fav:fav];
    [organize refreshSearchFavorite:uid fav:fav];
    [allcontact setFavoriteList];
}

- (void)dealloc{
    
    if(mainTabBar)
        [mainTabBar release];
    if(login)
        [login  release];
    [dialer release];
    [callList release];
    [contact release];
    [callManager release];
    
    
    [super dealloc];
}
@end
