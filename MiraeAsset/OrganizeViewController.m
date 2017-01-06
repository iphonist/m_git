//
//  OrganizeViewController.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 12..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import "OrganizeViewController.h"
//#import "UIImageView+AsyncAndCache.h"

@implementation OrganizeViewController

@synthesize addArray, selectCodeList;
@synthesize tagInfo;
#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (id)init
{
		self = [super init];
		if(self != nil)
		{
            myList = [[NSMutableArray alloc]init];
            selectCodeList = [[NSMutableArray alloc]init];
            addArray = [[NSMutableArray alloc]init];
			subPeopleList = [[NSMutableArray alloc]init];
            subList = [[NSMutableArray alloc]init];

			select = NO;
			
            self.view.backgroundColor = RGB(246,246,246);//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n01_tl_background.png"]];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfiles) name:@"refreshProfiles" object:nil];

		}
		return self;
}

- (void)refreshProfiles
{
	[myTable reloadData];
}
//- (void)settingDisableViewOverlay:(int)t
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 태그에 따라 뒤에 불투명한 뷰를 크기를 조정해 붙이거나 떼어준다.
//     param - t(int) : 태그
//     연관화면 : 검색/상세정보/고객상세정보
//     ****************************************************************/
//    
//		/*
//		 t=1:addSubview
//		 t=2:removeFromsuperview
//		 */
//		
////		id AppID = [[UIApplication sharedApplication]delegate];
////		if(t ==1)
////				[self.view addSubview:[AppID showDisableViewX:0 Y:search.frame.size.height W:320 H:480-kSTATUS_HEIGHT-kNAVIBAR_HEIGHT-search.frame.size.height]];
////		
////		else if(t ==3)
////				[self.view addSubview:[AppID showDisableViewX:0 Y:0 W:320 H:480-kSTATUS_HEIGHT-kNAVIBAR_HEIGHT]];
////		
////		else if(t ==2)
////				[AppID hideDisableView];
//}


