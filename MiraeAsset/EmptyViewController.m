//
//  EmptyListViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 21..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "EmptyViewController.h"


@interface EmptyViewController ()

@end


@implementation EmptyViewController


#define kProgramInfo 1
#define kFavoriteMember 7

- (id)initWithList:(NSMutableArray *)array from:(int)tag
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *button;
        UIBarButtonItem *btnNavi;
        self.view.backgroundColor = [UIColor whiteColor];//colorWithPatternImage:[CustomUIKit customImageNamed:@"dp_tl_background.png"]];
        
        float viewY = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            viewY = 44+20;
        } else {
            viewY = 44;
            
        }
        
        myList = [[NSMutableArray alloc]init];
        CGRect tableFrame;
        tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
        
        if(tag == kProgramInfo){
        button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
        
        self.title = @"프로그램 정보";
        
        
       
            NSLog(@"tag is library");
            UITextView *tv = [[UITextView alloc]init];//WithFrame:CGRectMake(45, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, replySize.width, replySize.height + 10)];
            tv.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-viewY);
			tv.contentInset = UIEdgeInsetsMake(10.0, 0.0, -35.0, 0.0);
            tv.text = @"✽ Countly\nhttps://github.com/Countly/countly-sdk-ios\n\n✽ SVProgressHUD\nhttps://github.com/samvermette/SVProgressHUD\n\n✽ SVPullToRefresh\nhttps://github.com/samvermette/SVPullToRefresh\n\n✽ MBProgressHUD\nhttps://github.com/jdg/MBProgressHUD\n\n✽ JSONKit\nhttps://github.com/johnezang/JSONKit\n\n✽ AFNetworking\nhttps://github.com/AFNetworking/AFNetworking\n\n✽ SDWebImage\nhttps://github.com/rs/SDWebImage\n\n✽ ABCalendarPicker\nhttps://github.com/k06a/ABCalendarPicker\n\n✽ QBImagePicker\nhttps://github.com/questbeat/QBImagePickerController\n\n✽ MHTabBar\nhttps://github.com/hollance/MHTabBarController\n\n✽ LKBadgeView\nhttps://github.com/lakesoft/LKbadgeView\n\n✽ GKImagePicker\nhttps://github.com/gekitz/GKImagePicker\n\n✽ OWActivity\nhttps://github.com/brantyoung/OWActivityViewController\n\n✽ MAImagePicker\nhttps://github.com/mmackh/MAImagePickerController-of-InstaPDF\n\n✽ OpenCV\nhttp://opencv.org/\n\n\n";
            [tv setTextAlignment:NSTextAlignmentLeft];
            [tv setDataDetectorTypes:UIDataDetectorTypeLink];
            [tv setFont:[UIFont systemFontOfSize:14]];
            [tv setBackgroundColor:[UIColor clearColor]];
            [tv setEditable:NO];
            [self.view addSubview:tv];
        }
        else if(tag == kFavoriteMember){
            
            myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
            
            myTable.tag = tag;
            myTable.bounces = YES;
            myTable.dataSource = self;
            myTable.delegate = self;
            myTable.backgroundColor = [UIColor clearColor];
            myTable.backgroundView = nil;
            
            [self.view addSubview:myTable];
            
            
            if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                [myTable setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                [myTable setLayoutMargins:UIEdgeInsetsZero];
            }
        

        
            
            resultArray = [[NSMutableArray alloc]init];
            //                button = [CustomUIKit closeButtonWithTarget:self selector:@selector(closeFavoriteMember)];
            //                btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            //                self.navigationItem.leftBarButtonItem = btnNavi;
            //                [btnNavi release];
            
            button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(closeFavoriteMember)];
            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = btnNavi;
            
//            [btnNavi release];
            
            if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
                [myTable setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
                [myTable setLayoutMargins:UIEdgeInsetsZero];
            }
            [myList removeAllObjects];
            for(NSString *uid in array){
                if([uid length]>0){
                    if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
                        [myList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
                }
            }
            [resultArray setArray:myList];
            NSLog(@"myList %@",myList);
            self.title = [NSString stringWithFormat:@"즐겨찾기 멤버 %d",(int)[myList count]];
            

        }
        
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
 
}

- (void)closeFavoriteMember{
    
    [target performSelector:selector withObject:myList];
    [self backTo];
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    
    self.target = aTarget;
    self.selector = aSelector;
}


- (void)backTo{
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)cancel//:(id)sender
{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if(tableView.tag == kFavoriteMenber)
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    if(tableView.tag == kFavoriteMenber)
        return 50;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //    if(tableView.tag == kFavoriteMenber)
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
//    if(tableView.tag == kFavoriteMember){
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        UILabel *name, *team, *lblStatus;
        UIImageView *disableView;
        //        UIButton *invite;
        UIImageView *profileView, *roundingView;
        UIImageView *checkView;
        UIImageView *holiday;
    
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            profileView = [[UIImageView alloc]initWithFrame:CGRectMake(40,0,50,50)];
            profileView.tag = 1;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            
            holiday = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50-20, 20, 20)];
            holiday.tag = 81;
            [profileView addSubview:holiday];
