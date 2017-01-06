//
//  MenuViewController.m
//  ViewDeckExample
//


#import "AllContactViewController.h"
#import "SelectContactViewController.h"
//#import "SearchContactController.h"
//#import "NewGroupViewController.h"
#import "AddFavoriteViewController.h"

@implementation AllContactViewController

//@synthesize myList;

- (id)init//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self != nil) {
        // Custom initialization
        NSLog(@"AllContactViewController init");
        //        memberList = [[NSMutableArray alloc]init];
        selectContact = [[SelectContactViewController alloc]init];
		self.title = @"조직도";

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:YES alarm:NO];
    
//    UIButton *button = [CustomUIKit closeRightButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    favList = [[NSMutableArray alloc]init];
//    chatList = [[NSMutableArray alloc]init];
    copyList = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfiles) name:@"refreshProfiles" object:nil];
    
    NSLog(@"ContactViewController viewDidLoad");
    
    float viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44 + 20;
    } else {
        viewY = 44;
        
    }
    
    
    
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, viewY, 320, 0)];
    
	search.placeholder = @"이름(초성), 부서, 전화번호 검색";
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(242,242,242);
        }
    }
    else{
        search.tintColor = RGB(242,242,242);
    }
	//    search.backgroundImage = [CustomUIKit customImageNamed:@"n04_secbg.png"];
    
//    search.backgroundImage = [CustomUIKit customImageNamed:@"n03_sd_right_bg_top.png"];
//    [search setSearchFieldBackgroundImage:[CustomUIKit customImageNamed:@"n03_sd_serch_bg_01.png"] forState:UIControlStateNormal];
    search.delegate = self;
    [self.view addSubview:search];
//    [search release];
    
    //    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0,44,320-53,2)];
    //    line.image = [CustomUIKit customImageNamed:@"n02_sd_right_bgline.png"];
    //    [self.view addSubview:line];
    //    [line release];
    
    
//    UIImageView *gradation = [[UIImageView alloc]initWithFrame:CGRectMake(0,44,320,19)];
//    gradation.image = [CustomUIKit customImageNamed:@"side_up_gradation_bg.png"];
//    [self.view addSubview:gradation];
//    [gradation release];
//
    
//    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(110, 60, 51, 67)];
//    logo.image = [CustomUIKit customImageNamed:@"side_coverlogo.png"];
//    [self.view addSubview:logo];
//    [logo release];
    
    myTable = [[UITableView alloc]init];
    
    myTable.frame = CGRectMake(0, viewY + search.frame.size.height, 320, self.view.frame.size.height - viewY - 49 - search.frame.size.height);
    
    myTable.rowHeight = 50;
    NSLog(@"self.view frame %@",NSStringFromCGRect(self.view.frame));
    myTable.scrollsToTop = NO;
    //    myTable.rowHeight = 44;
    
//    myTable.separatorColor = [UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n02_sd_right_bgline.png"]];
//    myTable.backgroundColor = [UIColor clearColor];
    myTable.delegate = self;
    myTable.dataSource = self;
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:myTable];
//    [myTable release];
    
    
}

- (void)cancel{
    NSLog(@"cancel!!!!!!!!!!!!!!!!");
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    [favList release];
//    [copyList release];
//    [chatList release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //    if(![SharedAppDelegate.root.home.category isEqualToString:@"2"])
    [self setFavoriteList];
//    [self setRecentList];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= o7) {

//    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);

//    }
//    else{
//        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);
//    }
    
}

- (void)refreshProfiles{
	NSLog(@"=========== (old)SETMYINFO ==========");
    [myTable reloadData];
}

//- (void)setRecentList{
//    NSLog(@"setRecentList");
//    [chatList setArray:[SQLiteDBManager getRecentChatList]];
    //    [chatList setArray:[SharedAppDelegate.root getRecentChatList]];
//
//    [myTable reloadData];
//}

