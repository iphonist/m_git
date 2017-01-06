//
//  ContactViewController.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "ContactViewController.h"
#import <AddressBook/AddressBook.h>
#import <objc/runtime.h>



@implementation ContactViewController


#pragma mark -
#pragma mark Handle the custom alert




- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.title = @"연락처";
        
        
        
        float viewY = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            viewY = 44 + 20;
        } else {
            viewY = 44;
            
        }
        
        
        
        search = [[UISearchBar alloc]init];
        
                
                search.frame = CGRectMake(320*0, viewY, 320, 44);
                search.delegate = self;
                searching = NO;
                [self.view addSubview:search];
        [search release];
        
            
        
        
        
        
        CGRect tableFrame;
        tableFrame = CGRectMake(0, CGRectGetMaxY(search.frame), 320, self.view.frame.size.height - CGRectGetMaxY(search.frame) - 49);
        
        myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
        myTable.dataSource = self;
        myTable.delegate = self;
        myTable.rowHeight = 50;
        [self.view addSubview:myTable];
        [myTable release];
        
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        myList = [[NSMutableArray alloc]init];
        originList = [[NSMutableArray alloc]init];
        
        copyList = [[NSMutableArray alloc]init];
        
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [search resignFirstResponder];
}






- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"취소" forState:UIControlStateNormal];
        }
    }
    
    
    
//    [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)]];
    
    NSString *name = @"";//[[NSString alloc]init];
    if(chosungArray)
    {
        chosungArray = nil;
    }
    chosungArray = [[NSMutableArray alloc]init];
    for(NSDictionary *forDic in originList)//int i = 0 ; i < [originList count] ; i ++)
    {
        name = forDic[@"name"];//[forDicobjectForKey:@"name"];
        NSString *str = [self getUTF8String:name];//[AppID GetUTF8String:name];
        [chosungArray addObject:str];
    }

    
    
}
- (NSString *)getUTF8StringOne:(NSString *)hanggulString{
    
    
    if([hanggulString length]<1)
        return @"";
    
    NSArray *chosung = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSString *textResult = @"";
   
    
        NSInteger code = [hanggulString characterAtIndex:0];
    
        if (code >= 44032 && code <= 55203) {
            NSInteger uniCode = code - 44032;
            NSInteger chosungIndex = uniCode / 21 / 28;
            textResult = [NSString stringWithFormat:@"%@", chosung[chosungIndex]];//[chosungobjectatindex:chosungIndex]];
        }
        else if(code >= 'A' && code <= 'z'){
            
            
            textResult = @"Az";//[NSString stringWithFormat:@"%c", [hanggulString characterAtIndex:0]];
        }
        else{
            
            textResult = @"#";
        }
    
    return textResult;
}


- (NSString *)getUTF8String:(NSString *)hanggulString{
    
    
    
    NSArray *chosung = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSString *textResult = @"";
    for (int i=0;i<[hanggulString length];i++) {
        NSInteger code = [hanggulString characterAtIndex:i];
        if (code >= 44032 && code <= 55203) {
            NSInteger uniCode = code - 44032;
            NSInteger chosungIndex = uniCode / 21 / 28;
            textResult = [NSString stringWithFormat:@"%@%@", textResult, chosung[chosungIndex]];//[chosungobjectatindex:chosungIndex]];
        }
    }
    return textResult;
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // 터치바에 글자 쓰기
{
    [copyList removeAllObjects];
    
    
    
    if([searchText length]>0)
    {
        NSMutableDictionary *searchDic;
//        [SharedAppDelegate.root removeDisableView];
        
        myTable.userInteractionEnabled = YES;
        searching = YES;
        for(int i = 0 ; i < [chosungArray count] ; i++)
        {
            
            if([chosungArray[i] rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
               || [originList[i][@"name"] rangeOfString:searchText].location != NSNotFound)
            {
                
                searchDic = [NSMutableDictionary dictionaryWithDictionary:originList[i]];
                
                
                [copyList addObject:searchDic];
                
            }
        }
    }
    
    else
    {
        NSLog(@"text not exist %f",self.view.frame.size.height);
        
        [searchBar becomeFirstResponder];
        //        [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
//        [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)]];
        myTable.userInteractionEnabled = NO;
        searching = NO;
        
    }
    
    [myTable reloadData];
    
    
}





// 취소 버튼 누르면 키보드 내려가기
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [search resignFirstResponder];
    [myTable setUserInteractionEnabled:YES];
//    [SharedAppDelegate.root removeDisableView];
    
}


// 키보드의 검색 버튼을 누르면
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [search resignFirstResponder];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if(searching)
        return nil;
    else{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < [myList count]; i++) {
        [arr addObject:[[myList objectAtIndex:i] objectForKey:@"grouptitle"]];
    }
    return arr;
    }
}