//#define kSearch 2
//#define kEmployeInfo 10
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    
//    if(buttonIndex == 1)
//    {
//        // 이름 부서 검색
//        [SharedAppDelegate.root loadSearch:kSearch];
//    }
//    else if(buttonIndex == 2){
//        // 업무 검색
//        
//        [SharedAppDelegate.root loadSearch:kEmployeInfo];
//        
//    }
//    
//}
//
//
#define kOrganize 4
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    
    [SharedAppDelegate.root loadSearch:kOrganize];
    
    
    return NO;
}
//- (void)loadSearch{
//    
//    [SharedAppDelegate.root loadSearch:kOrganize];
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 검색바를 터치하는 순간 들어오는 함수. 뒤의 화면을 불투명하게 해 주고 초성배열을 만든다.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    [SharedAppDelegate.root loadSearch:kSearch con:self];
//    
//
//    
////    if(searching)
////        return;
////    
////    
////    // 다른 어플들은, 서치바 클릭하는 순간, 뒤에 뷰는 터치가 불가능.	& 네비게이션 바가 사라진다.	
////    
////    
////    id AppID = [[UIApplication sharedApplication]delegate];
////    [self settingDisableViewOverlay:1];
////    
////    
////    [searchBar setShowsCancelButton:YES animated:YES];
////    
////    myTable.userInteractionEnabled = NO;	
////    
////    NSString *name = @"";//[[NSString alloc]init];
////    chosungArray = [[NSMutableArray alloc]init];
////    for(NSDictionary *forDic in originList)//int i = 0 ; i < [originList count] ; i ++)
////    {
////        name = [forDicobjectForKey:@"name"];
////        NSString *str = [AppID GetUTF8String:name];
////        [chosungArray addObject:str];
////    }
////    
////    searching = YES;
////    
//}
//
//
//
//
//- (void)enableCancelButton:(UISearchBar *)searchBar
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 취소 버튼을 활성화 시킴.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    		NSLog(@"enablecancelbutton");
//    for (id subview in [searchBar subviews])
//    {
//        if([subview isKindOfClass:[UIButton class]])
//        {
//            [subview setEnabled:TRUE];
//        }
//    }
//}
//
//
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // 터치바에 글자 쓰기
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 검색바에 글자를 썼을 때 들어오는 함수. 들어온 스트링을 검색해 copyList라는 임시 검색결과배열에 추가한다.
//     param - searchBar(UISearchBar *) : 검색바 
//           - searchText(NSString *) : 검색하는 스트링
//     연관화면 : 검색
//     ****************************************************************/
//    
//    		NSLog(@"textdidchange");
//    [copyList removeAllObjects];
//    
//    
//    
//    if([searchText length]>0)
//    {
//        id AppID = [[UIApplication sharedApplication]delegate];
//        
//        
//        NSDictionary *temp;// = [[NSDictionary alloc]init];
////        [self settingDisableViewOverlay:2];
//        
//        myTable.userInteractionEnabled = YES;	
//        searching = YES;
//        for(int i = 0 ; i < [chosungArray count] ; i++)
//        {
//            if([[chosungArrayobjectatindex:i] rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
//               || [[[originListobjectatindex:i]objectForKey:@"name"] rangeOfString:searchText].location != NSNotFound // 이름에 searchText가 있느냐
//               || [[AppID getPureNumbers:[[originListobjectatindex:i]objectForKey:@"cellphone"]] rangeOfString:searchText].location != NSNotFound // 핸드폰/집/회사 번호에 searchText가 있느냐
//               || [[AppID getPureNumbers:[[originListobjectatindex:i]objectForKey:@"companyphone"]] rangeOfString:searchText].location != NSNotFound
//               || [[[originListobjectatindex:i]objectForKey:@"team"] rangeOfString:searchText].location != NSNotFound)
//            {	
//                
//                temp = [NSDictionary dictionaryWithDictionary:[originListobjectatindex:i]];
//                [copyList addObject:temp];
//                
//            }
//        }
//    }
//    
//    else 
//    {					
//        				NSLog(@"text not exist");
//        
//        [searchBar becomeFirstResponder];
////        [self settingDisableViewOverlay:1];				
//        myTable.userInteractionEnabled = NO;
//        searching = NO;
//        
//    }
//    
//    [myTable reloadData];		
//    
//}
//
//
//
//// 취소 버튼 누르면 키보드 내려가기
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 취소 버튼을 눌렀을 때 들어오는 함수. 취소버튼을 없애고, 키보드를 내리고, 불투명한 뷰를 뗀다.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    		NSLog(@"cancelbuttonclicked");
//    
//    
//    [searchBar setShowsCancelButton:NO animated:YES];
//    
//    searchBar.text = @"";
//    [searchBar resignFirstResponder]; // 키보드 내리기
//    
//    searching = NO;
//    myTable.userInteractionEnabled = YES;	
////    [self settingDisableViewOverlay:2];
//    [myTable reloadData];
//}
//
//
//// 키보드의 검색 버튼을 누르면
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 검색 버튼을 눌렀을 때. 키보드를 내리고, 취소 버튼은 그대로 두고, 테이블뷰를 사용할 수 있게 한다.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    
//    		NSLog(@"searchbuttonclicked");
//    
//    search.showsCancelButton = YES;
//    searching = YES;
//    
//    [searchBar resignFirstResponder];
//    
////    [self settingDisableViewOverlay:2];
//    myTable.userInteractionEnabled = YES;
//    
//      [self performSelector:@selector(enableCancelButton:) withObject:searchBar afterDelay:0.0];
//   
//}







