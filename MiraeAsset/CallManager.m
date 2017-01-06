//
//  CallManager.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 2. 5..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "CallManager.h"
#import <objc/runtime.h>
//#import "ring.h"

@interface CallManager ()


@end

const char alertNumber;

@implementation CallManager

@synthesize audioPlayer;
@synthesize fromName;
@synthesize toName;
@synthesize savedNum;

- (void)showWarning{
    
    [CustomUIKit popupAlertViewOK:nil msg:@"외부 발신 권한이 없습니다."];
}

- (void)closeAllCallView{
    NSLog(@"closeAllCallView \n out %@ \n income %@ \n call %@",fullOutgoingView,fullIncomingView,fullCallingView);
    
    if(fullOutgoingView){
        //        [self cancelFullOutgoing];
        [fullOutgoingView removeFromSuperview];
//        [fullOutgoingView release];
        fullOutgoingView = nil;
    }
    //    if(incomingView)
    //        [self cancelSideIncoming];
    if(fullIncomingView){
        //        sip_ring_stop();
        //        sip_ring_deinit();
        [SharedAppDelegate.root stopRingSound];
        //        [self cancelFullOutgoing];
        [fullIncomingView removeFromSuperview];
//        [fullIncomingView release];
        fullIncomingView = nil;
    }
    //    if(callingView)
    //        [self cancelSideCalling];
    if(fullCallingView){
        //        [self cancelFullOutgoing];
        [fullCallingView removeFromSuperview];
//        [fullCallingView release];
        fullCallingView = nil;
    }
    //      [[VoIPSingleton sharedVoIP] callSpeaker:NO];
    //	[SharedAppDelegate.root setAudioRoute:NO];
    //    sip_ring_stop();
    //    sip_ring_deinit();
    
    [SharedAppDelegate.root setAudioRoute:NO];
    [[VoIPSingleton sharedVoIP] callSpeaker:NO];
    [self isCallingByPush:NO];
    
    

    
    
    [SharedAppDelegate.root.dialer resetDial];
    
    
    
    


}


#define kUsingUid 1
#define kNotUsingUid 2
#define kNumber 3


- (void)selectedMember:(NSMutableArray*)member
{
    NSLog(@"member %@",member);
    if ([member count] < 1) {
        [SVProgressHUD showErrorWithStatus:@"선택된 대상이 없습니다!"];
        return;
    }
    [SharedAppDelegate.window addSubview:[self setFullOutgoing:member[0][@"uniqueid"] usingUid:kUsingUid]];
}



- (void)callAlert:(NSString *)number{
    
    NSLog(@"number %@",number);
    
    UIAlertView *alert;
    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 연결하시겠습니까?",number];
    alert = [[UIAlertView alloc] initWithTitle:@"일반통화" message:msg delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
    objc_setAssociatedObject(alert, &alertNumber, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
//    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
//        NSString *number = objc_getAssociatedObject(alertView, &alertNumber);
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:number]]]];
//        
        
    }
    
}

#pragma mark - sount output

- (void)playDialingSound
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"lemp_ringbacktone" ofType:@"wav" inDirectory:NO];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:soundPath] error:nil];
    newPlayer.numberOfLoops = -1;
    
    self.audioPlayer = newPlayer;
//    [newPlayer release];
    
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}


- (void)stopDialingSound
{
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
    }
    self.audioPlayer = nil;
}

#pragma mark - mvoip