// 섹션에 몇 개의 셀이 있는지.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if([myList count]==0)
        return 1;
    else{
        if(searching)
        {
            return [copyList count];
        }
        else
        {
            return [myList[section][@"group"]count];
            
        }
    }
}


// 몇 개의 섹션이 있는지. // 얘가 먼저 호출됨
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sec = 0;
    
    if(searching)
        sec = 1;
    
    else
    {
        sec = [myList count];
    }
    return sec;
}



// 해당 뷰가 생성될 때 한 번만 호출
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    
    
    
}

- (NSMutableArray *)getAllocAddressBook{
    
    NSLog(@"getAllocAddressBook");
    
    NSMutableArray *returnList = [[NSMutableArray alloc]init];
    
    NSMutableArray *phoneNumberList = [[NSMutableArray alloc]init];
    
    NSMutableArray *aHeaderChar = [[NSMutableArray alloc]init];
    
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // Get all contacts in the addressbook
    NSArray *allPeople = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    ABMultiValueRef phoneNumbers;
    for (id person in allPeople) {
        // Get all phone numbers of a contact
        phoneNumbers = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
        
        // If the contact has multiple phone numbers, iterate on each of them
        
        for (int i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            
            NSString *phoneNumber; //(__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            phoneNumber = (NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"82" withString:@"0"];
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            NSString *name = [[lastName length]>0?lastName:@"" stringByAppendingFormat:@"%@",[firstName length]>0?firstName:@""];
            [phoneNumberList addObject:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"number",name,@"name",nil]];
            
            NSString *str = [self getUTF8StringOne:name];//[AppID GetUTF8String:name];
            if([str length]>0)
                [aHeaderChar addObject:str];
        }
    }
    
    
    NSArray *aNSArray = [[NSSet setWithArray: phoneNumberList] allObjects];
    [phoneNumberList setArray:aNSArray];
    [originList setArray:aNSArray];
    
    
   aNSArray = [[NSSet setWithArray: aHeaderChar] allObjects];
    [aHeaderChar setArray:aNSArray];
    
    
    
    
    for(int i = 0; i < [aHeaderChar count] ;i++){
        NSString *grouptitle = aHeaderChar[i];
        NSMutableArray *groupArray;
        groupArray = [[NSMutableArray alloc]init];
        
        for(int j = 0; j < [phoneNumberList count]; j++){
            NSString *onechar = [self getUTF8StringOne:phoneNumberList[j][@"name"]];
            if([onechar length]>0 && [grouptitle isEqualToString:onechar]){
        
                [groupArray addObject:phoneNumberList[j]];
            }
        }
        
        
        NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCompare:)];
        [groupArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
        [returnList addObject:[NSDictionary dictionaryWithObjectsAndKeys:grouptitle,@"grouptitle",groupArray,@"group",nil]];
    }
    
    
    NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"grouptitle" ascending:YES selector:@selector(localizedCompare:)];
    [returnList sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
    
    
    return returnList;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return nil;
    
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 검색하고나서 뷰를 드래깅하면, 불투명한 뷰를 제거하고 키보드를 내려준다.
     param - scrollView(UIScrollView *) : 스크롤뷰
     연관화면 : 검색
     ****************************************************************/
    
    //    dragging = YES;
    
    if([search isFirstResponder])
    {
        [search resignFirstResponder];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //    dragging = NO;
    [myTable reloadData];
}      // called when scroll view grinds to a halt





#define kNotFavorite 1
#define kFavorite 2


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([myList count]==0)
        return;
    else{
        [search resignFirstResponder];
        
        NSDictionary *dic = nil;
        if(searching)
            dic = copyList[indexPath.row];
        else
            dic = myList[indexPath.section][@"group"][indexPath.row];
        
        NSLog(@"dic %@",dic);
        
        [SharedAppDelegate.root makeDicOutgoing:@"" num:dic[@"number"]];
        
        
    }
    
}





