//
//  RecentCallViewController.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 11. 10. 19..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "CallListViewController.h"
#import "DialerViewController.h"

@implementation CallListViewController

@synthesize myTable;
@synthesize myList;

#pragma mark -
#pragma mark Initialization


- (id)init
{
    self = [super init];
    if (self != nil)
    {
                    self.title = @"통화기록";
        NSLog(@"init");
    }
    return self;
}


- (void)refreshContents
{
    [self.myList setArray:[SQLiteDBManager getLog]];
    NSLog(@"self.mylist %@",self.myList);
    [myTable reloadData];
    
//    if (myTable.editing == YES) {
//        // 삭제버튼 갱신
//        if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
//            NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
//            [self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
//        }
//    }
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    NSLog(@"viewdidLoad");
    
    
    self.myList = [[NSMutableArray alloc]init];
   
    self.myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    self.myTable.allowsMultipleSelectionDuringEditing = YES;
    self.myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([self.myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    float viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44 + 20;
    } else {
        viewY = 44;
        
    }
    
    
    myTable.frame = CGRectMake(0, viewY, 320, self.view.frame.size.height - viewY - 49);
    
    
    
    [self.view addSubview:self.myTable];
    
    
    self.view.userInteractionEnabled = YES;
    
    
//    UIButton *newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showCallPopup) frame:CGRectMake(320 - 81, self.view.frame.size.height - 49 - viewY - 81 - 48, 81, 81) imageNamedBullet:nil imageNamedNormal:@"button_newcall.png" imageNamedPressed:nil];
//    [self.view addSubview:newbutton];
}


//#define kCall 3
//#define kCallpopup 10000
//
//- (void)showCallPopup{
//
//    [SharedAppDelegate.root.callManager loadCallMember];
//
//}
//
//
//
//- (void)loadSearch
//{
//    //    [self closeCall];
//    NSLog(@"pushSearch");
//    
//    [SharedAppDelegate.root loadSearch:kCall];
//    
//    
//}
//
//
//#define kUsingUid 1
//
//- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    
//    if(alert.tag == kCallpopup){
//        NSLog(@"buttonindex %d",buttonIndex);
//        if(buttonIndex == 1){
//            // 다이얼
//            DialerViewController *dialer = [[DialerViewController alloc]init];
//            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:dialer];
//            [self presentModalViewController:nc animated:YES];
//            [dialer release];
//            [nc release];
//        }
//        else if(buttonIndex == 2){
//            // 주소록
//            [self.parentViewController newCommunicate];
//        }
//    }
//    else{
//        if(buttonIndex==1){
//            //        [SharedAppDelegate.root.callManager callCheck:[[self.myListobjectatindex:alert.tag]objectForKey:@"num"]];
//            
//            NSDictionary *dic = self.myList[alert.tag];
//            NSLog(@"dic %@",dic);
//            
//            if ([dic[@"num"]hasPrefix:@"*"]) {
//                NSString *uid = [dic[@"num"] substringWithRange:NSMakeRange(1, [dic[@"num"] length]-1)];
//                [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setFullOutgoing:uid usingUid:kUsingUid]];
//            }
//            else{
//                
//                NSString *uid = [SharedAppDelegate.root searchDicWithNumber:dic[@"num"] withName:[dic[@"toname"]length]>0?dic[@"toname"]:dic[@"toname"]][@"uniqueid"];
//                [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setReDialing:dic uid:uid]];//setFullOutgoing:uid usingUid:NO]];
//            }
//            //        [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setFullOutgoing:[[self.myListobjectatindex:alert.tag]objectForKey:@"num"]]];
//            
//        }
//    }
//}


- (void)viewWillAppear:(BOOL)animated {
    
    
    [self refreshContents];
    NSLog(@"viewwillappear %@",self.myList);
}


- (NSUInteger)myListCount
{
    return myList?[myList count]:0;
}

- (NSUInteger)selectListCount
{
    return myTable?[myTable.indexPathsForSelectedRows count]:0;
}

- (void)startEditing
{
    [myTable setEditing:YES animated:YES];
}

- (void)endEditing
{
    [myTable setEditing:NO animated:YES];
}

- (void)commitDelete
{
    if (myTable.editing == YES && [self.myList count] != 0) {
        if ([myTable.indexPathsForSelectedRows count] > 0) {
            NSMutableArray *selectedIDs = [NSMutableArray array];
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            
            for (NSIndexPath *indexPath in myTable.indexPathsForSelectedRows) {
                [selectedIDs addObject:[myList objectAtIndex:indexPath.row][@"id"]];
                [indexSet addIndex:indexPath.row];
            }
            
            [SQLiteDBManager removeCallLogRecords:selectedIDs];
            [self.myList removeObjectsAtIndexes:indexSet];
            
            if ([myList count] == 0) {
                [myTable reloadData];
            } else {
                [myTable reloadData];
                //				[myTable deleteRowsAtIndexPaths:[myTable indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            
        } else {
            [CustomUIKit popupAlertViewOK:nil msg:@"선택된 통화목록이 없습니다!"];
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
//    if([self.myList count]>3)
//        return 2;
//    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 1)
        return 1;
    else{
        return [myList count]==0?1:[myList count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 55;
    else
        return 83;
    
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
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *from, *to, *date, *time, *aboutNum;
    //    UIImageView *imageView, *profile;
    UIImageView *profile;
    UIImageView *roundingView;
    UIImageView *senderView;
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
        
        
        profile = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 46, 46)];
        profile.tag = 7;
        [cell.contentView addSubview:profile];
//        [profile release];
        
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0, 0, 46, 46);
        roundingView.tag = 500;
        [profile addSubview:roundingView];
//        [roundingView release];
        //		imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 27, 16, 15)];
        //		imageView.tag = 6;
        //        [cell.contentView addSubview:imageView];
        //        [imageView release];
        
        from = [[UILabel alloc]initWithFrame:CGRectMake(65, 17, 120, 18)];
        from.backgroundColor = [UIColor clearColor];
        from.font = [UIFont systemFontOfSize:15];
        //    from.frame = CGRectMake(40, 15, 120, 18);
        //        from.textColor = RGB(87, 107, 149);
        //        from.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        from.tag = 1;
        [cell.contentView addSubview:from];
//        [from release];
        
        to = [[UILabel alloc]initWithFrame:CGRectMake(65, 17, 120, 18)];
        to.backgroundColor = [UIColor clearColor];
        to.font = [UIFont systemFontOfSize:15];
        //        to.textColor = RGB(87, 107, 149);
        //    to.frame = CGRectMake(40, 15, 120, 18);
        //		to.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        to.tag = 2;
        [cell.contentView addSubview:to];
//        [to release];
        
//        num = [[UILabel alloc]initWithFrame:CGRectMake(65, 17, 120, 18)];
//        num.font = [UIFont systemFontOfSize:15];
//        num.backgroundColor = [UIColor clearColor];
//        //		num.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        num.tag = 5;
//        [cell.contentView addSubview:num];
//        [num release];
        
        aboutNum = [[UILabel alloc]init];
        aboutNum.font = [UIFont systemFontOfSize:11];
        aboutNum.backgroundColor = [UIColor clearColor];
        aboutNum.textColor = [UIColor grayColor];
        //		aboutNum.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        aboutNum.tag = 8;
        [cell.contentView addSubview:aboutNum];
//        [aboutNum release];
        
        date = [[UILabel alloc]initWithFrame:CGRectMake(320-5-130, 5, 130, 20)];
        date.font = [UIFont systemFontOfSize:12];
        date.textColor = [UIColor grayColor];
        date.textAlignment = NSTextAlignmentRight;
        date.backgroundColor = [UIColor clearColor];
        date.adjustsFontSizeToFitWidth = YES;
        //		date.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        date.tag = 3;
        [cell.contentView addSubview:date];
//        [date release];
        
        time = [[UILabel alloc]initWithFrame:CGRectMake(320-5-130, 30, 130, 20)];
        time.font = [UIFont systemFontOfSize:12];
        time.textColor = [UIColor grayColor];
        time.textAlignment = NSTextAlignmentRight;
        time.backgroundColor = [UIColor clearColor];
        //		time.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        time.tag = 4;
        [cell.contentView addSubview:time];
//        [time release];
        
        senderView = [[UIImageView alloc] init];
        senderView.tag = 1011;
        [cell.contentView addSubview:senderView];
    }
    else{
        from = (UILabel *)[cell viewWithTag:1];
        to = (UILabel *)[cell viewWithTag:2];
        date = (UILabel *)[cell viewWithTag:3];
        time = (UILabel *)[cell viewWithTag:4];
//        num = (UILabel *)[cell viewWithTag:5];
        profile = (UIImageView *)[cell viewWithTag:7];
        //        imageView = (UIImageView *)[cell viewWithTag:6];
        aboutNum = (UILabel *)[cell viewWithTag:8];
        senderView = (UIImageView*)[cell.contentView viewWithTag:1011];
        roundingView = (UIImageView*)[cell.contentView viewWithTag:500];
    }
    if(indexPath.section == 1 && indexPath.row == 0){
        
        from.text = @"";
        to.text = @"";
        date.text = @"";
        time.text = @"";
//        num.text = @"";
        aboutNum.text = @"";
//        cell.imageView.image = nil;
        senderView.image = nil;
        roundingView.image = nil;
        profile.image = nil;
        cell.textLabel.text = @"";
        senderView.frame = CGRectMake(120, 1, 81, 81);
        senderView.image = [UIImage imageNamed:@"imageview_list_restview_logo.png"];
        return cell;
    }
    if ([myList count] == 0) {
        from.text = @"";
        to.text = @"";
        date.text = @"";
        time.text = @"";
//        num.text = @"";
        aboutNum.text = @"";
//        cell.imageView.image = nil;
        senderView.image = nil;
        roundingView.image = nil;
        profile.image = nil;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"동료에게 무료통화를 해보세요.";
        return cell;
    }
    
    cell.textLabel.text = @"";
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    roundingView.image = [CustomUIKit customImageNamed:@"imageview_list_profile_background.png"];
    time.textColor = [UIColor grayColor];
    cell.textLabel.text = nil;
    NSDictionary *dic = self.myList[indexPath.row];
    NSLog(@"dic %@",dic);
    senderView.frame = CGRectMake(5, 2, 46, 46);
    if([dic[@"toname"] isEqualToString:@""])
    {
        if([dic[@"talktime"] isEqualToString:@"부재중 전화"]){
            senderView.image = [CustomUIKit customImageNamed:@"imageview_list_profile_missed.png"];
            time.textColor = [UIColor redColor];
        }
        else
            senderView.image = [CustomUIKit customImageNamed:@"imageview_list_profile_incoming.png"];
        
    }
    
    if([dic[@"fromname"] isEqualToString:@""])
    {
        if([dic[@"talktime"] isEqualToString:@"발신 취소"])
            senderView.image = [CustomUIKit customImageNamed:@"imageview_list_profile_missed_send.png"];
        else
            senderView.image = [CustomUIKit customImageNamed:@"imageview_list_profile_outgoing.png"];

    }
    
    from.text = dic[@"fromname"];
    to.text = dic[@"toname"];
//    num.text = @"";
    
    NSString *number = dic[@"num"];
    
    
    
    
    
    CGSize whoSize;
    
    if([from.text length]>0)
        whoSize = [from.text sizeWithFont:from.font];
    else if([to.text length]>0)
        whoSize = [to.text sizeWithFont:to.font];
    
    
    NSString *uid = number;
    
    if([number hasPrefix:@"*"]){
        NSLog(@"num hasprefix *");
        uid = [uid substringWithRange:NSMakeRange(1, [number length]-1)];
        
    }else{
        
        
    }
    
    if([number hasPrefix:@"*"]){
    }
    else if([number isEqualToString:from.text]){
        from.text = [SharedAppDelegate.root dashCheck:number];
    }
    else if([number isEqualToString:to.text]){
        to.text = [SharedAppDelegate.root dashCheck:number];
    }
    else{
        
    }
    
    if([number hasPrefix:@"6"] || [number hasPrefix:@"7"]){
        if([number length] == 6)
            aboutNum.text = @"FMC";
        else if([number length] == 5)
            aboutNum.text = @"내선";
        else
            aboutNum.text = @"";
    }
    else
        aboutNum.text = @"";
    
    
    CGSize aSize = [aboutNum.text sizeWithFont:aboutNum.font];
    aboutNum.frame = CGRectMake(65 + whoSize.width+3, 20, aSize.width, aSize.height);
    
    
    [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"imageview_organize_defaultprofile.png" view:profile scale:0];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if([dic[@"talkdate"]hasSuffix:@"분"]){
        [formatter setDateFormat:@"M월 d일 a h시 mm분"];
        NSDate *talkDate = [formatter dateFromString:dic[@"talkdate"]];
        NSLog(@"talkDate %@",talkDate);
        [formatter setDateFormat:@"MM.dd"];
        date.text = [formatter stringFromDate:talkDate];
    }
    else{
        NSDate *talkDate = [NSDate dateWithTimeIntervalSince1970:[dic[@"talkdate"] doubleValue]];
        [formatter setDateFormat:@"yy.MM.dd"];
        if([[formatter stringFromDate:talkDate]isEqualToString:[formatter stringFromDate:[NSDate date]]]){
            // same day
            [formatter setDateFormat:@"a h:mm"];
        }
        else{
        }
        
        date.text = [formatter stringFromDate:talkDate];
    }
//    [formatter release];
    
    NSArray *timeArray = [dic[@"talktime"] componentsSeparatedByString:@"/"];
    NSLog(@"timeArray %@",timeArray);
    NSArray *hourArray = [timeArray[0] componentsSeparatedByString:@":"];
    NSLog(@"hourArray %@",hourArray);
    if([hourArray count]==2){
        time.text = [NSString stringWithFormat:@"%02d:%02d:%@",[hourArray[0]intValue]/60,[hourArray[0]intValue]%60,hourArray[1]];
    }
    else{
        time.text = timeArray[0];
    }
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.section == 1)
        return NO;
    
    if ([myList count] == 0) {
        return NO;
    } else {
        return YES;
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        if ([myList count] != 0) {
            [SQLiteDBManager removeCallLogRecordWithId:[self.myList[indexPath.row][@"id"]intValue] all:NO];
            [self.myList removeObjectAtIndex:indexPath.row];
            
            
            if ([myList count] == 0) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
    }
}




/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1)
        return;
    if (tableView.editing == YES) {
        // 삭제버튼 갱신
     
        
    } else {
        if ([myList count] != 0) {
            NSLog(@"mylist %@",myList[indexPath.row]);
            
            
                
                NSDictionary *dic = myList[indexPath.row];
                NSString *name = @"";
                if([dic[@"toname"]length]>0)
                    name = dic[@"toname"];
                else if([dic[@"fromname"]length]>0)
                    name = dic[@"fromname"];
            
            if([dic[@"num"] isEqualToString:name]){
                name = @"";
            }
                NSDictionary *calldic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         dic[@"num"],@"cellphone",
                                         name,@"name",
                                         @"",@"uid",
                                         @"",@"grade2",
                                         @"",@"profileimage",nil];
                
                [SharedAppDelegate.root directAddOutgoing:calldic num:dic[@"num"]];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
//        } else {
//            [self showCallPopup];
//            //			[SharedAppDelegate.root.callManager loadCallMember];
//        }
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing == YES) {
        // 삭제버튼 갱신
      
        
    }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    self.myTable = nil;
    self.myList = nil;
}


@end


