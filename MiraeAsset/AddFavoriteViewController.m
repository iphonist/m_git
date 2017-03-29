//
//  ContactViewController.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "AddFavoriteViewController.h"
//#import "LocalContactViewController.h"
//#import "FavoriteViewController.h"

@implementation AddFavoriteViewController
//@synthesize target;
//@synthesize selector;
//@synthesize myList;
//@synthesize myTable;
//@synthesize disableViewOverlay;
//searchTableData;
//@synthesize willCheck;

#pragma mark -
#pragma mark Handle the custom alert




- (id)init
{
		self = [super init];
		if (self != nil)
		{
						}
		return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [search resignFirstResponder];
}






- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
    
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         search.frame = CGRectMake(0,0,320,44);
//                         localContactButton.frame = CGRectMake(-98-4, 0+6, 98, 33);
                     }];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"취소" forState:UIControlStateNormal];
        }
    }

    NSLog(@"searchBarTextDidBeginEditing %f",self.view.frame.size.height);
    //    [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
//    [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, search.frame.size.height + memberView.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height - memberView.frame.size.height)]];
    
    NSString *name = @"";//[[NSString alloc]init];
    if(chosungArray)
    {
//        [chosungArray release];
        chosungArray = nil;
    }
    chosungArray = [[NSMutableArray alloc]init];
    for(NSDictionary *forDic in myList)//int i = 0 ; i < [originList count] ; i ++)
    {
        name = forDic[@"name"];//[forDicobjectForKey:@"name"];
        NSString *str = [self getUTF8String:name];//[AppID GetUTF8String:name];
        [chosungArray addObject:str];
    }
    NSLog(@"chosungArray %@",chosungArray);
		
}

- (NSString *)getUTF8String:(NSString *)hanggulString{
    
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 받은 스트링에서 초성을 빼내어 돌려준다.
     param - hanggulString(NSString *) : 한글로 된 스트링
     연관화면 : 검색
     ****************************************************************/
    
    
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
        
        if([searchText hasPrefix:@"0"] || [searchText hasPrefix:@"1"] || [searchText hasPrefix:@"2"] || [searchText hasPrefix:@"3"] || [searchText hasPrefix:@"4"] || [searchText hasPrefix:@"5"] || [searchText hasPrefix:@"6"] || [searchText hasPrefix:@"7"] || [searchText hasPrefix:@"8"] || [searchText hasPrefix:@"9"]){
            
            for(int i = 0 ; i < [myList count] ; i++)
            {
                searchDic = [NSMutableDictionary dictionaryWithDictionary:myList[i]];
                NSString *cellphone = [SharedFunctions getPureNumbers:searchDic[@"cellphone"]];
                NSString *companyphone = [SharedFunctions getPureNumbers:searchDic[@"companyphone"]];
                if([cellphone rangeOfString:searchText].location != NSNotFound
                   || [companyphone rangeOfString:searchText].location != NSNotFound
                   )
                {
                    searchDic = [NSMutableDictionary dictionaryWithDictionary:searchDic];
                    [copyList addObject:searchDic];
                    
                }
            }
        }
        else{
            
            for(int i = 0 ; i < [myList count] ; i++)
            {
                searchDic = [NSMutableDictionary dictionaryWithDictionary:myList[i]];
                NSString *chosung = chosungArray[i];
                NSString *name = searchDic[@"name"];
                NSString *team = searchDic[@"team"];
                if([chosung rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
                   || [name rangeOfString:searchText].location != NSNotFound // 이름에 searchText가 있느냐
                                      || [team rangeOfString:searchText].location != NSNotFound
                   )
                {
                    searchDic = [NSMutableDictionary dictionaryWithDictionary:searchDic];
                    [copyList addObject:searchDic];
                    
                }
            }
            
        }
    }
    
    else
    {
        NSLog(@"text not exist %f",self.view.frame.size.height);
        
        [searchBar becomeFirstResponder];
        //        [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
//        [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, search.frame.size.height + memberView.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height - memberView.frame.size.height)]];
        myTable.userInteractionEnabled = NO;
        searching = NO;
        
    }
    
    [myTable reloadData];
//		[copyList removeAllObjects];
//		
//		
//		if([searchText length]>0)
//		{
//            
//            id AppID = [[UIApplication sharedApplication]delegate];
//				
//            NSDictionary *temp;// = [[NSDictionary alloc]init];
//				[self settingDisableViewOverlay:2];
//				self.myTable.userInteractionEnabled = YES;	
//				searching = YES;
//				for(int i = 0 ; i < [chosungArray count] ; i++)
//				{
//                    if([[chosungArrayobjectatindex:i] rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
//                       || [[[myListobjectatindex:i]objectForKey:@"name"] rangeOfString:searchText].location != NSNotFound // 이름에 searchText가 있느냐
//                       || [[AppID getPureNumbers:[[myListobjectatindex:i]objectForKey:@"cellphone"]] rangeOfString:searchText].location != NSNotFound // 핸드폰/집/회사 번호에 searchText가 있느냐
//                       || [[AppID getPureNumbers:[[myListobjectatindex:i]objectForKey:@"companyphone"]] rangeOfString:searchText].location != NSNotFound
//                       || [[[myListobjectatindex:i]objectForKey:@"team"] rangeOfString:searchText].location != NSNotFound)
//						{	
//								temp = [NSDictionary dictionaryWithDictionary:[myListobjectatindex:i]];
//								[copyList addObject:temp];       
//								
//						}
//				}
//				
//		}
//		
//		else 
//		{					
//				
//				[searchBar becomeFirstResponder];
//				[self settingDisableViewOverlay:1];
//				searching = NO;
//				self.myTable.userInteractionEnabled = NO;	
//				
//		}
//		
//		[myTable reloadData];		
		
}