// 뷰가 나타날 때마다 호출
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    fetching = NO;
    [SVProgressHUD showWithStatus:@"연락처 불러오는중"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fetchList];
}
- (void)fetchList{
    progressing = NO;
    
    NSLog(@"fetchList");
    
    [SVProgressHUD showWithStatus:@"연락처 불러오는중"];
    
    __block BOOL userDidGrantAddressBookAccess;
    CFErrorRef addressBookError = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
      
        
        NSLog(@"NOTgranted");
        [CustomUIKit popupAlertViewOK:nil msg:@"연락처에 접근할 수 없습니다.\n설정>개인정보 보호>연락처에서 스위치를 켜 주세요."];
       
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized ||
             ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        // The user has previously given access, add the contact
        
        
        addressBookRef = ABAddressBookCreateWithOptions(NULL, &addressBookError);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            userDidGrantAddressBookAccess = granted;
            dispatch_semaphore_signal(sema);
            
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        NSLog(@"userDidGrantAddressBookAccess %@",userDidGrantAddressBookAccess?@"Y":@"N");
        
        NSLog(@"authorized");
        [myList setArray:[self getAllocAddressBook]];
    }
    else {
        // 이미 접근 거절 후 또다시 접근 하려고 할 때
        NSLog(@"denied");
        [CustomUIKit popupAlertViewOK:nil msg:@"연락처에 접근할 수 없습니다.\n설정>개인정보 보호>연락처에서 스위치를 켜 주세요."];
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
    //    [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
    //
    //    for(int i = 0; i < [myList count]; i++){
    //        if([myList[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
    //            [myList removeObjectAtIndex:i];
    //    }
    
    
    
    fetching = YES;
    [myTable reloadData];
    [SVProgressHUD showSuccessWithStatus:@"완료"];
    
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

// 셀 정의 함수.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    
    UILabel *name, *team;//, *lblStatus;
//    UIButton *callButton;
//    UIImageView *profileView, *disableView, *roundingView;
//    UIImageView *checkView;
//    UIImageView *compareView;
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        profileView = [[UIImageView alloc]init];//WithFrame:CGRectMake(40,0,50,50)];
//        profileView.tag = 1;
//        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        name = [[UILabel alloc]init];//WithFrame:CGRectMake(40+55, 5, 320-100, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:14];
        //        name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
        [name release];
        
//        
        team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
        team.font = [UIFont systemFontOfSize:14];
        team.textColor = [UIColor grayColor];
        team.backgroundColor = [UIColor clearColor];
        team.tag = 3;
        [cell.contentView addSubview:team];
        [team release];
//
//        disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
//        
//        //        disableView.backgroundColor = RGBA(0,0,0,0.64);
//        disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
//        [profileView addSubview:disableView];
//        disableView.tag = 11;
//        [disableView release];
//        
//        lblStatus = [[UILabel alloc]init];//WithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
//        lblStatus.font = [UIFont systemFontOfSize:12];
//        lblStatus.textColor = [UIColor whiteColor];
//        lblStatus.textAlignment = NSTextAlignmentCenter;
//        lblStatus.backgroundColor = [UIColor clearColor];
//        lblStatus.tag = 6;
//        [disableView addSubview:lblStatus];
//        [lblStatus release];
//        
//        checkView = [[UIImageView alloc]init];//WithFrame:
//        checkView.tag = 5;
//        [cell.contentView addSubview:checkView];
//        [checkView release];
//        
//        compareView = [[UIImageView alloc]init];//WithFrame:
//        compareView.tag = 7;
//        [cell.contentView addSubview:compareView];
//        [compareView release];
//        
//        callButton = [[UIButton alloc]initWithFrame:CGRectMake(320-50, 10, 39, 30)];
//        [callButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_contact_call.png"] forState:UIControlStateNormal];
//        [callButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
//        callButton.tag = 4;
//        [cell.contentView addSubview:callButton];
//
//        roundingView = [[UIImageView alloc]init];
//        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
//        [profileView addSubview:roundingView];
//        roundingView.tag = 10;
//        [roundingView release];
        
    }
    else{
//        profileView = (UIImageView *)[cell viewWithTag:1];
//        roundingView = (UIImageView *)[cell viewWithTag:10];
        name = (UILabel *)[cell viewWithTag:2];
        //            position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:3];
//        disableView = (UIImageView *)[cell viewWithTag:11];
//        lblStatus = (UILabel *)[cell viewWithTag:6];
//        checkView = (UIImageView *)[cell viewWithTag:5];
//        compareView = (UIImageView *)[cell viewWithTag:7];
//        callButton = (UIButton *)[cell viewWithTag:4];
    }