- (void)mvoipOutgoingWith:(NSString *)num{
    
    
    
    
    NSLog(@"mvoipOutgoingWith %@",num);
    
    if([num length]>6){
    if([num hasPrefix:@"0"]){
        num = [@"9" stringByAppendingFormat:@"%@",num];
    }
    else{
        num = [@"90" stringByAppendingFormat:@"%@",num];
        
    }
    }
    
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    NSLog(@"dic %@",dic);
    
    NSString *userKey = [NSString stringWithFormat:@"*%@",dic[@"uid"]];
    NSString *userName = dic[@"name"];
    NSString *peerPhone = [SharedFunctions getPureNumbers:num];
    NSString *userPhone = @"";
   NSString *comphone = [SharedAppDelegate.root searchContactDictionary:dic[@"uid"]][@"newfield4"];
    if([num hasPrefix:@"*"]){
        userPhone = userKey;
    }
    else{
//        userPhone = comphone;//[comphone substringWithRange:NSMakeRange([comphone length]-4, 4)];
//        //        userPhone = [[[SharedAppDelegate readPlist:@"email"]componentsSeparatedByString:@"@"]objectAtIndex:0];
        
        userPhone = (comphone != nil && [comphone length]>0)?comphone:dic[@"cellphone"];
    }
//    
//    if(viewTag == kNumber){
//        userPhone = peerPhone;
//    }
    
    NSString *userPassword = [NSString stringWithFormat:@"min%@jun",userPhone];
    
    if([[SharedAppDelegate readPlist:@"echoswitch"]isEqualToString:@"1"])
    {
        [VoIPSingleton sharedVoIP].strEcho = @"1";
    }
    else
    {
        [VoIPSingleton sharedVoIP].strEcho = @"0";
    }
    
    [VoIPSingleton sharedVoIP].bSendCall = YES;
    [VoIPSingleton sharedVoIP].szServerIP = [SharedAppDelegate readPlist:@"voip"];
    [VoIPSingleton sharedVoIP].nServerPort = [NSNumber numberWithUnsignedInt:62234];
    [VoIPSingleton sharedVoIP].szServerDomain = [SharedAppDelegate readPlist:@"sip"];
    [VoIPSingleton sharedVoIP].szUserKey = userKey;
    [VoIPSingleton sharedVoIP].szUserName = userName;
    [VoIPSingleton sharedVoIP].szPeerPhone = peerPhone;
    [VoIPSingleton sharedVoIP].szUserPhone = userPhone;
    [VoIPSingleton sharedVoIP].szUserPwd = userPassword;
    
    [cancel setEnabled:YES];
    
    [VoIPSingleton sharedVoIP].call_target = self;

    
    
    
    if (_timerOutgoing == nil)
    {
        _timerOutgoing = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(outgoingTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    outgoingTime = 0;
    
    NSLog(@"IP:%@ domain:%@ key:%@ name:%@ peerphone:%@ userphone:%@",[SharedAppDelegate readPlist:@"voip"],[SharedAppDelegate readPlist:@"sip"],userKey,userName,peerPhone,userPhone);
    if ([[VoIPSingleton sharedVoIP] callStatus] == CALL_WAIT)
    {
        NSLog(@"CALL_WAIT");
        if ([[VoIPSingleton sharedVoIP] callStart:DCODEC_ALAW] == NO)
        {
            NSLog(@"DCODEC_ALAW NOT");
            return;
        }
    }
    
}

- (void)mvoipIncomingWith:(NSDictionary *)dic
{
    
    if(incomingDic){
        incomingDic = nil;
    }
    incomingDic = [[NSDictionary alloc]initWithDictionary:dic];
    
    NSLog(@"======== mvoipIncomingWith %@",dic);
    //    [SharedAppDelegate.root playRingSound];
//    [SharedAppDelegate.root stopRingSound];
    //    [SharedAppDelegate.root setAudioRoute:NO];
    
    NSArray *array = [dic[@"info"] componentsSeparatedByString:@":"];
    if([array count]<3){
        [self alreadyHangup];
        return;
    }
    
    if([dic[@"fromstatus"] isEqualToString:@"0"]){
        [self alreadyHangup];
        return;
    }
    
    //    sip_ring_start();
    //    [SharedAppDelegate.root setAudioRoute:YES];
    
    if ([[VoIPSingleton sharedVoIP] callQuerySuccessCall]) {
        return;
    }
    
    
    
//    if(!fullIncomingView){
    
//    }
//    else{
//        //        sip_ring_init();
//        [SharedAppDelegate.root playRingSound];
//        
//    }
    
    //    [SharedAppDelegate.root stopRingSound];
    
    
    //    [SharedAppDelegate.root playRingSound];
    NSDictionary *myDic = [SharedAppDelegate readPlist:@"myinfo"];
    NSString *userKey = [NSString stringWithFormat:@"*%@",myDic[@"uid"]];
    NSString *password = [NSString stringWithFormat:@"min%@jun",userKey];
    
    
    if([[SharedAppDelegate readPlist:@"echoswitch"]isEqualToString:@"1"])
    {
        [VoIPSingleton sharedVoIP].strEcho = @"1";
    }
    else
    {
        [VoIPSingleton sharedVoIP].strEcho = @"0";
    }
    [VoIPSingleton sharedVoIP].bSendCall = NO;
    [VoIPSingleton sharedVoIP].szServerIP = array[0];//[dicobjectForKey:@"server"];
    [VoIPSingleton sharedVoIP].nServerPort = [NSNumber numberWithUnsignedInt:[array[1] intValue]];
    [VoIPSingleton sharedVoIP].szServerDomain = array[2];
    [VoIPSingleton sharedVoIP].szUserKey = userKey;
    [VoIPSingleton sharedVoIP].szUserPhone = userKey;
    [VoIPSingleton sharedVoIP].szUserPwd = password;
    [VoIPSingleton sharedVoIP].szPeerPhone = savedNum;
    
    
    [VoIPSingleton sharedVoIP].call_target = self;
    //	[answer setEnabled:YES];
    
//    [cancel setEnabled:YES];
   
    //    [SharedAppDelegate.root playRingSound];
    NSLog(@"[[VoIPSingleton sharedVoIP] callStatus] %d",(int)[[VoIPSingleton sharedVoIP] callStatus]);
    
    if ([[VoIPSingleton sharedVoIP] callStatus] == CALL_WAIT)
    {
        NSLog(@"CALL_WAIT");
        
//        NSString *fmcName = [SharedAppDelegate.root searchAppNo:dic[@"cid"]][@"name"];
//        self.fromName =  [fmcName length]>0?fmcName:@"";
//        
//        if([self.fromName length]<1){
//            self.fromName = [SharedAppDelegate.root searchDicWithNumber:dic[@"cid"]][@"name"];
//        }
//        
//        if([self.fromName length]<1){
//            self.fromName = [dic[@"cname"]length]>0?dic[@"cname"]:@"";
//        }
//        if([self.fromName length]<1){
//            self.fromName = [dic[@"cid"]length]>0?dic[@"cid"]:@"";
//        }
//        self.toName = @"";
//        self.savedNum = [dic[@"cid"]length]>0?dic[@"cid"]:@"";
        
        if ([[VoIPSingleton sharedVoIP] callStart:DCODEC_ALAW] == NO)
        {
            NSLog(@"DCODEC_ALAW");
            return;
        }
        
    }
    else if([[VoIPSingleton sharedVoIP]callStatus] == CALL_HANGUP){
        
        [[VoIPSingleton sharedVoIP] callHangup:0];
        [self closeAllCallView];
    }
    else{
        //		[SharedAppDelegate.root setAudioRoute:NO];
        //		[[VoIPSingleton sharedVoIP] callSpeaker:NO];
        
    }
    
}


- (void)eventStatus:(NSInteger)status_type status_Code:(NSInteger)status_code
{
    NSLog(@"from %@ to  saved ",self.fromName);
    NSLog(@"from  to  saved %@",self.savedNum);
    NSLog(@"from to %@ saved ",self.toName);
    if (status_type == DEVENT_DIALING)
    {
        // do nothing
        NSLog(@"DEVENT_DIALING\n");
        [self playDialingSound];
    }
    else if (status_type == DEVENT_RINGING)
    {
        //TODO play Ringback Tone....
        NSLog(@"DEVENT_RINGING\n");
        [answer setEnabled:YES];
        alertLabel.hidden = YES;
//        [SharedAppDelegate.window addSubview:[self setFullIncoming:incomingDic active:NO]];
    }
    else if (status_type == DEVENT_CALL)
    {
        // do nothing
        NSLog(@"DEVENT_CALL\n");
        [self stopDialingSound];
        [SharedAppDelegate.window addSubview:[self setFullCalling]];
        //		[self showCalling];
        
    }
    else if (status_type == DEVENT_HOLD)
    {
        // do nothing
        NSLog(@"DEVENT_HOLD\n");
    }
    else if (status_type == DEVENT_HANGUP)
    {
        
     
        NSLog(@"DEVENT_HANGUP %d\n",status_code);
       
        NSLog(@"outgoingTime %d",(int)outgoingTime);
      
        
        
        [self stopDialingSound];
        [self closeAllCallView];
        NSDate *now = [[NSDate alloc] init];
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *linuxString = [NSString stringWithFormat:@"%.0f",[now timeIntervalSince1970]];
        //        [formatter setDateFormat:@"M월 d일 a h시 mm분"];
        //        NSString *strTestTime = [[NSString alloc] initWithString:[formatter stringFromDate:now]];
//        [now release];
        //        [formatter release];
        
        //		[[VoIPSingleton sharedVoIP] callSpeaker:NO];
        
        NSLog(@"time %@",time);
        
        NSString *talkingTime = @"";
        
        if(time != nil && [time.text length]>0){
            NSLog(@"time not nil, time.text %@",time.text);
            talkingTime = time.text;
            
//            [time release];
            time = nil;
        }
        else//       if(time == nil || [time.text isEqualToString:@""] || [time.text isEqualToString:@"(null)"])
        {
            if([self.fromName isEqualToString:@""])
                talkingTime = @"발신 취소";
            
            else if([self.toName isEqualToString:@""])
                talkingTime = @"부재중 전화";
            
        }
        
        NSLog(@"talking time %@",talkingTime);
        NSLog(@"from %@ to %@ saved %@",self.fromName,self.toName,self.savedNum);
        
        [SQLiteDBManager AddListWithTalkdate:linuxString FromName:self.fromName ToName:self.toName Talktime:talkingTime Num:self.savedNum];
        [SharedAppDelegate.root.callList refreshContents];
        
//                [strTestTime release];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        
        
        
        [[VoIPSingleton sharedVoIP] callDestroy];
        
        NSLog(@"fromName %@ toName %@",self.fromName,self.toName);
        
        
        if(status_code == DHANGUP_NOANSWER){
            [self getCancelInfo];
            return;
        }
        
        
        NSString *szByte = @"";//[[NSString alloc]init];
        
        if(status_code == DHANGUP_BUSY)
            szByte = [NSString stringWithFormat:@"상대방이 통화중입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_NOANSWER)
            szByte = [NSString stringWithFormat:@"상대방이 전화를 받지않습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_REJECT && [self.fromName isEqualToString:@""])
            szByte = [NSString stringWithFormat:@"상대방이 전화를 받을 수 없는 상황입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_CANCEL && [self.toName isEqualToString:@""])
            szByte = [NSString stringWithFormat:@"상대방이 발신을 취소하였습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_FAILURE)
            szByte = [NSString stringWithFormat:@"전화를 연결할 수 없습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_RTPTIMEOUT)
            szByte = [NSString stringWithFormat:@"네트워크 불안정으로 통화가 종료되었습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_TORTPTIMEOUT)
            szByte = [NSString stringWithFormat:@"상대방 네트워크 불안정으로 통화가 종료되었습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_CONGESTION)
            szByte = [NSString stringWithFormat:@"통화량이 많아 서비스가 제공되지 않습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_NOPERMIT)
            szByte = [NSString stringWithFormat:@"해당 번호로 전화를 걸 권한이 없습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_INCOMINGTIMEOUT)
            szByte = [NSString stringWithFormat:@"수신대기 시간을 초과하였습니다. (%d)",(int)status_code];
        else if(status_code > 29 && status_code < 40)
            szByte = [NSString stringWithFormat:@"mVoIP 서버에 연결할 수 없습니다. (%d)",(int)status_code];
        else if(status_code == 43)
            szByte = [NSString stringWithFormat:@"mVoIP 연동이 되어 있지 않습니다. (%d)",(int)status_code];
        else if(status_code > 39 && status_code < 50)
            szByte = [NSString stringWithFormat:@"mVoIP 계정에 문제가 있어 발신이 제한됐습니다. (%d)",(int)status_code];
        else if(status_code > 49 && status_code < 70 && status_code != 56 && status_code != 57)
            szByte = [NSString stringWithFormat:@"mVoIP 관리서버 연결에 문제가 있습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_WASCALEEBUSY)
            szByte = [NSString stringWithFormat:@"상대방이 통화중입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_WASNOCALLER)
            szByte = [NSString stringWithFormat:@"발신자가 전화를 끊은 상태입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_TO3GCALL){
            szByte = [NSString stringWithFormat:@"상대방에게 3G 전화가 와서 통화가 종료되었습니다. (%d)",(int)status_code];
            
        }
        else if(status_code == DHANGUP_3GCALL){
            szByte = [NSString stringWithFormat:@"3G 전화가 와서 통화가 종료되었습니다. (%d)",(int)status_code];
            
        }
        else if(status_code == DHANGUP_MPDND)
            szByte = [NSString stringWithFormat:@"상대방이 수신거부를 설정해놓았습니다. (%d)",(int)status_code];
        
        NSLog(@"status_code %d",(int)status_code);
        NSLog(@"szByte %@",szByte);
        
        if(szByte != nil && [szByte length]>0)
        {
            [CustomUIKit popupAlertViewOK:nil msg:szByte];
        }
    } else {
        [self stopDialingSound];
    }
}



- (void)getCancelInfo{// bell:(NSString *)bell{//setDeviceInfo:(NSString *)bell{
    
    
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mirae.lemp.co.kr/"]];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [SharedAppDelegate readPlist:@"myinfo"][@"uid"],@"uid",
                           [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"],@"sessionkey",
                           nil];
    
    NSLog(@"parameter %@",param);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/voipstate.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        
        if ([isSuccess isEqualToString:@"0"]) {
            
            NSString *state = resultDic[@"state"];
            NSString *szByte = @"";
            if([state isEqualToString:@"NOTREG"]){
                szByte = @"상대방이 전화를 받을 수 없는 환경입니다.\n잠시 후 다시 걸어 주시기 바랍니다.";
            }
            else if([state isEqualToString:@"RINGING"]){
                szByte = @"상대방이 전화를 받지않습니다.";
                
                               }
            else if([state isEqualToString:@"REJECT"]){
                szByte = @"상대방이 수신을 거절하였습니다.\n잠시 후 다시 걸어 주시기 바랍니다.";
                
                               }
            
            if(szByte != nil && [szByte length]>0)
            [CustomUIKit popupAlertViewOK:nil msg:szByte];
                               
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
#pragma mark - outgoing UI
//
//- (UIView *)setSideOutgoing:(NSDictionary *)dic{
//
//    if(outgoingView)
//        return nil;
//
//    fromName = @"";
//    toName = [[NSString alloc]initWithFormat:@"%@",[dicobjectForKey:@"name"]];
//    savedNum = [[NSString alloc]initWithFormat:@"*%@",[dicobjectForKey:@"uniqueid"]];
//    talkingTime = @"";
//
//    outgoingView = [[UIImageView alloc]initWithFrame:CGRectMake(0-320, 20+44, 320, 173)];
//    outgoingView.image = [CustomUIKit customImageNamed:@"n06_rcal_bg.png"];
//    outgoingView.userInteractionEnabled = YES;
//
//    UIImageView *phone = [[UIImageView alloc]initWithFrame:CGRectMake(90, 20, 22, 28)];
//    phone.image = [CustomUIKit customImageNamed:@"n06_cic.png"];
//    [outgoingView addSubview:phone];
//    [phone release];
//
//    UIImageView *profile = [[UIImageView alloc]init];
//    profile.image = [CustomUIKit customImageNamed:@"n01_tl_profile.png"];
//    profile.frame = CGRectMake(20, 20, 47, 47);
//    [outgoingView addSubview:profile];
//    [profile release];
//
//
//    NSString *nameAndPosition = [[dicobjectForKey:@"name"] stringByAppendingFormat:@" %@",[dicobjectForKey:@"grade2"]];
//    NSLog(@"nameAndPostiion %@",nameAndPosition);
//    UILabel *name = [CustomUIKit labelWithText:nameAndPosition fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(15, 75, 300, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [outgoingView addSubview:name];
////    [name release];
//
//    UILabel *label = [CustomUIKit labelWithText:@"전화거는중..." fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(116, 20, 100, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [outgoingView addSubview:label];
////    [label release];
//
//
//    UIButton *cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelSideOutgoing) frame:CGRectMake(12, 160-10-46, 296, 46) imageNamedBullet:nil imageNamedNormal:@"n06_cancelbtn.png" imageNamedPressed:nil];
//    [outgoingView addSubview:cancel];
////    [cancel release];
//
////    [self mvoipOutgoingWith:[NSString stringWithFormat:@"*%@",[dicobjectForKey:@"uniqueid"]]];
//
//    return outgoingView;
//}
//
//
//- (void)cancelSideOutgoing{
//
//    if(outgoingView == nil)
//        return;
//
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         outgoingView.frame = CGRectMake(0-320, 20+44, 320, 173);// its final location
//                     }];
//    [outgoingView release];
//    outgoingView = nil;
//}


- (void)alreadyHangup{
    //	[SharedAppDelegate.root setAudioRoute:NO];
    [CustomUIKit popupAlertViewOK:nil msg:@"이미 종료된 전화입니다."];
    [self closeAllCallView];
}

- (void)checkPush{
    if(callingByPush){ // push받고 들어왔는데 startup에서 확인하니까 이미 끊어짐
        [self alreadyHangup];
    }
}

- (void)isCallingByPush:(BOOL)yn{
    callingByPush = yn;
}



- (UIView *)setFullOutgoingWithDic:(NSDictionary *)dic
{
    NSLog(@"out %@\nincome%@\ncall %@",fullOutgoingView,fullIncomingView,fullCallingView);
    
    if(fullOutgoingView)
        return nil;
    
    if(fullIncomingView)
        return nil;
    
    
    if(fullCallingView)
        return nil;
    
    
    
    NSLog(@"setFullOutgoingWithDic  %@",dic);
    NSString *num = dic[@"cellphone"];
    NSString *uid = dic[@"uid"];
    NSString *name = dic[@"name"];
    NSString *position = dic[@"position"];
    NSString *profileimage = dic[@"profileimage"];
    
    if([num length]<1 && [uid length]<1)
        return nil;
    
    
    
//    bIncoming = NO;
    
    
    self.toName = name;
    if([self.toName length]<1){
    NSString *fmcName = [SharedAppDelegate.root searchAppNo:num][@"name"];
    self.toName =  [fmcName length]>0?fmcName:@"";
    }
    if([self.toName length]<1){
        self.toName = [SharedAppDelegate.root searchDicWithNumber:num][@"name"];
    }
    if([self.toName length]<1){
        self.toName = num;
    }
    
    
    
    if([num hasPrefix:@"0"])
        num = [SharedAppDelegate.root dashCheck:num];
    else if([num hasPrefix:@"9"])
        num = [num substringWithRange:NSMakeRange(1,[num length]-1)];
        
    self.fromName = @"";
    self.savedNum = num;
    
    
    
//    if([uid length]>0){
//        uid = [NSString stringWithFormat:@"*%@",uid];
////        dic = // dic 구해오기
//    }
//    else {
        uid = num;
//    }
    
    
    NSLog(@"from %@ to %@ saved %@",self.fromName,self.toName,self.savedNum);
  
    
    
    float height = 0;
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
    
    fullOutgoingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, height)];
    fullOutgoingView.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    [coverImageView setClipsToBounds:YES];
    UIImage *defaultImage = [CustomUIKit customImageNamed:@"imageview_call_cover.png"];
    
    
    [coverImageView setImage:defaultImage];
    
    
    [fullOutgoingView addSubview:coverImageView];

    
    if(IS_HEIGHT568)
        coverImageView.frame = CGRectMake(0, 0, 320, 389);
    
    
    
    
    
    
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_cover_dark.png" withFrame:coverImageView.frame];
    [fullOutgoingView addSubview:imageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, 320, 25)];
    [fullOutgoingView addSubview:imageView];
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"무료통화" fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 320, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullOutgoingView addSubview:label];
    
    int gap = 0;
    
    if(IS_HEIGHT568)
        gap = 30;
    
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(95,coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - 130 - gap, 130, 130)];
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"imageview_outgoing_defaultprofile.png" view:profileView scale:0];
    [fullOutgoingView addSubview:profileView];
    //    [profileView release];
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    profileView.clipsToBounds = YES;
    
    //    UIImageView *coverView;
    //    coverView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_profile_rounding.png" withFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
    //    [profileView addSubview:coverView];
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"" withFrame:CGRectMake(0, coverImageView.frame.size.height, 320, fullOutgoingView.frame.size.height - coverImageView.frame.size.height)];
    imageView.backgroundColor = RGB(251,251,251);
    [fullOutgoingView addSubview:imageView];
   
    
    if(IS_HEIGHT568)
        gap = 15;
    
    UILabel *toLabel;
    toLabel = [CustomUIKit labelWithText:[SharedAppDelegate.root dashCheck:toName] fontSize:25 fontColor:[UIColor whiteColor] frame:CGRectMake(0, profileView.frame.origin.y - 60 - gap, 320, 28) numberOfLines:1 alignText:NSTextAlignmentCenter];
    toLabel.font = [UIFont boldSystemFontOfSize:25];
    [fullOutgoingView addSubview:toLabel];
    
    
    UILabel *positionLabel;
    positionLabel = [CustomUIKit labelWithText:position fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, toLabel.frame.origin.y + toLabel.frame.size.height + 5, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    if(dic[@"grade2"] == nil && dic[@"team"] == nil)
//        positionLabel.text = @"";
    NSLog(@"dic %@ %@",dic[@"grade2"],dic[@"team"]);
    NSLog(@"positionlabel.text %@",positionLabel.text);
    
    [fullOutgoingView addSubview:positionLabel];
    
    
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullOutgoing) frame:CGRectMake(18, height-20-44-20, 284, 44) imageNamedBullet:nil imageNamedNormal:@"button_call_hangup.png" imageNamedPressed:nil];
    [fullOutgoingView addSubview:cancel];
    [cancel setEnabled:NO];
    //    [cancel release];
    
    label = [CustomUIKit labelWithText:@"발신전화" fontSize:23 fontColor:RGB(41, 197, 185) frame:CGRectMake(0, cancel.frame.origin.y - 50, 320, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:23];
    [fullOutgoingView addSubview:label];
    
    [self mvoipOutgoingWith:uid];
    
    
    return fullOutgoingView;
}




- (UIView *)setReDialing:(NSDictionary *)dic uid:(NSString *)uid{
    
    NSLog(@"setReDialing dic %@",dic);
    
    
    if(fullOutgoingView)
        return nil;
    
    if (dic == nil) {
        return nil;
    }
    
//    bIncoming = NO;
    
    
    NSLog(@"dic %@",dic);
    
    NSString *number = @"";
    
    
    number = dic[@"num"];
    
    if (number == nil || [number length]<1) {
        return nil;
    }
    
    
    
    self.fromName = @"";//[[NSString alloc]init];
    self.toName = [dic[@"toname"]length]>0?dic[@"toname"]:dic[@"fromname"];//[[NSString alloc]initWithFormat:@"%@",[dic[@"toname"]length]>0?dic[@"toname"]:dic[@"fromname"]];
    self.savedNum = dic[@"num"];//[[NSString alloc]initWithFormat:@"%@",dic[@"num"]];
    
    if([toName length]<1 || toName == nil){
        toName = savedNum;
        
    }
    
    float height = 0;
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
    fullOutgoingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, height)];
    fullOutgoingView.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    [coverImageView setClipsToBounds:YES];
    UIImage *defaultImage = [CustomUIKit customImageNamed:@"imageview_call_cover.png"];
    
    
    [coverImageView setImage:defaultImage];
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return nil;
    NSString *urlString = [NSString stringWithFormat:@"https://%@/file/%@/timelineimage_%@_.jpg",[SharedAppDelegate readPlist:@"was"],uid,uid];
    NSLog(@"urlString %@",urlString);
    NSURL *imgURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:imgURL];
    NSHTTPURLResponse* response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSInteger statusCode = [response statusCode];
    NSLog(@"statusCode %d",(int)statusCode);
    if(statusCode == 404){
    }
    else{
        UIImage *image = [UIImage imageWithData:responseData];
        [coverImageView setImage:image];
    }
    
    [fullOutgoingView addSubview:coverImageView];
    //    [imageView release];
    if(IS_HEIGHT568)
        coverImageView.frame = CGRectMake(0, 0, 320, 389);
    
    
    NSDictionary *contactDic = nil;// [SharedAppDelegate.root searchContactDictionary:uid];
    
    NSLog(@"contactDic %@",contactDic);
    
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_cover_dark.png" withFrame:coverImageView.frame];
    [fullOutgoingView addSubview:imageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, 320, 25)];
    [fullOutgoingView addSubview:imageView];
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"무료통화" fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 320, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullOutgoingView addSubview:label];
    
    int gap = 0;
    
    if(IS_HEIGHT568)
        gap = 30;
    
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(95,coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - 130 - gap, 130, 130)];
    [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"call_nophoto.png" view:profileView scale:0];
    [fullOutgoingView addSubview:profileView];
//    [profileView release];
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    profileView.clipsToBounds = YES;
    
    //    UIImageView *coverView;
    //    coverView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_profile_rounding.png" withFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
    //    [profileView addSubview:coverView];
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"" withFrame:CGRectMake(0, coverImageView.frame.size.height, 320, fullOutgoingView.frame.size.height - coverImageView.frame.size.height)];
    imageView.backgroundColor = RGB(251,251,251);
    [fullOutgoingView addSubview:imageView];
    
    if(IS_HEIGHT568)
        gap = 20;
    
    UIButton *speaker;
    speaker = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(speakerOnOff:) frame:CGRectMake(122, coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - gap, 75, 75) imageNamedBullet:nil imageNamedNormal:@"button_call_speaker_on.png" imageNamedPressed:nil];
    [fullOutgoingView addSubview:speaker];
    
    if(IS_HEIGHT568)
        gap = 15;
    
    UILabel *toLabel;
    toLabel = [CustomUIKit labelWithText:toName fontSize:25 fontColor:[UIColor whiteColor] frame:CGRectMake(0, profileView.frame.origin.y - 60 - gap, 320, 28) numberOfLines:1 alignText:NSTextAlignmentCenter];
    toLabel.font = [UIFont boldSystemFontOfSize:25];
    [fullOutgoingView addSubview:toLabel];
    
    UILabel *positionLabel;
    positionLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@ | %@",contactDic[@"grade2"]==nil?@"":contactDic[@"grade2"],contactDic[@"team"]==nil?@"":contactDic[@"team"]] fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, toLabel.frame.origin.y + toLabel.frame.size.height + 5, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullOutgoingView addSubview:positionLabel];
    if(contactDic[@"grade2"] == nil && contactDic[@"team"] == nil)
        positionLabel.text = @"";
    
    
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullOutgoing) frame:CGRectMake(18, height-20-44-20, 284, 44) imageNamedBullet:nil imageNamedNormal:@"button_call_hangup.png" imageNamedPressed:nil];
    [fullOutgoingView addSubview:cancel];
    [cancel setEnabled:NO];