- (void)checkSameLevel:(NSString *)code
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 받은 조직코드가 parentcode인 조직들과, 받은 조직코드가 deptcode인 사람들을 찾는다.
     param - code(NSString *) : 조직코드
     연관화면 : 조직도
     ****************************************************************/
    
    
	//			id AppID = [[UIApplication sharedApplication]delegate];
    NSLog(@"checksamelevel %@",code);
	
	[myList removeAllObjects];
	
	NSMutableArray *tempArray = [[NSMutableArray alloc]init];
	[tempArray setArray:[ResourceLoader sharedInstance].deptList];
	
	for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
	{
		if([forDic[@"parentcode"] isEqualToString:code])
		{
			
			[myList addObject:forDic];
		}
	}
	
    
    
    self.title = @"조직도";


//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];

	[subPeopleList removeAllObjects];
	
    
    
	for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++) {
		if([[ResourceLoader sharedInstance].contactList[i][@"deptcode"] isEqualToString:code])
		{
			[subPeopleList addObject:[ResourceLoader sharedInstance].contactList[i]];
		}
	}
    
    NSLog(@"subpeoplelist %@",subPeopleList);
    
    [myTable reloadData];
	
    
}


- (void)setFirstButton
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도 최상위에서의 상단의 버튼들을 세팅한다.
     연관화면 : 조직도
     ****************************************************************/
    
//    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = nil;//btnNavi;
//    [btnNavi release];
    
    
    
//    button = [CustomUIKit closeRightButtonWithTarget:self selector:@selector(cancel)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];

    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadFavController) frame:CGRectMake(0, 0, 35, 32) 
//                         imageNamedBullet:nil imageNamedNormal:@"n09_gtalkcanlbt.png" imageNamedPressed:nil];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    
//    [button release];
    
    
}

- (void)setFirst:(NSString *)first
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도 최상위 타이틀을 세팅한다.
     param - first(NSString *) : 조직도 선택했을 때 첫 타이틀
     연관화면 : 조직도
     ****************************************************************/
    
    firstDept = first;
    
    
    self.title = @"조직도";

//    [SharedAppDelegate.root returnTitle:self.title viewcon:self];
		
		
}


- (void)reloadCheck
{
    NSLog(@"reloadCheck");
	
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도에서 하위단계로 내려갈 때마다 path를 보여주기 위한 함수.
     연관화면 : 조직도
     ****************************************************************/

    UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 40)];
//		groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    groupNameView.backgroundColor = RGB(229, 229, 226);
		[self.view addSubview:groupNameView];
		groupNameView.userInteractionEnabled = YES;
		
		if (scrollView) {
//			[scrollView release];
			scrollView = nil;
		}
		scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, groupNameView.frame.size.height)];
		scrollView.delegate = self;
		[groupNameView addSubview:scrollView];
    
		int w = 0;
		
		UILabel *addName;
		UIButton *addNameImage;
    UILabel *pathLabel;
//		UIImageView *pathImage;
    
				CGSize size;
    size = [@"홈" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    
    addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(3, 3, size.width + 15, groupNameView.frame.size.height-6)];
    addNameImage.tag = 100;
    [addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:addNameImage];