// 취소 버튼 누르면 키보드 내려가기
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         search.frame = CGRectMake(0,0,320-0,45);
//                         localContactButton.frame = CGRectMake(4, 0+6, 98, 33);
                     }];
    
		[searchBar setShowsCancelButton:NO animated:YES];
//
//		searchBar.text = @"";
    [search resignFirstResponder];
    [myTable setUserInteractionEnabled:YES];
//    [SharedAppDelegate.root removeDisableView];
    
}


// 키보드의 검색 버튼을 누르면
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [search resignFirstResponder];
		
}




// 섹션에 몇 개의 셀이 있는지.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{	
		if(searching)
		{
				return [copyList count];
		}
		else
		{
//            if(section == 0){
//                return 1;
//            }
//            else
            if(section == 1-1)
            {
//                if([deptList count]>0)
//                    return [deptList count];
//                else if([addRestList count]>0)
//                    return [addRestList count];
//                else
//                    return 0;
                return [deptList count]==0?1:[deptList count];
            }
            else if(section == 2-1){
                return [addRestList count]==0?0:[addRestList count];
            }
                else
                    return 0;
            
		
		}
}


// 몇 개의 섹션이 있는지. // 얘가 먼저 호출됨.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sec = 0;
    
    if(searching)
        sec = 1;
    
else
{
    sec = 1;
//    if([deptList count]>0)
//        sec += 1;
    if([addRestList count]>0)
        sec += 1;
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
    
    NSLog(@"viewdidload");
    //
    self.title = @"즐겨찾기 편집";//[NSString stringWithFormat:@"즐겨찾기 %d",[[ResourceLoader sharedInstance].favoriteList count]];
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:YES alarm:NO];
//    UIButton *button;
//    UIBarButtonItem *btnNavi;
//    
//    
//    button = [CustomUIKit closeButtonWithTarget:self selector:@selector(closeView)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
        UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"closeglobebtn.png" target:self selector:@selector(closeView)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    memberView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,0)];
    memberView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    [self.view addSubview:memberView];
    memberView.userInteractionEnabled = YES;