//    profileView.image = nil;
    
    //    NSLog(@"mylist count %d",[myList count]);
    if([originList count]==0){
        
//        profileView.image = nil;
//        callButton.hidden = YES;
        name.textAlignment = NSTextAlignmentCenter;
        name.frame = CGRectMake(15, 9, 290, 34);
        team.text = @"";
        //        invite.hidden = YES;
//        lblStatus.text = @"";
//        checkView.image = nil;
//        compareView.image = nil;
//        disableView.hidden = YES;
        if(fetching){
                name.text = @"휴대폰에 저장된 주소록을 불러오세요.";
            
            
        }  else{
            name.text = @"";
        }
    }
    else{
        
        name.textAlignment = NSTextAlignmentLeft;
        name.frame = CGRectMake(5,5,320-50-10,20);
        team.frame = CGRectMake(name.frame.origin.x,CGRectGetMaxY(name.frame),name.frame.size.width,name.frame.size.height);
        
        NSDictionary *dic = nil;
        if(searching)
        {
            dic = copyList[indexPath.row];
            
        }
        else
        {
            
            if([originList count]>0){
                dic = myList[indexPath.section][@"group"][indexPath.row];
                
                
                
            }
            
            
            
        }
        //        NSLog(@"dic %@",dic);
        
        
        if(dic != nil){
            
            
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            team.text = [NSString stringWithFormat:@"%@",dic[@"number"]];
            
//            callButton.hidden = NO;
//                callButton.titleLabel.text = @"";
//                profileView.frame = CGRectMake(40,0,50,50);
//                roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
//                name.frame = CGRectMake(40+55, 5, 320-100, 20);
//                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//                lblStatus.frame = CGRectMake(0, 15, disableView.frame.size.width, 20);
//                checkView.frame = CGRectMake(0, 0, 40, 50);
//                compareView.frame = CGRectMake(0, 0, 0, 0);
//                compareView.image = nil;
//                
//                [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
//                name.frame = CGRectMake(40+55, 5, 320-100, 20);
//                name.textAlignment = NSTextAlignmentLeft;
//                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
                //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
                
//                if([dic[@"grade2"]length]>0)
//                {
//                    if([dic[@"team"]length]>0)
//                        team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
//                    else
//                        team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
//                }
//                else{
//                    if([dic[@"team"]length]>0)
//                        team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
//                }
//                
//                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
//                
//                
//                if([dic[@"available"]isEqualToString:@"0"])
//                {
//                    disableView.hidden = NO;
//                    lblStatus.text = @"미설치";
//                    
//                }
//                else if([dic[@"available"]isEqualToString:@"4"]){
//                    lblStatus.text = @"로그아웃";
//                    disableView.hidden = NO;
//                    //            invite.hidden = YES;
//                }
//                else
//                {
//                    disableView.hidden = YES;
//                    //            invite.hidden = YES;
//                    lblStatus.text = @"";
//                } //            lblStatus.text = @"";
//                
//                if([dic[@"favorite"]isEqualToString:@"1"]){
//                    [MBProgressHUD hideHUDForView:checkView animated:YES];
//                    checkView.image = [CustomUIKit customImageNamed:@"favorite_prs.png"];
//                }
//                else{
//                    [MBProgressHUD hideHUDForView:checkView animated:YES];
//                    checkView.image = [CustomUIKit customImageNamed:@"favorite_dtt.png"];
//                }
//            }
//            else if(self.view.tag == kRequest){
//                
//                callButton.hidden = YES;
//                callButton.titleLabel.text = @"";
//                profileView.frame = CGRectMake(0,0,0,0);
//                roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
//                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//                name.frame = CGRectMake(10, 5, 320-100, 20);
//                lblStatus.frame = CGRectMake(0, 0, 0, 0);
//                checkView.frame = CGRectMake(320-35, 10, 23, 23);
//                compareView.frame = CGRectMake(320-35-35, 12, 23, 23);
//                
//                if([dic[@"compare"]isEqualToString:@"1"]){
//                    compareView.image = [CustomUIKit customImageNamed:@"imageview_mini_icon.png"];
//                }
//                else{
//                    compareView.image = nil;
//                }
//                
//                if([dic[@"check"]isEqualToString:@"1"]){
//                    checkView.image = [CustomUIKit customImageNamed:@"button_check.png"];
//                }
//                else{
//                    
//                    checkView.image = [CustomUIKit customImageNamed:@"button_nocheck.png"];
//                }
//                profileView.image = nil;
//                
//                name.textAlignment = NSTextAlignmentLeft;
//                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//                team.text = [NSString stringWithFormat:@"%@",dic[@"number"]];
//                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
//                
//                
//                disableView.hidden = YES;
//                lblStatus.text = @"";
//                
//                
//            }
//            else{
//                
//                callButton.hidden = NO;
//                callButton.titleLabel.text = dic[@"number"];
//                profileView.frame = CGRectMake(0,0,0,0);
//                roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
//                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//                name.frame = CGRectMake(10, 5, 320-100, 20);
//                lblStatus.frame = CGRectMake(0, 0, 0, 0);
//                checkView.frame = CGRectMake(320-90, 10, 80, 35);
//                checkView.image = nil;
//                profileView.image = nil;
//                compareView.frame = CGRectMake(0, 0, 0, 0);
//                compareView.image = nil;
//                
//                name.textAlignment = NSTextAlignmentLeft;
//                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//                team.text = [NSString stringWithFormat:@"%@",dic[@"number"]];
//                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
//                
//                
//                disableView.hidden = YES;
//                lblStatus.text = @"";
//                
//                
//            }
//        }
    }
    }
    return cell;
    
}




#define kNumber 3

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}
- (void)dealloc{
    [myList release];
    [copyList release];
    
    [super dealloc];
}



@end