//    [addNameImage release];
    
    [addNameImage setBackgroundImage:[[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
    //						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_01.png"];
    
    addName = [CustomUIKit labelWithText:@"홈" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(3, 0, size.width + 10, addNameImage.frame.size.height) numberOfLines:1
                               alignText:UITextAlignmentCenter];
    
				[addNameImage addSubview:addName];
    
    w += 3+addNameImage.frame.size.width + 25;
    
    
    UILabel *firstPathLabel = [[UILabel alloc]init];
    //            pathLabel.backgroundColor = [UIColor blueColor];
    firstPathLabel.font = [UIFont systemFontOfSize:13];
    firstPathLabel.textAlignment = UITextAlignmentCenter;
    firstPathLabel.frame = CGRectMake(CGRectGetMaxX(addNameImage.frame) + 5, 0, 15, groupNameView.frame.size.height);
    [scrollView addSubview:firstPathLabel];
//    [firstPathLabel release];
    
		for(int i = 0; i < [self.addArray count]; i++)
        {
            firstPathLabel.text = @"〉";
            
            
				size = [self.addArray[i] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
		
            addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(w, 3, size.width + 15, groupNameView.frame.size.height-6)];
            addNameImage.tag = i;
			[addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:addNameImage];
//            [addNameImage release];
            scrollView.contentOffset = CGPointMake(w, groupNameView.frame.size.height);
				
            pathLabel = [[UILabel alloc]init];
//            pathLabel.backgroundColor = [UIColor blueColor];
            pathLabel.font = [UIFont systemFontOfSize:13];
            pathLabel.text = @"〉";
            pathLabel.textAlignment = UITextAlignmentCenter;
            pathLabel.frame = CGRectMake(CGRectGetMaxX(addNameImage.frame) + 5, 0, 15, groupNameView.frame.size.height);
            [scrollView addSubview:pathLabel];
//            [pathLabel release];
            
            
//				pathImage = [[UIImageView alloc]init];
//				pathImage.image = [CustomUIKit customImageNamed:@"arr_ic.png"];
				
				
				if(i == [self.addArray count]-1)
				{
                    
                    [addNameImage setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//                    [addNameImage setBackgroundImage:[CustomUIKit customImageNamed:@"adduser_02.png"] forState:UIControlStateNormal];
                    
//						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_02.png"];
						
						addName = [CustomUIKit labelWithText:self.addArray[i] fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(3, 0, size.width + 10, addNameImage.frame.size.height) numberOfLines:1
																			 alignText:UITextAlignmentCenter];
                    pathLabel.hidden = YES;
//						pathImage.hidden = YES;
				}
				else
                {
                    [addNameImage setBackgroundImage:[[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//                    [addNameImage setBackgroundImage:[CustomUIKit customImageNamed:@"adduser_01.png"] forState:UIControlStateNormal];
//						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_01.png"];
						
						addName = [CustomUIKit labelWithText:self.addArray[i] fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(3, 0, size.width + 10, addNameImage.frame.size.height) numberOfLines:1
																			 alignText:UITextAlignmentCenter];
//						pathImage.hidden = NO;
                    pathLabel.hidden = NO;
				}
            NSLog(@"addname %@ pathlabel %@",NSStringFromCGRect(addNameImage.frame),NSStringFromCGRect(pathLabel.frame));
				 w += addNameImage.frame.size.width + 25;
				
//				pathImage.frame = CGRectMake(16 + w + 27*i, 7, 10, 14);
//				[scrollView addSubview:pathImage];
				scrollView.contentSize = CGSizeMake(w - 25, groupNameView.frame.size.height);
				[addNameImage addSubview:addName];
//				[addNameImage release];
//            				[pathImage release];
				
		}
//		[groupNameView release];

}


- (void)warp:(id)sender
{
    
    if([sender tag]==100)
    {
        [self backTo];
        return;
    }
    
//    UIButton *button = (UIButton *)sender;
    NSLog(@"warp tag %d %@ %@",(int)[sender tag],self.addArray[(int)[sender tag]],selectCodeList[(int)[sender tag]]);
    int temp;
    temp = (int)[self.addArray count]-((int)[sender tag]+1);
    for(int i = 0; i < temp; i++)
    {
        [self upTo];
    }
    [self reloadCheck];
    
}

- (void)backAll{
    
    [(CBNavigationController*)self.navigationController popToRootViewControllerWithBlockGestureAnimated:YES];
}
- (void)backTo
{
    NSLog(@"backTo");
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 최상위의 네비게이션컨트롤러로.
     연관화면 : 없음
     ****************************************************************/
    
	[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
}

- (void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}
		
- (void)upTo
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도 하위단계에서 좌측 상단 버튼을 눌러 상위로 올라올 때.
     연관화면 : 조직도
     ****************************************************************/
    
//    if(pView)
//    {
//        [pView closePopup];
//        pView = nil;
//        [pView release];
//    }
    
    NSLog(@"taginfo %d",tagInfo);

		if(tagInfo == 0)
		{
            NSLog(@"0");
//				[CustomUIKit popupAlertViewOK:nil msg:@"최상위 그룹입니다."];
								return;

		}
    else if(tagInfo == 1)
    {
        NSLog(@"1");
        [self setFirstButton];
        NSLog(@"2");
        [self setFirst:firstDept];
        NSLog(@"3");
    }
    NSLog(@"4");
    myTable.contentOffset = CGPointMake(0, 0);
		
		[self checkSameLevel:self.selectCodeList[[self.selectCodeList count]-1]];
    
    NSLog(@"5");
		
		
		
		
    tagInfo --;
    NSLog(@"6");
    [self.selectCodeList removeLastObject];
    NSLog(@"7");
    [self.addArray removeLastObject];
    NSLog(@"8");
    [self reloadCheck];
    NSLog(@"9");
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;

    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSearch) frame:CGRectMake(0, 0, 21, 21) imageNamedBullet:nil imageNamedNormal:@"button_searchview_search.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];

    
    
    search = [[UISearchBar alloc]init];
    search.frame = CGRectMake(0,0,320,44);
    
    
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
    search.placeholder = @"이름(초성), 부서, 전화번호 검색"; // text 가 아닌 placeholder이다.
    [self.view addSubview:search];
    search.delegate = self;
    
    
    UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 40)];

     groupNameView.backgroundColor = RGB(229, 229, 226);

    [self.view addSubview:groupNameView];
//    [groupNameView release];
    
    NSLog(@"tabbar %f",self.tabBarController.tabBar.frame.size.height);
	myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 28+search.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height-groupNameView.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
	myTable.delegate = self;
	myTable.dataSource = self;
	myTable.rowHeight = 50;//60;
    
    float viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44 + 20;
    } else {
        viewY = 44;
        
    }
    
    myTable.frame = CGRectMake(0, search.frame.size.height + groupNameView.frame.size.height, 320, self.view.frame.size.height - search.frame.size.height - groupNameView.frame.size.height - viewY);
    
	
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	[self.view addSubview:myTable];
	
	[self setFirstButton];
	
}


- (void)showSearchPopup{
    
    UIAlertView *alert;
    //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
    alert = [[UIAlertView alloc] initWithTitle:@"검색방법" message:@"검색방법을 선택하세요." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"이름/부서 검색",@"업무내용 검색", nil];
    [alert show];
//    [alert release];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"OrganizeView willAppear %f",self.tabBarController.tabBar.frame.size.height);
    NSLog(@"addArray %@",self.addArray);
	NSLog(@"TAGINFO %d",tagInfo);

    self.navigationItem.hidesBackButton = YES;
    
    [self reloadCheck];
//    [self setFirstButton];
//		[myTable reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"OrganizeView viewWillDisappear");
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"OrganizeView viewDidDisappear");
    [super viewDidDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



//- (void)scrollViewWillBeginDragging:(UIScrollView *)s
//{
//    
//    
//    if([search isFirstResponder])
//    {
////        [self settingDisableViewOverlay:2];
//        [search resignFirstResponder];
//    }
//    				
//}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.


//    if(searching)
//    {
////        double temp = (double)[copyList count]/2;
//        return [copyList count];
//	}
//    else if(tableView == myTable)
//		{   	
//            int temp3 = [subPeopleList count] + [myList count];
            return [subPeopleList count] + [myList count];
//		}
//    else {
//        return 0;
//    }
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
    
    static NSString *CellIdentifier = @"Cell";
//		NSString *email;
    UILabel *name, *department, *team, *lblStatus; //*position,
    UIImageView *profileView, *bgView, *fav, *disableView;
//    UIButton *callButton;
    UIImageView *roundingView;

//		id AppID = [[UIApplication sharedApplication]delegate];
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
		
		if(cell == nil)
		{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
            profileView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            profileView.frame = CGRectMake(0, 0, 50, 50);//5, 10, 40, 40);
            profileView.tag = 1;
            profileView.image = nil;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            
            fav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            fav.tag = 8;
            fav.image = [CustomUIKit customImageNamed:@"favorites_bg.png"];
            [profileView addSubview:fav];
//            [fav release];
            
            name = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont systemFontOfSize:15];
//            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            department = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
            department.backgroundColor = [UIColor clearColor];
            department.font = [UIFont systemFontOfSize:15];
            //            name.adjustsFontSizeToFitWidth = YES;
            department.tag = 7;
            [cell.contentView addSubview:department];
//            [department release];
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(180, 14, 140, 20)];
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
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            
            
//            callButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(call:) frame:CGRectMake(320-39-7, 10, 39, 30) imageNamedBullet:nil imageNamedNormal:@"button_contact_call.png" imageNamedPressed:nil];
//            callButton.tag = 4;
//            [cell.contentView addSubview:callButton];
//            [invite release];
            
            bgView = [[UIImageView alloc]init];//WithFrame:CGRectMake(6,6,43,43)];
            bgView.tag = 5;
            cell.backgroundView = bgView;
//            [bgView release];
//            cell.backgroundColor = [UIColor blackColor];
            
//            infoBgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-5-103,profileView.frame.origin.y,103,40)];
//            infoBgView.tag = 10;
//            [cell.contentView addSubview:infoBgView];
////            [infoBgView release];
//            
//            info = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(12, 0, infoBgView.frame.size.width-15, infoBgView.frame.size.height) numberOfLines:2 alignText:UITextAlignmentLeft];
//            info.tag = 6;
//            [infoBgView addSubview:info];
//            [info release];
            
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileView addSubview:roundingView];
//            [roundingView release];
            roundingView.tag = 21;
            
            
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            fav = (UIImageView *)[cell viewWithTag:8];
            name = (UILabel *)[cell viewWithTag:2];
//            position = (UILabel *)[cell viewWithTag:3];
            team = (UILabel *)[cell viewWithTag:3];
//            callButton = (UIButton *)[cell viewWithTag:4];
            bgView = (UIImageView *)[cell viewWithTag:5];
//            info = (UILabel *)[cell viewWithTag:6];
            department = (UILabel *)[cell viewWithTag:7];
//            infoBgView = (UIImageView *)[cell viewWithTag:10];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:9];
            roundingView = (UIImageView *)[cell viewWithTag:21];
        }