//    [cancel release];
    
    label = [CustomUIKit labelWithText:@"발신전화" fontSize:23 fontColor:RGB(41, 197, 185) frame:CGRectMake(0, cancel.frame.origin.y - 50, 320, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:23];
    [fullOutgoingView addSubview:label];
    
    
    [self mvoipOutgoingWith:number];
    
    return fullOutgoingView;
}

- (void)cancelFullOutgoing{
    NSLog(@"cancelFullOutgoing");
    
    fullOutgoingView.hidden = YES;
    
    [[VoIPSingleton sharedVoIP]callHangup:DHANGUP_CANCEL];
    
    [self closeAllCallView];
    
    //    if(fullOutgoingView == nil)
    //        return;
    //
    //    [fullOutgoingView removeFromSuperview];
    //    [fullOutgoingView release];
    //    fullOutgoingView = nil;
    
    if (_timerOutgoing)
    {
        [_timerOutgoing invalidate];
        _timerOutgoing = nil;
    }
    
}


#pragma mark - incoming UI
//- (UIView *)setSideIncoming:(NSDictionary *)dic{
//
//    if(incomingView)
//        return nil;
//
//    fromName = [[NSString alloc]initWithFormat:@"%@",[dicobjectForKey:@"name"]];
//    toName = @"";
//    savedNum = [[NSString alloc]initWithFormat:@"*%@",[dicobjectForKey:@"uniqueid"]];
//    talkingTime = @"";
//
//    incomingView = [[UIImageView alloc]initWithFrame:CGRectMake(0-320, 20+44, 320, 173)];
//    incomingView.image = [CustomUIKit customImageNamed:@"n06_rcal_bg.png"];
//    incomingView.userInteractionEnabled = YES;
//
//    UIImageView *phone = [[UIImageView alloc]initWithFrame:CGRectMake(90, 20, 22, 28)];
//    phone.image = [CustomUIKit customImageNamed:@"n06_cic.png"];
//    [incomingView addSubview:phone];
//    [phone release];
//
//    UIImageView *profile = [[UIImageView alloc]init];
//    profile.image = [CustomUIKit customImageNamed:@"n01_tl_profile.png"];
//    profile.frame = CGRectMake(20, 20, 47, 47);
//    [incomingView addSubview:profile];
//    [profile release];
//
//
//    NSString *nameAndPosition = [[dicobjectForKey:@"name"] stringByAppendingFormat:@" %@",[dicobjectForKey:@"grade2"]];
//    NSLog(@"nameAndPostiion %@",nameAndPosition);
//    UILabel *name = [CustomUIKit labelWithText:nameAndPosition fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(15, 75, 300, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [incomingView addSubview:name];
////    [name release];
//
//    UILabel *label = [CustomUIKit labelWithText:@"전화가 왔습니다." fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(116, 20, 180, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [incomingView addSubview:label];
////    [label release];
//
//
//    UIButton *cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelSideIncoming) frame:CGRectMake(10, 160-10-46, 145, 46) imageNamedBullet:nil imageNamedNormal:@"n06_nocal_bt.png" imageNamedPressed:nil];
//    [incomingView addSubview:cancel];
////    [cancel release];
//
//    UIButton *answer = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(answerSideIncoming) frame:CGRectMake(10+145+10, 160-10-46, 145, 46) imageNamedBullet:nil imageNamedNormal:@"n06_yscal_bt.png" imageNamedPressed:nil];
//    [incomingView addSubview:answer];
////    [answer release];
//
//
//    return incomingView;
//}
//
//
//- (void)cancelSideIncoming{
//
//    if(incomingView == nil)
//        return;
//
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         incomingView.frame = CGRectMake(0-320, 20+44, 320, 173);// its final location
//                     }];
//    [incomingView release];
//    incomingView = nil;
//}
//- (void)answerSideIncoming{
//
//}