- (void)setFavoriteList{
    
    [favList removeAllObjects];
//    for(NSDictionary *dic in [ResourceLoader sharedInstance].allContactList){
//        if([dic[@"favorite"]isEqualToString:@"1"] && ![dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
//            [favList addObject:dic];
//    }
//    NSLog(@"favList %@",favList);
    for(NSString *uid in [ResourceLoader sharedInstance].favoriteList){
        if(![uid isEqualToString:[ResourceLoader sharedInstance].myUID]){
            if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
        [favList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
        }
     }
    [myTable reloadData];
    
}

- (void)fetchFavorite{
    NSLog(@"copyList %@",copyList);
    if([copyList count]==0)
        return;
    
    for(NSDictionary *dic in copyList){
        NSLog(@"Favorite 1 uid %@",dic[@"uniqueid"]);
        NSString *aUid = dic[@"uniqueid"];
        [SQLiteDBManager updateFavorite:@"1" uniqueid:aUid];
        
        
    }
    
}
- (void)setCopyList{
    NSLog(@"setCopyList %@",favList);
    if([favList count]==0)
        return;
    
    [copyList setArray:favList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else if(section == 1)
        return [favList count]>0?[favList count]:1;
       else
        return 0;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[myListobjectatindex:section]objectForKey:@"title"];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 0;
    else
        return 33;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 33)];
    headerView.backgroundColor = RGB(236, 236, 236);//[UIColor lightGrayColor];
//    headerView.image = [CustomUIKit customImageNamed:@"headerbg.png"];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 7, 260, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.textAlignment = UITextAlignmentLeft;
    
//    if(section == 1)
//        headerLabel.text = @"내 정보";
     if(section == 1)
        headerLabel.text = [NSString stringWithFormat:@"즐겨찾기 %d",(int)[favList count]];
//    else if(section == 3)
//        headerLabel.text = @"최근 대화 목록";
    else
        headerLabel.text = @"";
    
    
    UIButton *edit;
    if(section == 1)
    {
        headerView.userInteractionEnabled = YES;
        edit = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editFavorite) frame:CGRectMake(320-57, 0, 57, 33) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [headerView addSubview:edit];
        
        UILabel *label = [CustomUIKit labelWithText:@"편집" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(10, 5, edit.frame.size.width-15, edit.frame.size.height - 10) numberOfLines:1 alignText:UITextAlignmentCenter];
        label.backgroundColor = [UIColor grayColor];
        label.layer.cornerRadius = 3.0; // rounding label
        label.clipsToBounds = YES;
        [edit addSubview:label];
    }
    
    [headerView addSubview:headerLabel];
    
    
    
    return headerView;
}