//	profileView.image = nil;

        if(indexPath.row < [subPeopleList count])
        {
//            callButton.hidden = NO;
            NSDictionary *dic = subPeopleList[indexPath.row];
            bgView.backgroundColor = [UIColor whiteColor];
            
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"imageview_organize_defaultprofile.png" view:profileView scale:0];
            name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y + 5, 155, 20);
            
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
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
            
            
            
//            callButton.titleLabel.text = dic[@"uniqueid"];
//            [[invite layer] setValue:dic[@"cellphone"] forKey:@"cellphone"];
//            invite.titleLabel.text = dic[@"uniqueid"];
            
            if([dic[@"available"]isEqualToString:@"0"])
            {
                disableView.hidden = NO;
				lblStatus.text = @"미설치";
//				if([[SharedAppDelegate.root getPureNumbers:subPeopleList[indexPath.row][@"cellphone"]]length]>9)
//					callButton.hidden = NO;//                lblStatus.text = @"미설치";
//                infoBgView.hidden = YES;
//                info.text = @"";
                
			            }
            else if([dic[@"available"]isEqualToString:@"4"]){
                disableView.hidden = NO;
                lblStatus.text = @"로그아웃";
//                invite.hidden = YES;
//                infoBgView.hidden = NO;
//                infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info_logout.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//                info.text = dic[@"newfield1"];
//                CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:UILineBreakModeWordWrap];
//                info.frame = CGRectMake(10, 0, infoSize.width, 40);
//                infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
//                info.textColor = RGB(146, 146, 146);
//                NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//                if([newString length]<1){
//                    infoBgView.hidden = YES;
//                }
            }
            else
            {
                disableView.hidden = YES;
//                invite.hidden = YES;
				lblStatus.text = @"";
//                infoBgView.hidden = NO;
//                infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//                info.text = dic[@"newfield1"];
//                CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:UILineBreakModeWordWrap];
//                info.frame = CGRectMake(10, 0, infoSize.width, 40);
//                infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
//                              info.textColor = RGB(115, 149, 184);
//                NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//                if([newString length]<1){
//                    infoBgView.hidden = YES;
//                }
			}
			
            if([dic[@"favorite"]isEqualToString:@"0"])
                fav.hidden = YES;
            else
                fav.hidden = NO;
        }
        else
        {
            disableView.hidden = YES;
            name.frame = CGRectMake(13, 14, 250, 20);
            int subRow = (int)indexPath.row - (int)[subPeopleList count];
            profileView.image = nil;
//            profileView.frame = CGRectMake(10, 12, 34, 23);
//            profileView.image = [CustomUIKit customImageNamed:@"grp_icon.png"];
            
//			[SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"department_ic.png" view:profileView scale:0];
            department.text = @"";
            team.text = @"";
//            callButton.hidden = YES;
            lblStatus.text = @"";
            fav.hidden = YES;
//            info.text = @"";
//        infoBgView.hidden = YES;
//            cell.backgroundColor = [UIColor blackColor];//RGB(219,215,212);
            bgView.backgroundColor = [UIColor whiteColor];//RGB(219,215,212);//[CustomUIKit customImageNamed:@"gp_background.png"];
//            NSArray *array = [[[myList[subRow][@"shortname"] componentsSeparatedByString:@","];
//            name.frame = CGRectMake(10, 14, 200, 20);
//            name.font = [UIFont systemFontOfSize:18];
            name.text = myList[subRow][@"shortname"];//[arrayobjectatindex:[array count]-1];
            
        }
        