- (UIView *)setFullIncoming:(NSDictionary *)dic call:(BOOL)call push:(BOOL)push active:(BOOL)active{
    
    NSLog(@"\nout %@\nincome%@\ncall %@",fullOutgoingView,fullIncomingView,fullCallingView);
    NSLog(@"\ncall %@\npush%@\nactive %@",call?@"oo":@"xx",push?@"oo":@"xx",active?@"oo":@"xx");
    
    if(call){
        // 일반전화중일 때
        
        return nil;
    }
    
    if(fullIncomingView){
        [self mvoipIncomingWith:dic];
        return nil;
    }
    
    
    if(fullCallingView)
        return nil;
    
    
    if(fullOutgoingView)
        return nil;
    
    
    NSString *fmcName = [SharedAppDelegate.root searchAppNo:dic[@"cid"]][@"name"];
    self.fromName =  [fmcName length]>0?fmcName:@"";
    
    if([self.fromName length]<1){
        self.fromName = [SharedAppDelegate.root searchDicWithNumber:dic[@"cid"]][@"name"];
    }
    
    if([self.fromName length]<1){
        self.fromName = [dic[@"cname"]length]>0?dic[@"cname"]:@"";
    }
    if([self.fromName length]<1){
        self.fromName = [dic[@"cid"]length]>0?dic[@"cid"]:@"";
    }
    self.toName = @"";
    self.savedNum = [dic[@"cid"]length]>0?dic[@"cid"]:@"";
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [SharedAppDelegate.root playRingSound];
//    bIncoming = YES;
    
    //    talkingTime = @"";
    
    NSString *uid = @"";
    
    
    
    NSLog(@"from %@ to %@ saved %@",self.fromName,self.toName,self.savedNum);

    if([self.savedNum hasPrefix:@"*"]){
        uid = [self.savedNum substringWithRange:NSMakeRange(1,[self.savedNum length]-1)];
        
    }
    else{
        uid = savedNum;
    }
    
    float height = 0;
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
    fullIncomingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, height)];
    fullIncomingView.userInteractionEnabled = YES;
    
    coverImageViewIncoming = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    [coverImageViewIncoming setContentMode:UIViewContentModeScaleAspectFill];
    [coverImageViewIncoming setClipsToBounds:YES];
    UIImage *defaultImage = [CustomUIKit customImageNamed:@"imageview_call_cover.png"];
    
    
    [coverImageViewIncoming setImage:defaultImage];
    
    
       [fullIncomingView addSubview:coverImageViewIncoming];
    //    [imageView release];
    if(IS_HEIGHT568)
        coverImageViewIncoming.frame = CGRectMake(0, 0, 320, 389);
    
    
    
    
    
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_cover_dark.png" withFrame:coverImageViewIncoming.frame];
    [fullIncomingView addSubview:imageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, 320, 25)];
    [fullIncomingView addSubview:imageView];
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"무료통화" fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 320, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullIncomingView addSubview:label];
    
    
    
    
    int gap = 0;
    
    if(IS_HEIGHT568)
        gap = 30;
    
    
    
    
    
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(95,coverImageViewIncoming.frame.origin.y + coverImageViewIncoming.frame.size.height - 75 - 130 - gap, 130, 130)];
    NSLog(@"profileview %@",NSStringFromCGRect(profileView.frame));
    profileView.image = [UIImage imageNamed:@"imageview_outgoing_defaultprofile.png"];
    [fullIncomingView addSubview:profileView];
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    profileView.clipsToBounds = YES;
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"" withFrame:CGRectMake(0, coverImageViewIncoming.frame.size.height, 320, fullIncomingView.frame.size.height - coverImageViewIncoming.frame.size.height)];
    imageView.backgroundColor = RGB(251,251,251);
    [fullIncomingView addSubview:imageView];
    
    
    alertLabel = [CustomUIKit labelWithText:@"통화 연결 대기중입니다. 잠시만 기다려주십시오." fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, imageView.frame.origin.y - 25, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullIncomingView addSubview:alertLabel];
    
    
    if(IS_HEIGHT568)
        gap = 15;
    
    UILabel *fromLabel;
    fromLabel = [CustomUIKit labelWithText:[SharedAppDelegate.root dashCheck:self.fromName] fontSize:25 fontColor:[UIColor whiteColor] frame:CGRectMake(0, profileView.frame.origin.y - 60 - gap, 320, 28) numberOfLines:1 alignText:NSTextAlignmentCenter];
    fromLabel.font = [UIFont boldSystemFontOfSize:25];
    [fullIncomingView addSubview:fromLabel];
    
    UILabel *positionLabel = [CustomUIKit labelWithText:@"" fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, fromLabel.frame.origin.y + fromLabel.frame.size.height + 5, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullIncomingView addSubview:positionLabel];
    
    
    
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullIncoming) frame:CGRectMake(27, height-20-44-20, 124, 43) imageNamedBullet:nil imageNamedNormal:@"button_call_deny.png" imageNamedPressed:nil];
    [fullIncomingView addSubview:cancel];
    [cancel setEnabled:YES];
    //    [cancel release];
    
    
    answer = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(answerFullIncoming) frame:CGRectMake(cancel.frame.origin.x + cancel.frame.size.width + 15,  cancel.frame.origin.y, cancel.frame.size.width, cancel.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"button_call_answer.png" imageNamedPressed:nil];
    [fullIncomingView addSubview:answer];
    [answer setEnabled:NO];
    //    [answer release];
    
    label = [CustomUIKit labelWithText:@"수신전화" fontSize:23 fontColor:RGB(41, 197, 185) frame:CGRectMake(0, cancel.frame.origin.y - 50, 320, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:23];
    [fullIncomingView addSubview:label];
    
    //    NSString *bell = [NSString stringWithFormat:@"%@",[SharedAppDelegate readPlist:@"bell"]];
    //    if([bell hasSuffix:@"wav"])
    //        bell = [bell componentsSeparatedByString:@"."][0];
    //    NSLog(@"bell %@",bell);
    //    NSLog(@"callingbypush %@",callingByPush?@"YES":@"NO");
    
    //    sip_ring_init();//bell);
    //    sip_ring_start();
    //    [SharedAppDelegate.root setAudioRoute:YES];
    
//    if(active){
//        
//        bIncoming = NO;
//        [SharedAppDelegate.root startup];
//    }
    
    if(active){
        [SharedAppDelegate.root startup];
        
    }
    else{
        [self mvoipIncomingWith:dic];
    }
    return fullIncomingView;
}





