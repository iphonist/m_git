//
//  RootViewController.h
//  MiraeAsset
//
//  Created by Hyemin Kim on 2015. 5. 12..
//  Copyright (c) 2015년 Hyemin Kim. All rights reserved.
//



#import "DialerViewController.h"
#import "CallListViewController.h"
#import "ContactViewController.h"
#import "CallManager.h"
#import "LoginViewController.h"
#import "AllContactViewController.h"
#import "OrganizeViewController.h"
#import "SearchContactController.h"


@interface RootViewController : UIViewController<UIActionSheetDelegate, AVAudioSessionDelegate>{
    UITabBarController *mainTabBar;
    DialerViewController *dialer;
    CallListViewController *callList;
    ContactViewController *contact;
    CallManager *callManager;
    LoginViewController *login;
    AllContactViewController *allcontact;
    OrganizeViewController *organize;
    
    SystemSoundID getSoundInChat;
    SystemSoundID sendSoundInChat;
    SystemSoundID getSoundOut;
    SystemSoundID ringSound;
    SearchContactController *search;
    AVAudioUnit *kAudioUnit;
    
    NSDictionary *paramDic;
    
}

@property (nonatomic, retain) UITabBarController *mainTabBar;
@property (nonatomic, retain) DialerViewController *dialer;
@property (nonatomic, retain) CallListViewController *callList;
@property (nonatomic, retain) ContactViewController *contact;
@property (nonatomic, retain) CallManager *callManager;
@property (nonatomic, retain) LoginViewController *login;
@property (nonatomic, retain)  AllContactViewController *allcontact;
@property (nonatomic, retain)  OrganizeViewController *organize;

- (void)removeLogin;
- (void)removeTab;
- (void)settingTab;
- (void)setAudioRoute:(BOOL)speaker;
- (void)stopRingSound;
- (void)playRingSound;
- (void)initSound;
- (void)refreshSetupButton;
- (void)getProfileImageWithURL:(NSString *)uid ifNil:(NSString *)ifnil view:(UIImageView *)profileImageView scale:(int)scale;
- (void)registerToServer:(NSString *)type key:(NSString *)key;
- (void)startup;
- (void)setMyProfileInfo:(NSString *)info mode:(int)mode sender:(id)sender hud:(BOOL)hud con:(UIViewController *)con;
//- (NSString *)getDeviceUUID;
- (NSDictionary *)searchContactDictionary:(NSString *)uid;
- (void)settingYours:(NSString *)uid;
- (void)loadSearch:(int)tag;// con:(UIViewController *)con;
- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav;
- (void)getVoipInfo:(NSString *)uid cell:(NSString *)cell;
- (void)directAddOutgoing:(NSDictionary *)dic num:(NSString *)number;
- (void)makeDicOutgoing:(NSString *)uid num:(NSString *)num;
- (NSDictionary *)searchAppNo:(NSString *)fmc;
- (NSString *)dashCheck:(NSString *)num;
- (void)initAudioSession;
- (NSDictionary *)searchDicWithNumber:(NSString *)num;



@end