//    }
     return cell;
}


//- (void)saveImage:(NSDictionary *)dic
//{
//    
//               NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[dicobjectForKey:@"path"]]; 
//    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dicobjectForKey:@"urlString"]]];
//   
//    [imgData writeToFile:filePath atomically:YES];
//    
//    [imageThread cancel];
//    
////    if(imageThread)
////        SAFE_RELEASE(imageThread);
//}
- (void)invite:(id)sender{
    
    NSLog(@"invite %@",sender);
    
    if([[SharedFunctions getPureNumbers:[[sender layer]valueForKey:@"cellphone"]] length]>9){
//        [SharedAppDelegate.root invite:sender];
        
    }
    else{
        
        [CustomUIKit popupAlertViewOK:nil msg:@"멤버의 휴대폰 정보가 없어 설치요청\nSMS를 발송할 수 없습니다."];
        return;
        
    }
    
}
- (void)selectList:(int)rowOfButton
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직을 선택할 때마다 새로 세팅을 해 준다.
     param - sender(id) : tag를 이용해 몇 번째 조직인지 넘긴다.
     연관화면 : 조직도
     ****************************************************************/
    
		
//		int rowOfButton = [sender tag];
    myTable.contentOffset = CGPointMake(0, 0);
    
//    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(upTo)];
//
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = nil;//btnNavi;
//    [btnNavi release];
    
    
    