- (void)cancelFullIncoming{
    NSLog(@"cancelFullIncoming");
    
    //    sip_ring_stop();
    //    sip_ring_deinit();
    //	[SharedAppDelegate.root setAudioRoute:NO];
    fullIncomingView.hidden = YES;
    
    [[VoIPSingleton sharedVoIP]callHangup:DHANGUP_REJECT];
    //    [[VoIPSingleton sharedVoIP] callSpeaker:NO];
    
    [self closeAllCallView];
    //    if(fullIncomingView == nil)
    //        return;
    //
    //    [fullIncomingView removeFromSuperview];
    //    [fullIncomingView release];
    //    fullIncomingView = nil;
    
    
}
- (void)answerFullIncoming{
    NSLog(@"answerFullIncoming");
    
    //    sip_ring_stop();
    //    sip_ring_deinit();
    //    [SharedAppDelegate.root setAudioRoute:NO];
    
    //    [SharedAppDelegate.root stopRingSound];
    
    [[VoIPSingleton sharedVoIP] callAccept];
    //     [[VoIPSingleton sharedVoIP] callSpeaker:NO];
    //    [self setCalling];
    
    [SharedAppDelegate.window addSubview:[self setFullCalling]];
    
}

#pragma mark - calling UI

//- (UIView *)setSideCalling:(NSString *)from to:(NSString *)to{//:(NSDictionary *)dic{
//
//    if(callingView)
//        return nil;
//
//    fromName = [[NSString alloc]initWithFormat:@"%@",from];
//    toName = [[NSString alloc]initWithFormat:@"%@",to];
//    savedNum = @"";
//    talkingTime = @"";
//
//    callingView = [[UIImageView alloc]initWithFrame:CGRectMake(0-320, 0, 320, 173)];
//    callingView.image = [CustomUIKit customImageNamed:@"n06_rcal_bg.png"];
//    callingView.userInteractionEnabled = YES;
//
//    UIImageView *phone = [[UIImageView alloc]initWithFrame:CGRectMake(90, 20, 22, 28)];
//    phone.image = [CustomUIKit customImageNamed:@"n06_cic.png"];
//    [callingView addSubview:phone];
//    [phone release];
//
//    UIImageView *profile = [[UIImageView alloc]init];
//    profile.image = [CustomUIKit customImageNamed:@"n01_tl_profile.png"];
//    profile.frame = CGRectMake(20, 20, 47, 47);
//    [callingView addSubview:profile];
//    [profile release];
//
//
//    NSString *nameAndPosition = [[dicobjectForKey:@"name"] stringByAppendingFormat:@" %@",[dicobjectForKey:@"grade2"]];
//    NSLog(@"nameAndPostiion %@",nameAndPosition);
//    UILabel *name = [CustomUIKit labelWithText:nameAndPosition fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(15, 75, 300, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [callingView addSubview:name];
//    [name release];
//
//    UILabel *label = [CustomUIKit labelWithText:@"전화거는중..." fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(116, 20, 100, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [callingView addSubview:label];
//    [label release];
//
//
//    UIButton *cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelSideCalling) frame:CGRectMake(12, 160-10-46, 296, 46) imageNamedBullet:nil imageNamedNormal:@"n06_cancelbtn.png" imageNamedPressed:nil];
//    [callingView addSubview:cancel];
//    [cancel release];
//
////    [self mvoipOutgoingWith:[NSString stringWithFormat:@"*%@",[dicobjectForKey:@"uniqueid"]]];
//
//    return callingView;
//}
//
//
- (void)cancelSideCalling{
    //
    //    if(callingView == nil)
    //        return;
    //
    //    [UIView animateWithDuration:0.4
    //                     animations:^{
    //                         callingView.frame = CGRectMake(0-320, 0, 320, 173);// its final location
    //                     }];
    //    [callingView release];
    //    callingView = nil;
}
//
//