//    [memberView release];
    
    memberCountLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"즐겨찾기 멤버 %d명",(int)[[ResourceLoader sharedInstance].favoriteList count]] fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(5, 0, 120, memberView.frame.size.height) numberOfLines:1 alignText:UITextAlignmentLeft];
    [memberView addSubview:memberCountLabel];
    
    detailMember = [[UIImageView alloc]initWithFrame:CGRectMake(320-20,16,7,11)];
    detailMember.image = [UIImage imageNamed:@"n06_nocal_ary.png"];
    [memberView addSubview:detailMember];
//    [detailMember release];
    
    viewMemberLabel = [CustomUIKit labelWithText:@"전체보기" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(320-5-20-5-100, 0, 100, memberView.frame.size.height) numberOfLines:1 alignText:UITextAlignmentRight];
    [memberView addSubview:viewMemberLabel];
    
    
    UIButton *viewMemberButton;
    viewMemberButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewMember:) frame:CGRectMake(0,0, memberView.frame.size.width, memberView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [memberView addSubview:viewMemberButton];
//    [viewMemberButton release];
    
    
    
    
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0,0+memberView.frame.size.height,320,45)];
    searchView.backgroundColor = RGB(242,242,242);
    [self.view addSubview:searchView];
//    [searchView release];
    
	searching = NO;
	search = [[UISearchBar alloc]init];
    search.frame = CGRectMake(0,0,320,44);
    search.layer.borderWidth = 1;
    search.layer.borderColor = [RGB(242,242,242) CGColor];
//	search.tintColor = RGB(248, 248, 248);//RGB(136, 122, 112);
	
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
    
    CGRect rect = search.frame;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-2,rect.size.width, 2)];
    lineView.backgroundColor = RGB(242,242,242);
    [search addSubview:lineView];
//    [lineView release];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];
    //  search.tintColor = RGB(183, 186, 165);
	search.placeholder = @"멤버 검색";
	[searchView addSubview:search];
//    [search release];
	search.delegate = self;
    
//    localContactButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(selectLocal) frame:CGRectMake(4, 0+6, 98, 33)
//                             imageNamedBullet:nil imageNamedNormal:@"button_searchlocaladdress.png" imageNamedPressed:nil];
//    [searchView addSubview:localContactButton];
	
    
	myTable = [[UITableView alloc]init];
    
    
    myTable.frame = CGRectMake(0, 0+searchView.frame.size.height + memberView.frame.size.height, 320, self.view.frame.size.height - searchView.frame.size.height - memberView.frame.size.height - 0);
    
    
	myTable.dataSource = self;
	myTable.delegate = self;
	myTable.rowHeight = 50;
	[self.view addSubview:myTable];
//    [myTable release];
	//    myTable.scrollsToTop = YES;
    
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	
	myList = [[NSMutableArray alloc]init];
    deptList = [[NSMutableArray alloc]init];
    addRestList = [[NSMutableArray alloc]init];
    
    
    [addRestList removeAllObjects];
    [deptList removeAllObjects];
    
    NSString *mydeptcode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
    
    for(NSDictionary *dic in [[ResourceLoader sharedInstance] allContactList]){
        NSString *deptcode = dic[@"deptcode"];
		if([deptcode isEqualToString:mydeptcode])
            [deptList addObject:dic];
//        else
//            [addRestList addObject:dic];
    }
    
    
    for(int i = 0; i < [deptList count]; i++){
        NSString *aUid = deptList[i][@"uniqueid"];
        if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
            [deptList removeObjectAtIndex:i];
    }
    
    [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
    
    for(int i = 0; i < [myList count]; i++){
        NSString *aUid = myList[i][@"uniqueid"];
        if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
            [myList removeObjectAtIndex:i];
    }
    
    [addRestList setArray:myList];
    
    
    [myTable reloadData];
	[self reloadCheck];
	copyList = [[NSMutableArray alloc]init];
	
}

#define kFavoriteMember 7

