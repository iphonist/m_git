//
//  DialerViewController.h
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface DialerViewController : UIViewController <UITextFieldDelegate> {
    UILabel *labelDialNumber;
    UILabel *labelDialName;
    UIButton *clearButton;
    SystemSoundID buttonClickSound;
    NSTimer *touchTimer;
    UIImageView *imageV;
    NSTimer *timer;
    NSString *callingNumber;
    NSDictionary *yourDic;
    UILabel *labelDialNumber2;
    UIView *dialScreenView;
    UIView *allView;
    
}

//- (void)playSoundForKey:(int)key;
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;


- (void)settingDialScreenWithHeight:(float)h dialer:(BOOL)dialer view:(UIView *)aView;
- (void)settingDialerWithHeight:(float)h dialer:(BOOL)dialer view:(UIView *)aView;

- (void)resetDial;
@end
