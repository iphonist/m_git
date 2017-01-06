    //
//  SetupViewController.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "SetupViewController.h"

#import "SubSetupViewController.h"


@implementation SetupViewController

#define kGlobalFontSizeNormal	15
#define kGlobalFontSizeLarge	18
#define kGlobalFontSizeLargest	21

#define kSubStatusWithBack 1000

#define kSubPassword 200
#define kSubBell 300
#define kSubProgram 400
#define kSubAlarm 500
#define kSubReplySort 600
#define kSubGlobalFontSize 700
#define kSubShareAccount 800
#define kSubPush 900

#define kMenu 1
#define kSetup 2
#define kAllSetup 3

- (id)init{
	self = [super init];
	if(self != nil)
	{
        NSLog(@"init");
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"refreshPushAlertStatus" object:nil];

        

        self.navigationController.navigationBar.translucent = NO;
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeBottom;
        
        CGRect tableFrame;
        
        float viewY = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            viewY = 44 + 20;
        } else {
            viewY = 44;
            
        }
            tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height-viewY);

        
        
        myTable = [[UITableView alloc]init];
        myTable.frame = tableFrame;
        myTable.dataSource = self;
        myTable.delegate = self;
        myTable.rowHeight = 50;
        [self.view addSubview:myTable];
        myTable.tag = kAllSetup;
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        [self settingAllSetup];


	}
	return self;
}



- (void)reloadTable
{
	[myTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    
	return [myList count];

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
	UIImageView *imageView;
    UISwitch *echoswitch;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
		
        imageView = [[UIImageView alloc] init];//WithFrame:CGRectMake(84.0, 14.0, 20.0, 20.0)];
		imageView.tag = 20;
		[cell.contentView addSubview:imageView];

    } else {
		imageView = (UIImageView*)[cell.contentView viewWithTag:20];
	}
    
    NSLog(@"table tag %d",tableView.tag);

    
        
        cell.textLabel.text = myList[indexPath.row];
    if(indexPath.row == initContact){
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if(indexPath.row == echoCancel){
        
        
        echoswitch = [[UISwitch alloc]init];
        
        if([[SharedAppDelegate readPlist:@"echoswitch"]isEqualToString:@"1"])//[[AppID readAllPlist:@"pwsaved"] isEqualToString:@"1"])
            [echoswitch setOn:YES];
        else
            [echoswitch setOn:NO];
        
        [echoswitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = echoswitch;
        
    }
    else{
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
        imageView.image = nil;
    
    
        if (indexPath.row == push) {
            
            BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];

            
            if (currentStatus == NO) {
                imageView.frame = CGRectMake(84.0, 14.0, 20.0, 20.0);
                imageView.image = [UIImage imageNamed:@"listalert_ic.png"];
                cell.detailTextLabel.text = @"꺼짐";
            } else {
                cell.detailTextLabel.text = @"켜짐";
            }
            
        } else if (indexPath.row == bell) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
            NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
            NSArray *ringtones = plistDict[@"Ringtones"];
            NSString *bellName = [SharedAppDelegate readPlist:@"bell"];
            
            for (NSDictionary *dic in ringtones) {
                if ([bellName isEqualToString:dic[@"filename"]]) {
                    cell.detailTextLabel.text = dic[@"name"];
                    break;
                }
            }
            
            if ([cell.detailTextLabel.text length] < 1) {
                cell.detailTextLabel.text = @"기본벨소리3";
            }
        
;

            }
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

         if(indexPath.row == programInfo)
        {
            SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubProgram];
//            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
            //        [self presentModalViewController:nc animated:YES];
            if(![self.navigationController isKindOfClass:[sub class]])
            [self.navigationController pushViewController:sub animated:YES];
     
        }
        else if(indexPath.row == status){
            
            SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubStatusWithBack];
//            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
            //        [self presentModalViewController:nc animated:YES];
            if(![self.navigationController isKindOfClass:[sub class]])
            [self.navigationController pushViewController:sub animated:YES];
      
            //        [sub release];
        }
	else if (indexPath.row == push)
	{
		SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubPush];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentModalViewController:nc animated:YES];
        if(![self.navigationController isKindOfClass:[sub class]])
        [self.navigationController pushViewController:sub animated:YES];
    
	}
    else if(indexPath.row == bell)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubBell];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentModalViewController:nc animated:YES];
        if(![self.navigationController isKindOfClass:[sub class]])
        [self.navigationController pushViewController:sub animated:YES];
     
    }
    else if(indexPath.row == initContact){
        
        [CustomUIKit popupAlertViewOK:@"주소록 다시받기" msg:@"주소록을 다시 받아오시겠습니까?" delegate:self tag:(int)initContact];
    }
	

    [tableView deselectRowAtIndexPath:indexPath animated:YES];


	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1){
        if (alertView.tag == initContact) {
            [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
            [SVProgressHUD showWithStatus:@"앱을 종료하지 말고\n기다려주세요." maskType:SVProgressHUDMaskTypeBlack];
            [SharedAppDelegate.root startup];
        }
    }
}



- (void)cancel
{
    
		[self dismissViewControllerAnimated:YES completion:nil];
	 
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
	[myTable reloadData];
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    
    
        }

- (void)onSwitch:(UISwitch *)switchOnOff
{
    
    
            if(switchOnOff.on)
        {
            [SharedAppDelegate writeToPlist:@"echoswitch" value:@"1"];
        }
        else
        {
            
            [SharedAppDelegate writeToPlist:@"echoswitch" value:@"0"];
        }
    [myTable reloadData];
  
    
    
}
- (void)settingAllSetup{
    
    self.title = @"설정";
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"closeglobebtn.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    
    
    
    
    //    status = 0;
    push = 0;
    bell = 1;
    echoCancel = 2;
    programInfo = 3;
    initContact = 4;
    status = 100;
    
    
    myList = [[NSMutableArray alloc] initWithObjects:
//              @"내 정보 ",
              @"푸시알림",
              @"벨소리 설정",
              @"에코캔슬러",
              @"프로그램 정보",
              @"주소록 다시받기",
              nil];

    
    
    [myTable reloadData];
    
}





//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIImageView *headerView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 28)]autorelease];
//    headerView.backgroundColor = [UIColor grayColor];
//    headerView.image = [CustomUIKit customImageNamed:@"headerbg.png"];
//    
//    
//    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 4, 260, 20)]autorelease];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.textColor = [UIColor blackColor];
//    headerLabel.font = [UIFont systemFontOfSize:14];
//    headerLabel.textAlignment = NSTextAlignmentLeft;
//    
//    switch (section) {
//        case 0:
//            headerLabel.text = @"";
//            break;
//        case 1:
//            headerLabel.text = @" 알림 설정";
//            break;
//        case 2:
//            headerLabel.text = @" 일반 설정";
//            break;
//        case 3:
//            headerLabel.text = @" 시스템 설정";
//            break;
//        default:
//            break;
//    }
//    
//    
//    
//    [headerView addSubview:headerLabel];
//    
//    
//    
//    return headerView;
//}
//
//-  (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    if(section == 0)
//        return 0;
//    else
//        return 28;
//    
//}


- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}




@end