- (BOOL)isCalling{
    NSLog(@"fullCallingView %@",fullCallingView);
    if(fullCallingView)
        return YES;
    else
        return NO;
}


- (BOOL)isIncoming{
    NSLog(@"fullIncoming %@",fullIncomingView);
    if(fullIncomingView)
        return YES;
    else
        return NO;
}

- (void)showDial:(id)sender{
    
    if(!fullCallingView)
        return;
    
    NSLog(@"showDial");
    
    UIButton *button = (UIButton *)sender;
    
    dialView.hidden = !dialView.hidden;
    button.selected = !button.selected;
    
    if(button.selected){
        [button setBackgroundImage:[UIImage imageNamed:@"button_calling_hidedial.png"] forState:UIControlStateNormal];
        
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"button_calling_showdial.png"] forState:UIControlStateNormal];
    }
    
}

- (UIView *)setFullCalling{//:(NSDictionary *)dic{//(NSString *)num name:(NSString *)name{
    
    NSLog(@"setFullCalling %@",savedNum);
    
    if(fullCallingView)
        return nil;
    
    
    
    [SharedAppDelegate.root stopRingSound];
    
    if(fullIncomingView){
        //        sip_ring_stop();
        //        sip_ring_deinit();
        //        [SharedAppDelegate.root setAudioRoute:NO];
        [fullIncomingView removeFromSuperview];
        //        [fullIncomingView release];
        fullIncomingView = nil;
    }
    if(fullOutgoingView){
        [fullOutgoingView removeFromSuperview];
        //        [fullOutgoingView release];
        fullOutgoingView = nil;
    }
    
    NSString *uid = @"";
    
    
    
    float height = 0;
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
    
    //    talkingTime = @"";
    fullCallingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, height)];
    fullCallingView.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_01.png" withFrame:CGRectMake(0, 0, 320, 98)];
    [fullCallingView addSubview:imageView];
    //        [imageView release];
    
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 72, 72)];
        [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"imageview_calling_defaultprofile.png" view:profileView scale:24];
    [fullCallingView addSubview:profileView];
    //    [profileView release];
    
    UIImageView *coverView;
    coverView = [CustomUIKit createImageViewWithOfFiles:@"call_photocover.png" withFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
    [profileView addSubview:coverView];
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_02.png" withFrame:CGRectMake(0, 98, 320, 26)];
    [fullCallingView addSubview:imageView];
   
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 500)];
    [fullCallingView addSubview:imageView];
    //        [imageView release];
    //    }
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_04.png" withFrame:CGRectMake(0, height-85, 320, 85)];
    [fullCallingView addSubview:imageView];
  
    
    dialView = [[UIView alloc]init];
    dialView.frame = CGRectMake(0, 98+26, 320, height-(90+26)-85);
    [fullCallingView addSubview:dialView];
    dialView.hidden = YES;
    
    
    [SharedAppDelegate.root.dialer settingDialScreenWithHeight:dialView.frame.size.height dialer:NO view:dialView];
    
    [SharedAppDelegate.root.dialer settingDialerWithHeight:dialView.frame.size.height dialer:NO view:dialView];
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"" fontSize:19 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 20, 200, 22) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [fullCallingView addSubview:label];
    if([self.toName length]>0)
        label.text = self.toName;
    if([self.fromName length]>0)
        label.text = self.fromName;
    NSLog(@"label.text %@",label.text);
    //        [label release];
    
    label.text = [SharedAppDelegate.root dashCheck:label.text];
    
    time = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 48, 200, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [fullCallingView addSubview:time];
    //    [time retain];
    
    qual = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 65, 217, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [fullCallingView addSubview:qual];
    //    [qual retain];
    