- (void)viewMember:(id)sender{
    NSLog(@"[ResourceLoader sharedInstance].favoriteList %@",[ResourceLoader sharedInstance].favoriteList);
    if([[ResourceLoader sharedInstance].favoriteList count]==0)
        return;
    
    
    EmptyViewController *controller = [[EmptyViewController alloc]initWithList:[ResourceLoader sharedInstance].favoriteList from:kFavoriteMember];
    [controller setDelegate:self selector:@selector(confirmArray:)];
//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    
    if(![self.navigationController.topViewController isKindOfClass:[controller class]])
    [self.navigationController pushViewController:controller animated:YES];
//    [SharedAppDelegate.root presentViewController:nc animated:YES completion:nil];
    
//    [controller release];
//    [nc release];
    
}


- (void)confirmArray :(NSMutableArray *)list{
    
    NSLog(@"confirmArray %@",list);
    //        for(NSDictionary *dic in list){
    //            [self checkAdd:dic[@"uniqueid"]];
    //        }
    //
    //        [myTable reloadData];
    
    
    if(searching && [copyList count]>0){
        for(int i = 0; i < [list count]; i++)
        {
            NSDictionary *aDic = list[i];
            NSString *aUid = aDic[@"uniqueid"];
            for(int j = 0; j < [copyList count]; j++){
                NSString *chkUid = copyList[j][@"uniqueid"];
                if([aUid isEqualToString:chkUid])
                {
                    [copyList replaceObjectAtIndex:j withObject:aDic];
                    
                }
            }
        }
    }
    
    [self reloadCheck];
    
    
    
}

- (void)reloadCheck{
    NSLog(@"reloadCHeck");
    

    
    if([[ResourceLoader sharedInstance].favoriteList count]>0){
        
        memberCountLabel.text = [NSString stringWithFormat:@"즐겨찾기 멤버 %d명",(int)[[ResourceLoader sharedInstance].favoriteList count]];
        memberView.frame = CGRectMake(0, memberView.frame.origin.y, 320, 45);
        UIButton *viewMemberButton;
        viewMemberButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewMember:) frame:CGRectMake(0,0, memberView.frame.size.width, memberView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [memberView addSubview:viewMemberButton];
//        [viewMemberButton release];
    }
    else{
        
        memberView.frame = CGRectMake(0, memberView.frame.origin.y, 320, 0);
        
    }
    
    
    searchView.frame = CGRectMake(0,memberView.frame.origin.y+memberView.frame.size.height,320,45);
    
    
	    myTable.frame = CGRectMake(0, memberView.frame.origin.y+searchView.frame.size.height + memberView.frame.size.height, 320, self.view.frame.size.height - searchView.frame.size.height - memberView.frame.size.height-memberView.frame.origin.y); // 네비(44px) + 상태바(20px)
	
    
    memberCountLabel.frame = CGRectMake(5, 0, 120, memberView.frame.size.height);
    detailMember.frame = CGRectMake(320-20,16,7,11);
    viewMemberLabel.frame = CGRectMake(320-5-20-5-100, 0, 100, memberView.frame.size.height);
    
    
//    self.title = [NSString stringWithFormat:@"즐겨찾기 %d",[[ResourceLoader sharedInstance].favoriteList count]];
}