- (void)editFavorite
{
    //    if([favList count]==0)
    //        return;
    //
    //
    //
    //    [myTable setEditing:!myTable.editing animated:YES];
    
    
    
    AddFavoriteViewController *controller = [[AddFavoriteViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
  [SharedAppDelegate.root presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
    
}

- (void)tableSetEditingNO{
    NSLog(@"tableSetEditingNO");
    [myTable setEditing:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(myTable.editing)
        [self tableSetEditingNO];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        
        
        //       [[[myListobjectatindex:indexPath.section]objectForKey:@"data"]removeObjectAtIndex:indexPath.row];
        if(indexPath.section == 2 && [favList count]>0){
            //			[SharedAppDelegate.root updateFavorite:@"0" uniqueid:];
            NSString *deleteId = favList[indexPath.row][@"uniqueid"];
            NSLog(@"deleteId %@",deleteId);
            NSLog(@"1 %@",favList);
            [favList removeObjectAtIndex:indexPath.row];
            [self removeFavorite:deleteId];
            NSLog(@"2 %@",favList);
            //            [tableView beginUpdates];
            //            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //            [tableView endUpdates];
            NSLog(@"3");
            
            
        }
    }
}

- (void)removeFavorite:(NSString *)uid
{
    NSLog(@"removeFavorite %@",uid);
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mirae.lemp.co.kr/"]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"2",@"type",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                uid,@"member",
                                @"1",@"category",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];
    NSLog(@"parameter %@",parameters);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResulstDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            [SQLiteDBManager updateFavorite:@"0" uniqueid:uid];
            [myTable reloadData];
            //            [self tableSetEditingNO];// animated:YES];
            
            
            
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
		[HTTPExceptionHandler handlingByError:error];
		//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"즐겨찾기 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
        return YES;
    else
        return NO;
}

//- (void)setNewChatlist{
//    
//    [chatList setArray:[SQLiteDBManager getRecentChatList]];
//    [myTable reloadData];
//}
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
    
    static NSString *CellIdentifier = @"Cell";
//    UIImageView *view;//, *imageView;
    //    UILabel *label;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    view = [[UIImageView alloc]init];
//    view.image = [CustomUIKit customImageNamed:@"n03_sd_right_bg.png"];
//    cell.backgroundView = view;
//    [view release];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
//            UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 50)];
//            [cell.contentView addSubview:leftButton];
//            [leftButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
//            
//        UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 15, 160-55-10, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
//        label.text = @"조직도";//[NSString stringWithFormat:@"%@ 조직도",[SharedAppDelegate readPlist:@"comname"]];
//        [leftButton addSubview:label];
//        //            [label release];
//        
//        UIImageView *cellImage = [[UIImageView alloc]init];
//        cellImage.frame = CGRectMake(0, 0, 50, 50);
//        cellImage.image = [CustomUIKit customImageNamed:@"organization_ic.png"];
//            [leftButton addSubview:cellImage];
//            [cellImage release];
            
            
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 15, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
            //            label.text = [NSString stringWithFormat:@"%@ 조직도",[SharedAppDelegate readPlist:@"comname"]];
            label.text = @"조직도";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(0, 0, 50, 50);
            cellImage.image = [CustomUIKit customImageNamed:@"organization_ic.png"];
            [cell.contentView addSubview:cellImage];
//            [cellImage release];
        }
        else if(indexPath.row == 1){
            UILabel *label = [CustomUIKit labelWithText:nil fontSize:18 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 15, 150, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
//            label.text = [NSString stringWithFormat:@"%@ 조직도",[SharedAppDelegate readPlist:@"comname"]];
            label.text = @"내 부서";
            [cell.contentView addSubview:label];
            //            [label release];
            
            UIImageView *cellImage = [[UIImageView alloc]init];
            cellImage.frame = CGRectMake(0, 0, 50, 50);
            cellImage.image = [CustomUIKit customImageNamed:@"department_ic.png"];
            [cell.contentView addSubview:cellImage];
//            [cellImage release];
        }
        //            cell.imageView.image = [CustomUIKit customImageNamed:@"muic_organization.png"];
        //            cell.textLabel.text = @"조직도";
    }
    else if(indexPath.section == 1)
    {
        
        if([favList count]>0){
            
            NSDictionary *dic = favList[indexPath.row];
            NSLog(@"dic %@",dic);
            UIImageView *profileView = [[UIImageView alloc]init];
            profileView.frame = CGRectMake(0, 0, 50, 50);
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"imageview_organize_defaultprofile.png" view:profileView scale:0];
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            UIImageView *holiday;
            holiday = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50-20, 20, 20)];
            holiday.tag = 81;
            [profileView addSubview:holiday];
//            [holiday release];
            
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
            
            UIImageView *disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//            disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
//             [disableView release];
            
            
            UILabel *name = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor darkGrayColor] frame:CGRectMake(55, 5, 320-60-105, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
//            name.text = dic[@"name"];
            [cell.contentView addSubview:name];
            //            [name release];
            
//        	CGSize size = [name.text sizeWithFont:name.font];
            UILabel *position = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(55, 15, 80, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
//            if(size.width + 5 > 80)
//                position.frame = CGRectMake(name.frame.origin.x + 80, name.frame.origin.y+2, 80, 16);
//            position.text = dic[@"grade2"];//?[dicobjectForKey:@"grade2"]:[dicobjectForKey:@"position"];
            [cell.contentView addSubview:position];
            //            [position release];
            
//        	CGSize size2 = [position.text sizeWithFont:position.font];
            UILabel *team = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height) numberOfLines:1 alignText:UITextAlignmentLeft];