//    rtpSend = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(10, 102, 217, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [fullCallingView addSubview:rtpSend];
    
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullCalling) frame:CGRectMake(27, height-20-44, 124, 43) imageNamedBullet:nil imageNamedNormal:@"button_call_deny.png" imageNamedPressed:nil];
    [fullCallingView addSubview:cancel];
    
    
    dial = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showDial:) frame:CGRectMake(cancel.frame.origin.x + cancel.frame.size.width + 15,  cancel.frame.origin.y, cancel.frame.size.width, cancel.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"button_calling_showdial.png" imageNamedPressed:nil];
    dial.selected = NO;
    dial.adjustsImageWhenHighlighted = NO;
    [fullCallingView addSubview:dial];
    
    
    
    if (_timerQual == nil)
    {
        _timerQual = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(qualTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    if (_timerCall == nil)
    {
        _timerCall = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                      target:self
                                                    selector:@selector(callTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    
    return fullCallingView;
}

//
//
- (void)speakerOnOff:(id)sender{
    [self performSelectorOnMainThread:@selector(changeImage:) withObject:sender waitUntilDone:NO];
    
    bSpeakerOn = !bSpeakerOn;
    NSLog(@"bspeakeron %@",bSpeakerOn?@"YES":@"NO");
    [[VoIPSingleton sharedVoIP] callSpeaker:bSpeakerOn];
}

- (void)speakerLargeOnOff:(id)sender{
    [self performSelectorOnMainThread:@selector(changeLargeImage:) withObject:sender waitUntilDone:NO];
    
    bSpeakerOn = !bSpeakerOn;
    NSLog(@"bspeakeron %@",bSpeakerOn?@"YES":@"NO");
    [[VoIPSingleton sharedVoIP] callSpeaker:bSpeakerOn];
}

- (void)changeLargeImage:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *btnImage;
    
    
    if(button.selected == YES)
    {
        btnImage = [NSString stringWithFormat:@"speaker_on.png"];
        button.selected = NO;
    }
    else
    {
        btnImage = [NSString stringWithFormat:@"speaker_off.png"];
        button.selected = YES;
    }
    
    
    
    [button setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
}
- (void)changeImage:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *btnImage;
    
    
    if(button.selected == YES)
    {
        btnImage = [NSString stringWithFormat:@"button_call_speaker_on.png"];
        button.selected = NO;
    }
    else
    {
        btnImage = [NSString stringWithFormat:@"button_call_speaker_off.png"];
        button.selected = YES;
    }
    
    
    
    [button setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
}

- (void)callTimer:(NSTimer*)timer
{
    
    NSString* szByte = [NSString stringWithFormat:@"%d KB",(int) (NSInteger)((float)[[VoIPSingleton sharedVoIP] callQueryNetworkByte])/1024];
    int hour = 0;
    int minute = (int)(NSInteger)[[VoIPSingleton sharedVoIP] callQueryCallTime]/60;
    int second = (int)(NSInteger)[[VoIPSingleton sharedVoIP] callQueryCallTime]%60;
    if(minute > 60)
    {
        hour = minute/60;
        minute = minute%60;
        
    }
    time.text = [NSString stringWithFormat:@"%02d:%02d:%02d / %@",hour,minute,second,szByte];
    
}

- (void)outgoingTimer:(NSTimer *)timer
{
    outgoingTime++;
}

- (void)qualTimer:(NSTimer *)timer
{
    
    
    NSString *quality;
    quality = [NSString stringWithFormat:@"%d%%",(int)(NSInteger)[[VoIPSingleton sharedVoIP] callQueryNetworkQuality]];
    qual.text = quality;
//    rtpSend.text = [[VoIPSingleton sharedVoIP] callRTPSendLength]?@"[RTP SENT]":@"";
    if([quality intValue] < 80)
        qual.text = [quality stringByAppendingString:@" 네트워크 환경이 좋지 않습니다."];
}


- (void)cancelFullCalling{
    NSLog(@"cancelFullCalling");
    
    //    if(talkingTime){
    //        [talkingTime release];
    //        talkingTime = nil;
    //    }
    //    talkingTime = [[NSString alloc]initWithFormat:@"%@",time.text];
    fullCallingView.hidden = YES;
    
    [[VoIPSingleton sharedVoIP] callHangup:0];
    
    //    if(fullCallingView == nil)
    //        return;
    //    
    //    [fullCallingView removeFromSuperview];
    //    [fullCallingView release];
    //    fullCallingView = nil;
    //    
    [self closeAllCallView];
    //
    if (_timerQual)
    {
        [_timerQual invalidate];
        _timerQual = nil;
    }
    
    if (_timerCall)
    {
        [_timerCall invalidate];
        _timerCall = nil;
    }
    
}



@end