//#define kSearch 1
//- (void)selectLocal{
//    
//    LocalContactViewController *localController = [[LocalContactViewController alloc] initWithTag:kSearch];
//  UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:localController];
//    [self presentViewController:nc animated:YES completion:nil];
////    [localController release];
////    [nc release];
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    if(searching)
//        return nil;
//    else{
////        if(section == 0){
////            return @"내 휴대폰 주소록";
////        }
////        else
//        if(section == 1-1){
////           if([deptList count]>0)
////           {
//               return [NSString stringWithFormat:@"내 부서: %@",[SharedAppDelegate readPlist:@"myinfo"][@"deptname"]];
////           }
////           else{
////               if([addRestList count]>0)
////                   return @"모든 직원";
////               else
////                   return nil;
////           }
//        }
//            else if(section == 2-1)
//    {
//        if([addRestList count]>0)
//            return @"모든 직원";
//        
//    }
//    }
//        return nil;
//   
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
    if(searching)
        return 0;
    else
        return 28;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    viewHeader.backgroundColor = RGB(249, 249, 249);
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, 3, 320-12, 22)];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:14]];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
 NSString *headerTitle = @"";
   
    if(searching)
        headerTitle = @"";
    else{
        //        if(section == 0){
        //            return @"내 휴대폰 주소록";
        //        }
        //        else
        if(section == 1-1){
            //           if([deptList count]>0)
            //           {
            
//            NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
            headerTitle = [NSString stringWithFormat:@"내 부서: %@ (%d명)",[SharedAppDelegate readPlist:@"myinfo"][@"team"],(int)[deptList count]];
//            headerTitle = [NSString stringWithFormat:@"내 부서: %@",[SharedAppDelegate readPlist:@"myinfo"][@"deptname"]];
            //           }
            //           else{
            //               if([addRestList count]>0)
            //                   return @"모든 직원";
            //               else
            //                   return nil;
            //           }
        }
        else if(section == 2-1)
        {
            if([addRestList count]>0)
            {
                
                headerTitle = [NSString stringWithFormat:@"모든 직원 (%d명)",(int)[addRestList count]];
                
//                headerTitle = @"모든 직원";
            }
            
        }
    }
    
    lblTitle.text = headerTitle;
    
    [viewHeader addSubview:lblTitle];
    return viewHeader;
}
- (void)closeView
{
	if (self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[(CBNavigationController*)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
	}
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
//            [self settingDisableViewOverlay:2];
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
    
    
    if(searching){
//        if([[[copyListobjectatindex:indexPath.row]objectForKey:@"favorite"]isEqualToString:@"1"])
            [self addOrClear:copyList[indexPath.row]];
    }
    else{
//        if(indexPath.section == 0){
//            
//            LocalContactViewController *controller = [[LocalContactViewController alloc]init];
//            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
//            [self presentModalViewController:nc animated:YES];
//            [controller release];
//            [nc release];
//        }
//        else
        if(indexPath.section == 1-1){
            if([deptList count]>0)
                            [self addOrClear:deptList[indexPath.row]];
//            else if([addRestList count]>0)
//                [self addOrClear:addRestList[indexPath.row]];
        }
        else{
            if([addRestList count]>0)
                [self addOrClear:addRestList[indexPath.row]];
        }
    }
    
}


- (void)addOrClear:(NSDictionary *)d
{
    NSLog(@"addOrClear %@",d);
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    if(progressing)
        return;
    
    
    progressing = YES;
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:d];
    

    
    NSString *type = @"";
    
    //            }
    if([dic[@"favorite"]isEqualToString:@"0"]){
//        [SharedAppDelegate.root updateFavorite:@"1" uniqueid:[dicobjectForKey:@"uniqueid"]];
        [self reloadList:dic[@"uniqueid"] fav:@"1"];
        type = @"1";
        
    }
    else{
//        [SharedAppDelegate.root updateFavorite:@"0" uniqueid:[dicobjectForKey:@"uniqueid"]];
        [self reloadList:dic[@"uniqueid"] fav:@"0"];
        type = @"2";
        
    }

//     AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mirae.lemp.co.kr/"]];

    
    NSString *urlString = [NSString stringWithFormat:@"https://mirae.lemp.co.kr/lemp/info/setfavorite.lemp"];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{
                                 @"type" : type,
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
                                 @"member" : dic[@"uniqueid"],
                                 @"category" : @"1",
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey
                                 };
    NSLog(@"parameter %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        progressing = NO;
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
            
            [self reloadCheck];
        }
        else {
            
            
//            [SharedAppDelegate.root updateFavorite:[dicobjectForKey:@"favorite"] uniqueid:[dicobjectForKey:@"uniqueid"]];
            [self reloadList:dic[@"uniqueid"] fav:dic[@"favorite"]];
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressing = NO;
        
//        [SharedAppDelegate.root updateFavorite:[dicobjectForKey:@"favorite"] uniqueid:[dicobjectForKey:@"uniqueid"]];
        [self reloadList:dic[@"uniqueid"] fav:dic[@"favorite"]];
        
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"즐겨찾기 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
		[HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
//    [dic release];
    
}

- (void)reloadList:(NSString *)uid fav:(NSString *)fav{
   
//    NSString *fav = @"0";
//    
//    if([opposite isEqualToString:@"0"])
//    {
//        fav = @"1";
//    }
//    else{
//        fav = @"0";
//    }
    
    NSLog(@"ReloadList %@ %@",uid,fav);
    
//    if(searching){
        for(int j = 0; j<[copyList count];j++)
        {
            NSDictionary *aDic = copyList[j];
            NSString *aUid = aDic[@"uniqueid"];
            if([uid isEqualToString:aUid])
            {
                NSLog(@"searching %@",fav);
                NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:@"favorite"];
                [copyList replaceObjectAtIndex:j withObject:newDic];
            }
        }

//    }
//    else{
    
        for(int j = 0; j<[deptList count];j++)
        {
            NSDictionary *aDic = deptList[j];
            if([uid isEqualToString:deptList[j][@"uniqueid"]])
            {
                NSLog(@"deptList %@",fav);
                NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:@"favorite"];
                [deptList replaceObjectAtIndex:j withObject:newDic];
            }
        }
        
        for(int j = 0; j<[addRestList count];j++)
        {
            NSDictionary *aDic = addRestList[j];
            NSString *aUid = addRestList[j][@"uniqueid"];
            if([uid isEqualToString:aUid])
            {
                NSLog(@"addRestList %@",fav);
                NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:@"favorite"];
                [addRestList replaceObjectAtIndex:j withObject:newDic];
            }
        }
        