//            [holiday release];
            
            name = [[UILabel alloc]init];//WithFrame:CGRectMake(55+xPadding, 5, 115, 20)];
            name.backgroundColor = [UIColor clearColor];
            //        name.font = [UIFont systemFontOfSize:15];
            //        name.adjustsFontSizeToFitWidth = YES;
            name.textAlignment = UITextAlignmentLeft;
            name.numberOfLines = 1;
            name.font = [UIFont systemFontOfSize:15];
            name.frame = CGRectMake(55+40, 5, 320-100, 20);
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
            lblStatus.font = [UIFont systemFontOfSize:12];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = UITextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 7;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            checkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
            checkView.tag = 5;
            [cell.contentView addSubview:checkView];
//            [checkView release];
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
//            [roundingView release];
            roundingView.tag = 10;
            

            
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            roundingView = (UIImageView *)[cell viewWithTag:10];
            name = (UILabel *)[cell viewWithTag:2];
            team = (UILabel *)[cell viewWithTag:3];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:7];
            checkView = (UIImageView *)[cell viewWithTag:5];
            holiday = (UIImageView *)[cell viewWithTag:81];
        }
        
        NSDictionary *dic = myList[indexPath.row];
        NSLog(@"dic %@",dic);
        
        
        NSString *leave_type = dic[@"newfield5"];
        if([leave_type length]>0){
            if([leave_type isEqualToString:@"출산"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_add_baby.png"];
            else if([leave_type isEqualToString:@"육아"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_add_feed.png"];
            else if([leave_type isEqualToString:@"개인질병"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_add_disease.png"];
            else
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_add_etc.png"];
        }
        else{
            holiday.image = nil;
        }
        
        
        [SharedAppDelegate.root getProfileImageWithURL:myList[indexPath.row][@"uniqueid"] ifNil:@"imageview_organize_defaultprofile.png" view:profileView scale:0];
        
        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y + 5, 155, 20);
        //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
        
        if([dic[@"grade2"]length]>0)
        {
            if([dic[@"team"]length]>0)
                team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
            else
                team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
        }
        else{
            if([dic[@"team"]length]>0)
                team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
        }
        
        team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
        
        
        if([myList[indexPath.row][@"available"]isEqualToString:@"0"])
        {
            name.textColor = [UIColor blackColor];
            lblStatus.text = @"미설치";
            disableView.hidden = NO;
            
        }
        else if([myList[indexPath.row][@"available"]isEqualToString:@"4"]){
            lblStatus.text = @"로그아웃";
            disableView.hidden = NO;
            name.textColor = [UIColor blackColor];
            
        }
        else{
            disableView.hidden = YES;
            lblStatus.text = @"";
            name.textColor = [UIColor blackColor];
        }
        
        if([myList[indexPath.row][@"favorite"]isEqualToString:@"0"])
            checkView.image = [CustomUIKit customImageNamed:@"favorite_dtt.png"];
        else
            checkView.image = [CustomUIKit customImageNamed:@"favorite_prs.png"];
        
    
    return cell;
        
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        [self addOrClear:myList[indexPath.row]];
    

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}


- (void)addOrClear:(NSDictionary *)d
{
    NSLog(@"addOrClear %@",d);
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:d];
    NSString *type = @"";
    
    //            }
    if([dic[@"favorite"]isEqualToString:@"0"]){
        type = @"1";
        
    }
    else{
        type = @"2";
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mirae.lemp.co.kr/"]];
    
    NSDictionary *parameters = @{
                                 @"type" : type,
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
                                 @"member" : dic[@"uniqueid"],
                                 @"category" : @"1",
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey
                                 };
    NSLog(@"parameter %@",parameters);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            
            if([dic[@"favorite"]isEqualToString:@"0"]){
                [SQLiteDBManager updateFavorite:@"1" uniqueid:dic[@"uniqueid"]];
                
            }
            else {//if([[dicobjectForKey:@"favorite"]isEqualToString:@"1"]){
                [SQLiteDBManager updateFavorite:@"0" uniqueid:dic[@"uniqueid"]];
                
            }
            
            
            for(int i = 0; i < [myList count]; i++){
                if([myList[i][@"uniqueid"]isEqualToString:dic[@"uniqueid"]]){
                    if([dic[@"favorite"] isEqualToString:@"0"])
                    {
                        [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"1" key:@"favorite"]];
                        
                    }
                    else
                    {
                        [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"0" key:@"favorite"]];
                        
                    }
                }
            }
            
            self.title = [NSString stringWithFormat:@"즐겨찾기 멤버 %d",(int)[[ResourceLoader sharedInstance].favoriteList count]];
            
            [myTable reloadData];
            
        }
        else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