//            if(size2.width + 5 > 80)
//                team.frame = CGRectMake(position.frame.origin.x + 80, position.frame.origin.y+1, 70, 15);
//            team.text = dic[@"team"];
            [cell.contentView addSubview:team];
            //            [team release];
            
            
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//            team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade"],dic[@"team"]];
//            NSDictionary *dic = copyList[indexPath.row];
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
            
            
            UILabel *lblStatus;
            
            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
            lblStatus.font = [UIFont systemFontOfSize:12];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = UITextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 6;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            UIImageView *roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
//            [roundingView release];
            

            
//            UIButton *invite;
//            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 7, 57, 32)];
//            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"installplz_btn.png"] forState:UIControlStateNormal];
//            [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:invite];
//            invite.tag = 4;
//            invite.titleLabel.text = dic[@"uniqueid"];
//            
//            [invite release];
            
//            UIImageView *infoBgView;
//            UILabel *info;
//            infoBgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-5-103,profileView.frame.origin.y,103,40)];
//            infoBgView.tag = 10;
//            [cell.contentView addSubview:infoBgView];
//            [infoBgView release];
//            
//            info = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(12, 0, infoBgView.frame.size.width-15, infoBgView.frame.size.height) numberOfLines:2 alignText:UITextAlignmentLeft];
//            info.tag = 6;
//            [infoBgView addSubview:info];

//            UIButton *callButton;
//            
//            callButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(call:) frame:CGRectMake(320-39-7, 10, 39, 30) imageNamedBullet:nil imageNamedNormal:@"button_contact_call.png" imageNamedPressed:nil];
//            callButton.titleLabel.text = favList[indexPath.row][@"uniqueid"];
//            [cell.contentView addSubview:callButton];
        
            
            if([dic[@"available"]isEqualToString:@"0"]){
//                callButton.hidden = YES;
				lblStatus.text = @"미설치";
                disableView.hidden = NO;
//                infoBgView.hidden = YES;
//                info.text = @"";
                
//				if([[SharedAppDelegate.root getPureNumbers:dic[@"cellphone"]]length]>9)
//					invite.hidden = NO;
//                else
//                    invite.hidden = YES;
            }
            else if([dic[@"available"]isEqualToString:@"4"]){
//                callButton.hidden = YES;
                lblStatus.text = @"로그아웃";
                disableView.hidden = NO;
                //                invite.hidden = YES;
//                infoBgView.hidden = NO;
//                infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info_logout.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//                info.text = dic[@"newfield1"];
//                CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:UILineBreakModeWordWrap];
//                info.frame = CGRectMake(10, 0, infoSize.width, 40);
//                infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
//              info.textColor = RGB(146, 146, 146);
//                NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//                if([newString length]<1){
//                    infoBgView.hidden = YES;
//                }
            }
            else{
                //                invite.hidden = YES;
//                callButton.hidden = NO;
				lblStatus.text = @"";
                disableView.hidden = YES;
//                infoBgView.hidden = NO;
//                infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//                info.text = dic[@"newfield1"];
//                CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:UILineBreakModeWordWrap];
//                info.frame = CGRectMake(10, 0, infoSize.width, 40);
//                infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
//                info.textColor = RGB(115, 149, 184);
//                NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//                if([newString length]<1){
//                    infoBgView.hidden = YES;
//                }
            }
            
        
        
        
        }
        else{

            UILabel *label = [CustomUIKit labelWithText:nil fontSize:13 fontColor:[UIColor darkGrayColor] frame:CGRectMake(15, 15, 300, 20) numberOfLines:1 alignText:UITextAlignmentCenter];
            label.text = @"자주 소통하는 동료를 즐겨찾기 하세요.";
            [cell.contentView addSubview:label];
            //            [label release];
            
//            UIImageView *cellImage = [[UIImageView alloc]init];
//            cellImage.frame = CGRectMake(18, 8, 25, 25);
//            cellImage.image = [CustomUIKit customImageNamed:@"adduser_icon.png"];
//            [cell.contentView addSubview:cellImage];
//            [cellImage release];
        }
    }
    
    
    return cell;
}