//    }
    
    for(int j = 0; j<[myList count];j++)
    {
        NSDictionary *aDic = myList[j];
        NSString *aUid = myList[j][@"uniqueid"];
        if([uid isEqualToString:aUid])
        {
            NSLog(@"myList %@",fav);
            NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:@"favorite"];
            [myList replaceObjectAtIndex:j withObject:newDic];
        }
    }
    
    [myTable reloadData];
}


    

// 뷰가 나타날 때마다 호출
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    progressing = NO;
    
    NSLog(@"viewwillappear");
    
    [addRestList removeAllObjects];
    [deptList removeAllObjects];
    
    NSString *mydeptcode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
    
    for(NSDictionary *dic in [[ResourceLoader sharedInstance] allContactList]){
        NSString *deptcode = dic[@"deptcode"];
        if([deptcode isEqualToString:mydeptcode])
            [deptList addObject:dic];
//        else
//            [addRestList addObject:dic];
        
        
    }
    
    
    for(int i = 0; i < [deptList count]; i++){
        NSString *aUid = deptList[i][@"uniqueid"];
        if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
            [deptList removeObjectAtIndex:i];
    }
    
    [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
    
    for(int i = 0; i < [myList count]; i++){
        NSString *aUid = myList[i][@"uniqueid"];
        if([aUid isEqualToString:[ResourceLoader sharedInstance].myUID])
            [myList removeObjectAtIndex:i];
    }
    [addRestList setArray:myList];
    
    
    NSLog(@"searching %@",searching?@"YES":@"NO");
    
    
    
    
    [myTable reloadData];
    [self reloadCheck];
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
		
    
    UILabel *name, *team, *lblStatus;
//    UIButton *invite;
    UIImageView *profileView, *disableView;
    UIImageView *checkView;
    
    UIImageView *roundingView;
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(40,0,50,50)];
        profileView.tag = 1;
        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        
        
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(40+55, 5, 220, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:15];
//        name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
//        [name release];
        
        
        team = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, 20)];
        team.font = [UIFont systemFontOfSize:12];
        team.textColor = [UIColor grayColor];
        team.backgroundColor = [UIColor clearColor];
        team.tag = 3;
        [cell.contentView addSubview:team];
//        [team release];
        
        
        disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
        disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//        disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
//        disableView.backgroundColor = RGBA(0,0,0,0.64);
        disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
        [profileView addSubview:disableView];
        disableView.tag = 11;
