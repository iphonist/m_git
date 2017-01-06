//
//  CallManager.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 2. 5..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VoIPSingleton.h"


//extern const char alertNumber;

@interface CallManager : NSObject{
    UIImageView *outgoingView;
    UIView *fullOutgoingView;
    UIImageView *incomingView;
    UIView *fullIncomingView;
    UIImageView *callingView;
    UIView *fullCallingView;
    NSString *toName;
    NSString *fromName;
    NSString *savedNum;
    //    NSString *talkingTime;
    NSTimer *_timerCall, *_timerQual;
    NSTimer *_timerOutgoing;
    int outgoingTime;
    NSDictionary *callingDic;
    UILabel *time;
    UILabel *qual;
//    UILabel *rtpSend;
    BOOL callingByPush;
    
    UIButton *cancel;
    UIButton *answer;
    UIButton *dial;
    
    BOOL bSpeakerOn;
//    BOOL bIncoming;
    NSInteger viewTag;
    UIView *dialView;
    UIImageView *coverImageViewIncoming;
    NSDictionary *incomingDic;
    
    UILabel *alertLabel;
}


- (UIView *)setFullIncoming:(NSDictionary *)dic call:(BOOL)call push:(BOOL)push active:(BOOL)active;
- (UIView *)setFullOutgoing:(NSString *)u usingUid:(int)usingUid;
- (void)mvoipIncomingWith:(NSDictionary *)dic;
- (void)checkPush;
- (void)loadCallMember;
- (UIView *)setReDialing:(NSDictionary *)dic uid:(NSString *)uid;
- (UIView *)setFullOutgoingWithDic:(NSDictionary *)dic;
- (UIView *)setFullCalling;
- (UIView *)setFullIncoming;
- (void)showWarning;
- (BOOL)isCalling;
- (BOOL)isIncoming;
- (void)mvoipIncomingWith:(NSDictionary *)dic call:(BOOL)calling;
- (void)isCallingByPush:(BOOL)yn;




@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSString *fromName;
@property (nonatomic, retain) NSString *toName;
@property (nonatomic, retain) NSString *savedNum;

@end