#define kSearch 2

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    
//    [SharedAppDelegate.root loadSearch:kSearch]; //con:SharedAppDelegate.root.centerController];
    
    
    return NO;
}


- (void)loadOrganize{
    
    NSLog(@"toptree %@",[SharedAppDelegate readPlist:@"toptree"]);
    if([[SharedAppDelegate readPlist:@"toptree"]count]==1){
        
        NSString *mydeptcode = [SharedAppDelegate readPlist:@"toptree"][0];
        NSString *listName = [[ResourceLoader sharedInstance] searchCode:mydeptcode];
        NSLog(@"listName %@",listName);
        [SharedAppDelegate.root.organize setTagInfo:0];
        [SharedAppDelegate.root.organize.selectCodeList removeAllObjects];
        [SharedAppDelegate.root.organize.selectCodeList addObject:mydeptcode];
        [SharedAppDelegate.root.organize.addArray removeAllObjects];
        [SharedAppDelegate.root.organize.addArray addObject:listName];
        //    NSLog(@"org addarray %@ addobject %@",organizeController.addArray,listName);
        [SharedAppDelegate.root.organize setFirstButton];
        if(![SharedAppDelegate.root.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.organize class]])
        [SharedAppDelegate.root.navigationController pushViewController:SharedAppDelegate.root.organize animated:YES];
        [SharedAppDelegate.root.organize setFirst:listName];
        [SharedAppDelegate.root.organize checkSameLevel:mydeptcode];
        
        UIButton *button = [CustomUIKit backButtonWithTitle:nil target:SharedAppDelegate.root.organize selector:@selector(backAll)];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        SharedAppDelegate.root.organize.navigationItem.leftBarButtonItem = btnNavi;

    }
    else{
        if(![SharedAppDelegate.root.navigationController.topViewController isKindOfClass:[selectContact class]])
        [SharedAppDelegate.root.navigationController pushViewController:selectContact animated:YES];
        
        UIButton *button = [CustomUIKit backButtonWithTitle:nil target:selectContact selector:@selector(backAll)];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        selectContact.navigationItem.leftBarButtonItem = btnNavi;
    }
}

- (void)loadMyDept{
    
    
    NSString *mydeptcode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
    mydeptcode = (mydeptcode != nil && [mydeptcode length]>0) ? mydeptcode : @"";
    NSString *listName = [[ResourceLoader sharedInstance] searchCode:mydeptcode];
    NSLog(@"listName %@",listName);
    listName = [listName length]>0?listName:@"";
    [SharedAppDelegate.root.organize setTagInfo:0];
    [SharedAppDelegate.root.organize.selectCodeList removeAllObjects];
    [SharedAppDelegate.root.organize.selectCodeList addObject:mydeptcode];
    [SharedAppDelegate.root.organize.addArray removeAllObjects];
    [SharedAppDelegate.root.organize.addArray addObject:listName];
    //    NSLog(@"org addarray %@ addobject %@",organizeController.addArray,listName);
    [SharedAppDelegate.root.organize setFirstButton];
    if(![SharedAppDelegate.root.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.organize class]])
    [SharedAppDelegate.root.navigationController pushViewController:SharedAppDelegate.root.organize animated:YES];
    [SharedAppDelegate.root.organize setFirst:listName];
    [SharedAppDelegate.root.organize checkSameLevel:mydeptcode];
    
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:SharedAppDelegate.root.organize selector:@selector(backAll)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    SharedAppDelegate.root.organize.navigationItem.leftBarButtonItem = btnNavi;
}
#define kDelete 1
#define kOutRegi 2
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [self loadOrganize];
        }
        else if(indexPath.row == 1) {
            [self loadMyDept];
			//            [self.navigationController pushViewController: animated:YES]
            
        }
    }
    if(indexPath.section == 1){
        if([favList count]>0){
            
            [SharedAppDelegate.root settingYours:favList[indexPath.row][@"uniqueid"]];
            
        }
        else{
            [self editFavorite];
            
        }
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