//        [disableView release];
        
        
        lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
        lblStatus.font = [UIFont systemFontOfSize:12];
        lblStatus.textColor = [UIColor whiteColor];
        lblStatus.textAlignment = UITextAlignmentCenter;
        lblStatus.backgroundColor = [UIColor clearColor];
        lblStatus.tag = 6;
        [disableView addSubview:lblStatus];
//        [lblStatus release];
        
        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
        checkView.tag = 5;
        [cell.contentView addSubview:checkView];
//        [checkView release];
        
//        invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 8, 57, 32)];
//        [invite setBackgroundImage:[CustomUIKit customImageNamed:@"installplz_btn.png"] forState:UIControlStateNormal];
//        [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
//        invite.tag = 4;
//        [cell.contentView addSubview:invite];
//        [invite release];
        
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileView addSubview:roundingView];
        roundingView.tag = 10;
//        [roundingView release];
        
        
    }
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        roundingView = (UIImageView *)[cell viewWithTag:10];
        name = (UILabel *)[cell viewWithTag:2];
        //            position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:3];
        disableView = (UIImageView *)[cell viewWithTag:11];
        lblStatus = (UILabel *)[cell viewWithTag:6];
        checkView = (UIImageView *)[cell viewWithTag:5];
//        invite = (UIButton *)[cell viewWithTag:4];
    }
	profileView.image = nil;
    NSDictionary *dic = nil;
    if(searching)
    {
        dic = copyList[indexPath.row];
           }
    else
    {
        

        if(indexPath.section == 1-1){
            
            if([deptList count]>0){
                        dic = deptList[indexPath.row];

            }
            else{
                dic = nil;
                profileView.image = nil;
                name.frame = CGRectMake(15, 14, 290, 20);
                name.font = [UIFont boldSystemFontOfSize:13];
                name.text = @"내 부서에 등록된 나 이외의 직원이 없습니다.";
                team.text = @"";
                name.textAlignment = UITextAlignmentCenter;
                name.textColor = [UIColor grayColor];
                lblStatus.text = @"";
                checkView.image = nil;
                disableView.hidden = YES;
                //                    invite.hidden = YES;
                

            }
//                else if([addRestList count]>0){
//                    
//                    [SharedAppDelegate.root getProfileImageWithURL:addRestList[indexPath.row][@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
//                    name.frame = CGRectMake(40+55, 14, 115, 20);
//                    name.font = [UIFont systemFontOfSize:15];
//                    name.text = [addRestList[indexPath.row][@"name"]stringByAppendingFormat:@" %@",addRestList[indexPath.row][@"grade2"]];//?[[addRestListobjectatindex:indexPath.row]objectForKey:@"grade2"]:[[addRestListobjectatindex:indexPath.row]objectForKey:@"position"]];
//                    team.text = addRestList[indexPath.row][@"team"];
//                    CGSize size = [name.text sizeWithFont:name.font];
//                    team.frame = CGRectMake(name.frame.origin.x + (size.width+5>115?115:size.width+5), name.frame.origin.y, 160-(size.width+5>115?115:size.width+5), 20);
//                  
//                    
////                    invite.titleLabel.text = addRestList[indexPath.row][@"uniqueid"];
//                    
//                    if([addRestList[indexPath.row][@"available"]isEqualToString:@"0"])
//                    {
//						lblStatus.text = @"미설치";
//                        
////                        if([[SharedAppDelegate.root getPureNumbers:addRestList[indexPath.row][@"cellphone"]]length]>9)
////							invite.hidden = NO;// lblStatus.text = @"미설치";
////                        else
////                            invite.hidden = YES;
//                    }
//                    else if([addRestList[indexPath.row][@"available"]isEqualToString:@"4"]){
//                        lblStatus.text = @"로그아웃";
////                        invite.hidden = YES;
//                    }
//                    else{
////                        invite.hidden = YES; //lblStatus.text = @"";
//                        
//                        lblStatus.text = @"";
//                    }
//                    if([addRestList[indexPath.row][@"favorite"]isEqualToString:@"1"]){
//                        [MBProgressHUD hideHUDForView:checkView animated:YES];
//                        checkView.image = [CustomUIKit customImageNamed:@"favorite_prs.png"];
//                    }
////                    else if([[[addRestListobjectatindex:indexPath.row]objectForKey:@"favorite"]isEqualToString:@"2"]){
////                           [MBProgressHUD showHUDAddedTo:checkView label:nil animated:YES];
////                        
////                    }
//                    else{
//                        [MBProgressHUD hideHUDForView:checkView animated:YES];
//                        checkView.image = [CustomUIKit customImageNamed:@"favorite_dtt.png"];
//                    }
//                }
            }
        else if(indexPath.section == 2-1){
            if([addRestList count]>0){
                        dic = addRestList[indexPath.row];
    
            
            
            }
        }
        
        
    }
    
    if(dic != nil){
        name.textAlignment = UITextAlignmentLeft;
        name.textColor = [UIColor blackColor];
    [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"imageview_organize_defaultprofile.png" view:profileView scale:0];
    
    //        name.frame = CGRectMake(40+55, 14, 115, 20);
    name.font = [UIFont systemFontOfSize:15];
    //        name.text = [copyList[indexPath.row][@"name"] stringByAppendingFormat:@" %@",copyList[indexPath.row][@"grade2"]];//?[[copyListobjectatindex:indexPath.row]objectForKey:@"grade2"]:[[copyListobjectatindex:indexPath.row]objectForKey:@"position"]];
    
    //        team.text = copyList[indexPath.row][@"team"];
    //        CGSize size = [name.text sizeWithFont:name.font];
    //        team.frame = CGRectMake(name.frame.origin.x + (size.width+5>115?115:size.width+5), name.frame.origin.y, 160-(size.width+5>115?115:size.width+5), 20);
    //      invite.titleLabel.text = copyList[indexPath.row][@"uniqueid"];
    
    
    name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    //        name.frame = CGRectMake(40+55, 5, 195-50, 20);
    //        team.text = [NSString stringWithFormat:@"%@ | %@",copyList[indexPath.row][@"grade2"],copyList[indexPath.row][@"team"]];
    
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
    
    name.frame = CGRectMake(40+55, 5, 220, 20);
    team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, 20);
    
    //        team.text = copyList[indexPath.row][@"team"];
    //        team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
    
    
    
    
    if([dic[@"available"]isEqualToString:@"0"])
    {
        disableView.hidden = NO;
        lblStatus.text = @"미설치";
        
        //            if([[SharedAppDelegate.root getPureNumbers:copyList[indexPath.row][@"cellphone"]]length]>9)
        //            invite.hidden = NO;
        //            else
        //                invite.hidden = YES;
    }
    else if([dic[@"available"]isEqualToString:@"4"]){
        lblStatus.text = @"로그아웃";
        disableView.hidden = NO;
        //            invite.hidden = YES;
    }
    else
    {
        //            invite.hidden = YES;
        lblStatus.text = @"";
        disableView.hidden = YES;
    } //            lblStatus.text = @"";
    
    if([dic[@"favorite"]isEqualToString:@"1"]){
//        [MBProgressHUD hideHUDForView:checkView animated:YES];
        [SVProgressHUD dismiss];
        checkView.image = [CustomUIKit customImageNamed:@"favorite_prs.png"];
    }
    //        else if([[[copyListobjectatindex:indexPath.row]objectForKey:@"favorite"]isEqualToString:@"2"]){
    //            [MBProgressHUD showHUDAddedTo:checkView label:nil animated:YES];
    //        }
    else{
//        [MBProgressHUD hideHUDForView:checkView animated:YES];
        [SVProgressHUD dismiss];
        checkView.image = [CustomUIKit customImageNamed:@"favorite_dtt.png"];
    }
    }
		return cell;
		
}

    - (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
//		 Releases the view if it doesn't have a superview.
		[super didReceiveMemoryWarning];
		
		// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
		[super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
//		[myTable release];
//		[myList release];
//    [copyList release];
}


- (void)dealloc {
    
    
//		[super dealloc];
}

@end
