    //
//  DialerViewController.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "DialerViewController.h"

@implementation DialerViewController


static NSString *_keyStrs[] = {nil, @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"✽", @"0", @"#"};

- (id) init {
	
    self = [super init];
	if(self != nil) {
			
self.title = @"다이얼";
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    
    
    float viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 64;
    } else {
        viewY = 44;
    }
    
    allView = [[UIView alloc]init];
    allView.frame = CGRectMake(0,viewY,320,self.view.frame.size.height-49-viewY);
    [self.view addSubview:allView];
    
    [self settingDialScreenWithHeight:allView.frame.size.height dialer:YES view:allView];
    [self settingDialerWithHeight:allView.frame.size.height dialer:YES view:allView];
    
}


- (void)settingDialScreenWithHeight:(float)h dialer:(BOOL)dialer view:(UIView *)aView{
    
    int lineCount = 4;
    
    if(dialer)
        lineCount = 5;
    
    float cellHeight = 55;
    if(!dialer)
        cellHeight = 49;
    if(IS_HEIGHT568){
        cellHeight = 65;
    }
    
    if(dialScreenView){
        [dialScreenView removeFromSuperview];
        dialScreenView = nil;
    }
    
    dialScreenView = [[UIView alloc]init];
    dialScreenView.frame = CGRectMake(0, 0, 320, h - (cellHeight*lineCount));
    dialScreenView.backgroundColor = RGB(167,205,226);
    [aView addSubview:dialScreenView];
    
    
    
    if(dialer){
        labelDialNumber = [CustomUIKit labelWithText:@"" bold:NO fontSize:35 fontColor:RGB(28,83,121) frame:CGRectMake(30, 0, 250, dialScreenView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];//[CustomUIKit labelWithText:@"" fontSize:35 fontColor:RGB(28,83,121) frame:CGRectMake(30, topView.frame.size.height/2-35, 250, 35) numberOfLines:1 alignText:NSTextAlignmentCenter];
        labelDialNumber.adjustsFontSizeToFitWidth = YES; // 숫자가 많아질수록 크기가 작아진다.
        
        [dialScreenView addSubview:labelDialNumber];
        
//    labelDialName = [CustomUIKit labelWithText:@"" bold:NO fontSize:20 fontColor:RGB(28,83,121) frame:CGRectMake(20, labelDialNumber.frame.size.height, 280, dialScreenView.frame.size.height*2/5) numberOfLines:1 alignText:NSTextAlignmentCenter];//[[CustomUIKit labelWithText:@"" fontSize:20 fontColor:RGB(28,83,121) frame:CGRectMake(20, topView.frame.size.height/2, 280, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    
//        [dialScreenView addSubview:labelDialName];
        
        UIButton *button;
        button = [CustomUIKit buttonWithTitle:@"CLEAR" fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(deleteLongPress) frame:CGRectMake(320 - 45, dialScreenView.frame.size.height/2-20, 40, 40)
                             imageNamedBullet:nil imageNamedNormal:@"button_dialer_clear.png" imageNamedPressed:nil];
        [dialScreenView addSubview:button];
    }
    else{
        
        labelDialNumber = [CustomUIKit labelWithText:@"" bold:NO fontSize:35 fontColor:RGB(28,83,121) frame:CGRectMake(30, 0, 250, dialScreenView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];//[CustomUIKit labelWithText:@"" fontSize:35 fontColor:RGB(28,83,121) frame:CGRectMake(30, topView.frame.size.height/2-35, 250, 35) numberOfLines:1 alignText:NSTextAlignmentCenter];
        labelDialNumber.adjustsFontSizeToFitWidth = YES; // 숫자가 많아질수록 크기가 작아진다.
        
        [dialScreenView addSubview:labelDialNumber];
    }
    
}

- (void)settingDialerWithHeight:(float)h dialer:(BOOL)dialer view:(UIView *)aView{
    
    int lineCount = 4;
    if(dialer)
        lineCount = 5;
    
    float cellHeight = 55;
    if(!dialer)
        cellHeight = 49;
    if(IS_HEIGHT568){
        cellHeight = 65;
    }
    
    

    UIButton *button;
    UIButton *bgButton;
    UIImageView *imageView;
    
    
    if(dialer){
        
        
    
        
        bgButton = [CustomUIKit buttonWithTitle:@"DIAL" fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(touchDummy:) frame:CGRectMake(0, aView.frame.size.height-cellHeight, 107*2, cellHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        bgButton.backgroundColor = RGB(152,204,33);
        bgButton.tag = 13;
        [aView addSubview:bgButton];
 
        
    imageView = [[UIImageView alloc]init];
    imageView.image = [CustomUIKit customImageNamed:@"imageview_dialer_call.png"];
    imageView.frame = CGRectMake(bgButton.frame.size.width/2-12, bgButton.frame.size.height/2-18, 25, 36);
    [bgButton addSubview:imageView];
    
    
        bgButton = [CustomUIKit buttonWithTitle:@"DELETE" fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(touchDummy:) frame:CGRectMake(107*2, aView.frame.size.height-cellHeight, 106, cellHeight) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [aView addSubview:bgButton];
        bgButton.tag = 14;
        bgButton.backgroundColor = RGB(243,244,246);
    
        
    imageView = [[UIImageView alloc]init];
    imageView.image = [CustomUIKit customImageNamed:@"imageview_dialer_delete.png"];
    imageView.frame = CGRectMake(bgButton.frame.size.width/2-17, bgButton.frame.size.height/2-10, 34, 21);
    [bgButton addSubview:imageView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteLongPress)];
    longPress.minimumPressDuration = 0.6f;
    [bgButton addGestureRecognizer:longPress];
    }
    else{
        NSLog(@"not dialer");
    }
    
    
    for (int i = 1; i <= 12; ++i)
    {
        NSString *dialTitle; //*imageNameT
        int x = 0, y = 0, w = 0, h = cellHeight;//, h2;
        
        
        
        
        
        w = ((i % 3) == 0) ? 106 : 107;
        
        
        if(i<4)
            y = aView.frame.size.height-(h*lineCount);
        else if(i>3 && i<7)
            y = aView.frame.size.height-(h*(lineCount-1));
        else if(i>6 && i<10)
            y = aView.frame.size.height-(h*(lineCount-2));
        else if(i>9 && i<13)
            y = aView.frame.size.height-(h*(lineCount-3));
        
        
        if(i%3 == 1) x = 0;
        else if(i%3 == 2 ) x = 107;
        else x = 107 + 107;
        
        
        dialTitle = _keyStrs[i];
        
        
        button = [CustomUIKit buttonWithTitle:dialTitle fontSize:30 fontColor:RGB(108,108,108) target:self selector:@selector(touchDummy:) frame:CGRectMake(x, y, w, h) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [button setBackgroundImage:[SharedFunctions imageWithColor:RGB(243,244,246) width:w height:h] forState:UIControlStateNormal];
        [button setBackgroundImage:[SharedFunctions imageWithColor:RGB(0,174,239) width:w height:h] forState:UIControlStateHighlighted];
        [button setTitleColor:RGB(108,108,108) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [aView addSubview:button];
        button.tag = i;
        CGFloat borderWidth = 0.5f;
        button.backgroundColor = RGB(243,244,246);
        button.layer.borderColor = RGB(218,218,218).CGColor;
        button.layer.borderWidth = borderWidth;
        
        
        
    }
    
    
}

- (void)resetDial{
    
    
    
    if(allView != nil)
    [self settingDialScreenWithHeight:allView.frame.size.height dialer:YES view:allView];
}
- (void)viewWillAppear:(BOOL)animated
{
    
}

//#define kUsingUid 1
#define kNumber 3

#pragma mark -
#pragma mark Dial Button Event
- (void)touchDummy:(id)sender
{

    
    
    
		NSString *digit, *labelNumber;
		NSString *digit6th, *digit7th, *digit8th;
		NSString *digitPre, *digitMid, *digitSuf;
    
            labelNumber = [NSString stringWithString:labelDialNumber.text];

				
				
				if ([[[sender titleLabel] text] isEqualToString:@"DELETE"])
				{				
						if ([labelNumber length] < 2)
								digit = @"";
							
						else
								digit = [labelNumber substringToIndex:[labelNumber length]-1];
						
						if([digit hasSuffix:@"-"]) // 숫자와 - 한번에 지우기
								digit = [labelNumber substringToIndex:[labelNumber length]-2];
								
						
						if([digit hasPrefix:@"02-"])  // ex) 02-3434-3434 -> 02-343-4343
						{
								if([digit length]==11)
								{
								digit6th = [digit substringWithRange:NSMakeRange(6,1)];
								digit7th = [digit substringWithRange:NSMakeRange(7,1)];
								digit = [digit stringByReplacingCharactersInRange:NSMakeRange(6, 1) withString:digit7th];
								digit = [digit stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:digit6th];
								}
						}
						
						else if([digit hasPrefix:@"02"]) 
						{
								if( [digit length]==10) // ex) 02343434343 -> 02-3434-3434
								{
                                    
										digitPre = [digit substringWithRange:NSMakeRange(0, 2)];
										digitMid = [digit substringWithRange:NSMakeRange(2, 4)];
										digitSuf = [digit substringWithRange:NSMakeRange(6, 4)];
										digit = [digitPre stringByAppendingString:@"-"];
										digit = [digit stringByAppendingString:digitMid];
										digit = [digit stringByAppendingString:@"-"];
										digit = [digit stringByAppendingString:digitSuf];

								}
						}
						
						else if(([digit hasPrefix:@"070-"] || [digit hasPrefix:@"010-"] || [digit hasPrefix:@"011-"] || [digit hasPrefix:@"016-"] || 
							 [digit hasPrefix:@"017-"] || [digit hasPrefix:@"019-"]  || [digit hasPrefix:@"018-"]))
						{
								if( [digit length] == 12)
								{
										digit7th = [digit substringWithRange:NSMakeRange(7,1)];
								digit8th = [digit substringWithRange:NSMakeRange(8,1)];
								digit = [digit stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:digit8th];
								digit = [digit stringByReplacingCharactersInRange:NSMakeRange(8, 1) withString:digit7th];
								}
						}
						
						else if([digit hasPrefix:@"070"] || [digit hasPrefix:@"010"] || [digit hasPrefix:@"011"] || [digit hasPrefix:@"016"] || 
										 [digit hasPrefix:@"017"] || [digit hasPrefix:@"019"] || [digit hasPrefix:@"018"])
						{

								if([digit length]==11) // ex) 010727721922 -> 010-7277-2192
								{
                                    
										digitPre = [digit substringWithRange:NSMakeRange(0, 3)];
										digitMid = [digit substringWithRange:NSMakeRange(3, 4)];
										digitSuf = [digit substringWithRange:NSMakeRange(7, 4)];
										digit = [digitPre stringByAppendingString:@"-"];
										digit = [digit stringByAppendingString:digitMid];
										digit = [digit stringByAppendingString:@"-"];
										digit = [digit stringByAppendingString:digitSuf];
								}
						}
						
						
						else if([digit hasPrefix:@"031-"] || [digit hasPrefix:@"032-"] || 
										[digit hasPrefix:@"033-"] || [digit hasPrefix:@"041-"] || [digit hasPrefix:@"042-"] || [digit hasPrefix:@"043-"] || 
										[digit hasPrefix:@"051-"] || [digit hasPrefix:@"052-"] || [digit hasPrefix:@"053-"] || [digit hasPrefix:@"054-"] || 
										[digit hasPrefix:@"055-"] || [digit hasPrefix:@"061-"] || [digit hasPrefix:@"062-"] || [digit hasPrefix:@"063-"]
										|| [digit hasPrefix:@"064-"])
						{
                            
						}
						
						
						else if([digit hasPrefix:@"031"] || [digit hasPrefix:@"032"] || 
										[digit hasPrefix:@"033"] || [digit hasPrefix:@"041"] || [digit hasPrefix:@"042"] || [digit hasPrefix:@"043"] || 
										[digit hasPrefix:@"051"] || [digit hasPrefix:@"052"] || [digit hasPrefix:@"053"] || [digit hasPrefix:@"054"] || 
										[digit hasPrefix:@"055"] || [digit hasPrefix:@"061"] || [digit hasPrefix:@"062"] || [digit hasPrefix:@"063"]
										|| [digit hasPrefix:@"064"])
						{
								if([digit length]==10) // ex) 03122233334 -> 031-222-3333
								{
                                    
										digitPre = [digit substringWithRange:NSMakeRange(0, 3)];
										digitMid = [digit substringWithRange:NSMakeRange(3, 3)];
										digitSuf = [digit substringWithRange:NSMakeRange(6, 4)];
										digit = [digitPre stringByAppendingString:@"-"];
										digit = [digit stringByAppendingString:digitMid];
										digit = [digit stringByAppendingString:@"-"];
										digit = [digit stringByAppendingString:digitSuf];
								}
						}
						
						
                    digit = [digit stringByReplacingOccurrencesOfString:@"✽" withString:@"*"];
                    
                        [labelDialNumber setText:digit];
						
				}
				else if ([[[sender titleLabel] text] isEqualToString:@"DIAL"])
				{
                    if([labelDialNumber.text length]>0)
                        [SharedAppDelegate.root makeDicOutgoing:@"" num:labelDialNumber.text];


//                    UIView *view = [SharedAppDelegate.root.callManager setFullOutgoingWithDic:dic];//hNumber:labelDialNumber.text name:@"" uid:@""];
//                    [SharedAppDelegate.window addSubview:view];
                    
               
                    
                    NSLog(@"yourDic %@",yourDic);
//                    if(yourDic != nil && [yourDic[@"uniqueid"]length]>0){
//                        
//                        UIView *view = [SharedAppDelegate.root.callManager setFullOutgoing:yourDic[@"uniqueid"] usingUid:kUsingUid];
//                        [SharedAppDelegate.window addSubview:view];
//                    }
//                    else{
//                    UIView *view = [SharedAppDelegate.root.callManager setFullOutgoing:labelDialNumber.text usingUid:kNumber];
//                    [SharedAppDelegate.window addSubview:view];
                    //                    }
                    
                        [labelDialNumber setText:@""];
                    
//						[labelDialName setText:@""];
				}
				else // 번호 누르는 부분
				{
                    BOOL calling = [SharedAppDelegate.root.callManager isCalling];
                    if(calling){
                        char digitchar;
                        switch ([sender tag]) {
                            case 1:
                                digitchar = '1';
                                break;
                                
                            case 2:
                                digitchar = '2';
                                break;
                                
                            case 3:
                                digitchar = '3';
                                break;
                                
                            case 4:
                                digitchar = '4';
                                break;
                                
                            case 5:
                                digitchar = '5';
                                break;
                                
                            case 6:
                                digitchar = '6';
                                break;
                                
                            case 7:
                                digitchar = '7';
                                break;
                                
                            case 8:
                                digitchar = '8';
                                break;
                                
                            case 9:
                                digitchar = '9';
                                break;
                                
                            case 10:
                                digitchar = '*';
                                break;
                                
                            case 11:
                                digitchar = '0';
                                break;
                                
                            case 12:
                                digitchar = '#';
                                break;
                                
                            default:
                                break;
                        }
                        
                        BOOL checkSend = [[VoIPSingleton sharedVoIP] callSenddigit:digitchar];
                        NSLog(@"digitchar %c",digitchar);
                        NSLog(@"checkSend %@",checkSend?@"YES":@"NO");
                        if(checkSend){
                            
                            digit = [NSString stringWithFormat:@"%@%@", labelNumber, [[sender titleLabel] text]];
                        }
                    }
                    else{
                        
                        digit = [NSString stringWithFormat:@"%@%@", labelNumber, [[sender titleLabel] text]];
                        
                        
                        if([labelNumber hasPrefix:@"02"])
                        {
                            
                            
                            if([digit length]==3 || [digit length]==7) // ex) 02 -> 02-3 / 02-333 -> 02-333-4
                                digit = [NSString stringWithFormat:@"%@-%@", labelNumber, [[sender titleLabel] text]];
                            
                            if([digit hasPrefix:@"02-"] && [digit length]==12) // ex) 02-333-4444 -> 02-3334-4445
                            {
                                digit6th = [digit substringWithRange:NSMakeRange(6,1)];
                                digit7th = [digit substringWithRange:NSMakeRange(7,1)];
                                digit = [digit stringByReplacingCharactersInRange:NSMakeRange(6, 1) withString:digit7th];
                                digit = [digit stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:digit6th];
                                
                                
                            }
                            
                            
                            if([digit length]>12) // ex) 02-3333-4444 -> 02333344445
                            {
                                digit = [SharedFunctions getPureNumbers:digit];
                                
                            }
                        }
                        
                        
                        
                        else if([labelNumber hasPrefix:@"070"] || [labelNumber hasPrefix:@"010"] || [labelNumber hasPrefix:@"011"] || [labelNumber hasPrefix:@"016"] ||
                                [labelNumber hasPrefix:@"017"] || [labelNumber hasPrefix:@"019"] || [labelNumber hasPrefix:@"018"])
                        {
                            
                            if([digit length]==4 || [digit length] == 8) // ex) 016-2 / 016-213-2
                            {
                                digit = [NSString stringWithFormat:@"%@-%@", labelNumber, [[sender titleLabel] text]];
                            }
                            if(([digit hasPrefix:@"070-"] || [digit hasPrefix:@"010-"] || [digit hasPrefix:@"011-"] || [digit hasPrefix:@"016-"] ||
                                [digit hasPrefix:@"017-"] || [digit hasPrefix:@"019-"] || [digit hasPrefix:@"018-"]) && [digit length] == 13)
                            { // ex) 016-213-2192 -> 016-2132-1922
                                
                                digit7th = [digit substringWithRange:NSMakeRange(7,1)];
                                digit8th = [digit substringWithRange:NSMakeRange(8,1)];
                                digit = [digit stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:digit8th];
                                digit = [digit stringByReplacingCharactersInRange:NSMakeRange(8, 1) withString:digit7th];
                            }
                            
                            if([digit length]>13) // 너무 길어지면 하이픈 없앰.
                            {
                                digit = [SharedFunctions getPureNumbers:digit];
                                
                            }
                            
                        }
                        
                        
                        else if([labelNumber hasPrefix:@"031"] || [labelNumber hasPrefix:@"032"] || 
                                [labelNumber hasPrefix:@"033"] || [labelNumber hasPrefix:@"041"] || [labelNumber hasPrefix:@"042"] || [labelNumber hasPrefix:@"043"] || 
                                [labelNumber hasPrefix:@"051"] || [labelNumber hasPrefix:@"052"] || [labelNumber hasPrefix:@"053"] || [labelNumber hasPrefix:@"054"] || 
                                [labelNumber hasPrefix:@"055"] || [labelNumber hasPrefix:@"061"] || [labelNumber hasPrefix:@"062"] || [labelNumber hasPrefix:@"063"]
                                || [labelNumber hasPrefix:@"064"])
                        {
                            
                            if([digit length]==4 || [digit length] == 8)
                                digit = [NSString stringWithFormat:@"%@-%@", labelNumber, [[sender titleLabel] text]];
                            
                            if([digit length]>12) // 너무 길어지면 하이픈 없앰.
                            {
                                digit = [SharedFunctions getPureNumbers:digit];
                                
                            }
                        }
                        
                        
                    }
						
						
						// 대쉬 그리기
						

                    
                    digit = [digit stringByReplacingOccurrencesOfString:@"✽" withString:@"*"];
                    
                        [labelDialNumber setText:digit];
                    
                    
						int downKey = -1;
						for (int i = 1; i <= 12; ++i)
						{
								if ([[[sender titleLabel] text] isEqualToString:_keyStrs[i]])
								{
										downKey = i;
										break;
								}
						}
                    
						
						
				}
    
    
//            if([labelDialNumber.text length]<7)
//                labelDialName.text = nil;
//            else
//            [self performSelectorOnMainThread:@selector(searchNum) withObject:nil waitUntilDone:NO];
   
    
		
		
}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//	if(buttonIndex == 0)
//	{
//        
//	}
//    else 
//    {
//        if(alertView.tag  == 777)
//        {
//            
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:callingNumber]]];
//
//        }
//    }
//    
//}
//
//
- (void)searchNum
{
    
//    
//    
//       if(yourDic){
//           [yourDic release];
//           yourDic = nil;
//       }
//    yourDic = [[NSDictionary alloc]initWithDictionary:[SharedAppDelegate.root searchDicWithOnlyNumber:labelDialNumber.text]];
//    
//    NSLog(@"yourDic %@",yourDic);
//
//    if(yourDic[@"uniqueid"] == nil || [yourDic[@"uniqueid"]length]<1)
//        [labelDialName setText:@""];
//       else{
//           NSString *name = [NSString stringWithFormat:@"%@",yourDic[@"name"]];
//    [labelDialName setText:name]; // 번호에 따른 이름이 뜨도록.
//       }
}
//
//
//
//
//
//
//- (void)cancel
//{
//    NSLog(@"backTo");
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//
//#define kCall 3
//- (void)loadSearch
//{
//    //    [self closeCall];
//    NSLog(@"pushSearch");
//    
//      [SharedAppDelegate.root.callManager loadCallMember];
////    [SharedAppDelegate.root loadSearch:kCall];
//    
//    
//}
//
//#define kAll 2
//
//- (void)loadLocalNumber{
//    
//    
//    LocalContactViewController *localController = [[LocalContactViewController alloc] initWithTag:kAll];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:localController];
//        [self presentViewController:nc animated:YES completion:nil];
//        [localController release];
//        [nc release];
//    
//
//}
//
//
//
//
////- (void)playSoundForKey:(int)key
////{
////    
////    /****************************************************************
////     작업자 : 김혜민
////     작업일자 : 2012/06/04
////     작업내용 : 다이얼 키패드 숫자에 따른 소리를 재생한다.
////     param  - key(int) : 누른 다이얼 키패드의 숫자
////     연관화면 : 채팅
////     ****************************************************************/
////    
////    
////    
////    
////		if (!sounds[key])
////		{
////				NSBundle *mainBundle = [NSBundle mainBundle];
////				NSString *filename = [NSString stringWithFormat:@"dtmf-%c", 
////															(key == 10 ? 's' : _keyValues[key])];
////				NSString *path = [mainBundle pathForResource:filename ofType:@"aif"];
////				if (!path)
////						return;
////				
////				NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
////				if (aFileURL != nil)  
////				{
////						SystemSoundID aSoundID;
////						OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, 
////																															&aSoundID);
////						if (error != kAudioServicesNoError)
////								return;
////						
////						sounds[key] = aSoundID;
////				}
////		}
////		AudioServicesPlaySystemSound(sounds[key]);
////    
////}
//
//
//
//
- (void)deleteLongPress
{
    NSLog(@"deleteLongPress");
    
    
		labelDialNumber.text = @"";
//		labelDialName.text = @"";
    
}



- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
//	NSLog(@"Dialer ViewDidUnload\n");
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




@end