//    button = [CustomUIKit closeRightButtonWithTarget:self selector:@selector(cancel)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];

    
//    [button release];
    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadFavController) frame:CGRectMake(0, 0, 35, 32) 
//                         imageNamedBullet:nil imageNamedNormal:@"n09_gtalkcanlbt.png" imageNamedPressed:nil];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    
//    [button release];
    
		
    self.title = @"조직도";
    

//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
		[self.addArray addObject:myList[rowOfButton][@"shortname"]];
		[self reloadCheck];
		
	[subList removeAllObjects];
				
		
		NSMutableArray *tempArray = [[NSMutableArray alloc]init];
		[tempArray setArray:[ResourceLoader sharedInstance].deptList];
		
		
		for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
		{
				if([forDic[@"parentcode"] isEqualToString:myList[rowOfButton][@"mycode"]])
				{
						[subList addObject:forDic];
				}
		}
		 [self.selectCodeList addObject:myList[rowOfButton][@"parentcode"]];
		
    
    [tempArray setArray:[ResourceLoader sharedInstance].contactList];

		
		
	[subPeopleList removeAllObjects];
	

		for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
		{
				
				if([forDic[@"deptcode"] isEqualToString:myList[rowOfButton][@"mycode"]])
				{
						[subPeopleList addObject:forDic];
				}
		}

//    [tempArray release];
    NSLog(@"subPeopleList count %@",subPeopleList);
//    for(int i = 0; i < [subPeopleList count]; i++){
//        
//        NSLog(@"uid %@ uid %@",[[subPeopleListobjectatindex:i]objectForKey:@"uniqueid"],[ResourceLoader sharedInstance].myUID);
//        
//        if([[[subPeopleListobjectatindex:i]objectForKey:@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
//            [subPeopleList removeObjectAtIndex:i];
//        }
//    }
    NSLog(@"subPeopleList count %d",(int)[subPeopleList count]);
		
		[myList removeAllObjects];
		[myList setArray:subList];
		
		tagInfo++;
		
		[myTable reloadData];

}

- (void)loadFavController
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 우측상단에 즐겨찾기 버튼을 누르면 즐겨찾기 뷰컨트롤러를 호출.
     연관화면 : 즐겨찾기
     ****************************************************************/
    
//    FavoriteViewController *favController = [[FavoriteViewController alloc]init];
//    
//    [self.navigationController pushViewController:favController animated:YES]; // 현재는 임시로 푸쉬.
//    [favController release];
}


- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav{
    
        for(int i = 0; i < [subPeopleList count]; i++){
            if([subPeopleList[i][@"uniqueid"]isEqualToString:uid]){
                [subPeopleList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:subPeopleList[i] object:fav key:@"favorite"]];
            }
        }
    
    [myTable reloadData];
}


- (void)selectContact:(int)rowOfButton
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직이 아닌 사람을 선택했을 때 프로필을 띄워준다.
     param - sender(id) : tag를 이용해 몇 번째 사람인지 넘긴다.
     연관화면 : 조직도
     ****************************************************************/
    
    
    NSLog(@"OrganizeViewController selectContact %d sub count %d",rowOfButton,(int)[subPeopleList count]);
    
    
//    [self settingDisableViewOverlay:3];
    
//    if([[[subPeopleListobjectatindex:rowOfButton]objectForKey:@"available"]isEqualToString:@"0"])
//        return;
    
    [SharedAppDelegate.root settingYours:subPeopleList[rowOfButton][@"uniqueid"]];
//    [self dismissModalViewControllerAnimated:YES];
//    [SharedAppDelegate.root showSlidingViewAnimated:YES];
//    int rowOfButton = [sender tag];
    
    
//     pView = [[ProfileView alloc]initWithTag:100 other:1];
//    
//    if(searching)
//    {
//        [pView updateWithDic:[copyListobjectatindex:rowOfButton]];
//        [search resignFirstResponder];
//        
//    }
//    else{
//		[pView updateWithDic:[subPeopleListobjectatindex:rowOfButton]];
//		
//    }
//    [self.view addSubview:pView.view];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


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

    if(indexPath.row < [subPeopleList count])
    {
        [self selectContact:(int)indexPath.row];
    }
    else{
        int subRow = (int)indexPath.row - (int)[subPeopleList count];
        [self selectList:subRow];
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
    [super viewDidUnload];
}


- (void)dealloc {
//	if (scrollView) {
//		[scrollView release];
//	}
//	[myList release];
//	[search release];
//	[myTable release];
//	[subList release];
//	[subPeopleList release];
//    [selectCodeList release];
//    [addArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super dealloc];
    
}


@end

