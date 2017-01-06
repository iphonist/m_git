//
//  OptionViewController.m
//  LEMPMobile
//
//  Created by In-Gu Baek on 11. 8. 17..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "SubSetupViewController.h"
//#import <objc/runtime.h>
#import "GKImagePicker.h"
#import "PhotoViewController.h"
#import "QBImagePickerController.h"

#define PI 3.14159265358979323846

//static inline float radians(double degrees) { return degrees * PI / 180; }


@interface SubSetupViewController ()<GKImagePickerDelegate>

@end

const char paramDic;
@implementation SubSetupViewController
@synthesize myTable;


#define kSubStatus 100
#define kSubBell 300
#define kSubProgram 400
#define kSubPush 900

- (id)initFromWhere:(int)where
{
    self = [super init];
    if(self != nil)
    {
        NSLog(@"init where %d",where);
	
			myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStyleGrouped];
			if (where == kSubPush) {
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"refreshPushAlertStatus" object:nil];
			}
		
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        myTable.tag = where;
        NSLog(@"myTable %@ %d",myTable,(int)myTable.tag);
    }
    return self;
}

- (void)reloadTable
{
	[myTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewdidload");
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
//	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//	}
    self.view.backgroundColor = RGB(227, 227, 225);//[UIColor colorWithPatternImage:[CustomUIKit
    
    myTable.backgroundView = nil;
    myTable.delegate = self;
    myTable.dataSource = self;
    UIButton *leftButton = nil;
    NSLog(@"myTable %@ %d",myTable,(int)myTable.tag);
    
    
    
	myTable.sectionFooterHeight = 0.0;
    
    float viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44 + 20;
    } else {
        viewY = 44;
        
    }
    
    if (myTable.tag == kSubPush) {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		self.title = @"푸시알림";
		myList = [[NSMutableArray alloc]initWithObjects:@"푸시알림",nil];
		myTable.scrollEnabled = NO;
        
			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
	
		myTable.sectionFooterHeight = 80.0;
        [self.view addSubview:myTable];
	}
    
    else if(myTable.tag == kSubStatus){
        
        self.view.backgroundColor = RGB(242, 242, 242);
//        leftButton = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
        
        leftButton = [CustomUIKit emptyButtonWithTitle:@"closeglobebtn.png" target:self selector:@selector(cancel)];
      
        
        [self setMyInfo];
    }
    
    else if(myTable.tag == kSubBell)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
		NSArray *ringtones = plistDict[@"Ringtones"];
		
		NSString *bell = [SharedAppDelegate readPlist:@"bell"];
		NSMutableArray *bells = [NSMutableArray array];
		int loopCount = 0;
		bellPreSelect = 2;
		
		for (NSDictionary *dic in ringtones) {
			if ([bell isEqualToString:dic[@"filename"]]) {
				bellPreSelect = loopCount;
			}
			[bells addObject:dic];
			++loopCount;
		}
		
		myList = [[NSMutableArray alloc] initWithArray:bells];
		
//		if([[SharedAppDelegate readPlist:@"bell"]isEqualToString:@"ring01.caf"])
//			bellPreSelect = 0;
//		else if([[SharedAppDelegate readPlist:@"bell"]isEqualToString:@"ring02.caf"])
//            bellPreSelect = 1;
//		else if([[SharedAppDelegate readPlist:@"bell"]isEqualToString:@"1.wav"])
//            bellPreSelect = 2;
//        else if([[SharedAppDelegate readPlist:@"bell"]isEqualToString:@"2.wav"])
//            bellPreSelect = 3;
//        else if([[SharedAppDelegate readPlist:@"bell"]isEqualToString:@"3.wav"])
//            bellPreSelect = 4;
//        else if([[SharedAppDelegate readPlist:@"bell"]isEqualToString:@"silent.wav"])
//			bellPreSelect = 5;
//		else
//			bellPreSelect = 0;
		
        NSLog(@"bellPreselect %d",(int)bellPreSelect);
        myTable.scrollEnabled = YES;
//		myList = [[NSMutableArray alloc]initWithObjects:@"기본벨소리1",@"기본벨소리2",@"기본벨소리3",@"기본벨소리4",@"기본벨소리5",@"무음",nil];
//        myTable.frame = CGRectMake(0, 0, 320, [myList count]*[myTable rowHeight]);
//		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 20);
//		} else {
			myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
//		}
        self.title = @"벨소리 설정";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        [self.view addSubview:myTable];
    }
    else if(myTable.tag == kSubProgram)
    {
        leftButton = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
		self.title = @"프로그램 정보";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        
		CGFloat statusBarHeight = 0.0;
		CGFloat yStartOffset = 40.0;
		if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
			statusBarHeight = 20.0;
			yStartOffset = 30.0;
		}

        UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(320/2-81/2,yStartOffset,81,87)];

        logo.contentMode = UIViewContentModeScaleAspectFit;
        logo.image = [CustomUIKit customImageNamed:@"prefere_logo.png"];
        [self.view addSubview:logo];
        
        logo = [[UIImageView alloc]initWithFrame:CGRectMake(320/2-144/2,yStartOffset+87+25,144,17)];
        
        logo.contentMode = UIViewContentModeScaleAspectFit;
        logo.image = [CustomUIKit customImageNamed:@"imageview_navigationbar_logo.png"];
        [self.view addSubview:logo];
        
        
        UILabel *label = [CustomUIKit labelWithText:@"현재버전 : "
                                           fontSize:14 fontColor:[UIColor grayColor]
                                              frame:CGRectMake(80, CGRectGetMaxY(logo.frame)+15, 75, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
        [self.view addSubview:label];
        
        NSString *ver = [NSString stringWithFormat:@"ver %@ (%@)",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
        label = [CustomUIKit labelWithText:ver
                                           fontSize:14 fontColor:[UIColor blackColor]
                                              frame:CGRectMake(CGRectGetMaxX(label.frame)+5, label.frame.origin.y-3, 160, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
		[self.view addSubview:label];
        
//        label = [CustomUIKit labelWithText:@"최신버전 : "
//                                           fontSize:14 fontColor:[UIColor grayColor]
//                                              frame:CGRectMake(60, CGRectGetMaxY(logo.frame)+15+17, 75, 14) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        [self.view addSubview:label];
//        
//        ver = [NSString stringWithFormat:@"ver %@",[SharedAppDelegate readPlist:@"serverappver"]];
//        label = [CustomUIKit labelWithText:ver
//                                           fontSize:14 fontColor:[UIColor blackColor]
//                                              frame:CGRectMake(CGRectGetMaxX(label.frame)+5, label.frame.origin.y-3, 160, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        [self.view addSubview:label];
        
        
        UIButton *button;
      button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(goWeb) frame:CGRectMake(49, CGRectGetMaxY(label.frame)+10, 223, 0) imageNamedBullet:nil imageNamedNormal:@"prefere_jumpweb.png" imageNamedPressed:nil];
        [self.view addSubview:button];
       
//        
//        if ([[SharedAppDelegate readPlist:@"serverappver"] compare:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] options:NSNumericSearch] == NSOrderedDescending) {
//        
//            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(goUpdate) frame:CGRectMake(49, CGRectGetMaxY(label.frame)+10, 223, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//            [button setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//            [self.view addSubview:button];
//            [button release];
//        
//        
//        label = [CustomUIKit labelWithText:@"최신버전 다운로드" fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        
//        [button addSubview:label];
//        }

		
        myTable.scrollEnabled = NO;
		myList = [[NSMutableArray alloc]initWithObjects:@"오픈소스 라이선스",nil];//@"이용약관",@"개인정보 취급방침",nil];
        myTable.frame = CGRectMake(0, button.frame.origin.y + button.frame.size.height + 10, 320, 60*[myList count]);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            myTable.frame = CGRectMake(0, button.frame.origin.y + button.frame.size.height + 10 - 30, 320, 100*[myList count]);
        }
        myTable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:myTable];
        
        UIImageView *company = [[UIImageView alloc]init];//WithFrame:
        company.frame = CGRectMake(114-5, self.view.frame.size.height-99+statusBarHeight-25, 99, 33);
        company.contentMode = UIViewContentModeScaleAspectFit;
        company.image = [CustomUIKit customImageNamed:@"imageview_setuplogo.png"];
        [self.view addSubview:company];
   
        

    
    }

    
    
    
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = btnNavi;
 
    
    [myTable reloadData];
//    [myTable release];
}




- (void)setMyInfo{
    
    UIButton *leftButton = nil;
    
    
        leftButton = [CustomUIKit emptyButtonWithTitle:@"closeglobebtn.png" target:self selector:@selector(cancel)];
        
    
    
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = btnNavi;
  
    
      self.navigationItem.rightBarButtonItem = nil;
    
    self.title = @"내 프로필";
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];//[AppID readPlistDic];
    NSLog(@"dic %@",dic);
    UIButton *button;
    
    self.view.backgroundColor = RGB(227, 227, 225);
    
    if(transView){
        [transView removeFromSuperview];
 
        transView = nil;
    }
    transView = [[UIView alloc]init];
    transView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
//        transView.frame = CGRectMake(0, -20, 320, self.view.frame.size.height + 20);
//    }
    transView.userInteractionEnabled = YES;
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    NSLog(@"transView %@",NSStringFromCGRect(transView.frame));
    
    
    UIImageView *borderView;
    borderView = [[UIImageView alloc]init];
    borderView.frame = CGRectMake(21, 10, 278, 0);
    borderView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
    [transView addSubview:borderView];
    borderView.userInteractionEnabled = YES;
  
    
    profileView = [[UIImageView alloc] initWithFrame:CGRectMake(borderView.frame.size.width/2-31, 15, 63, 63)];
    profileView.userInteractionEnabled = YES;
    [borderView addSubview:profileView];
    //		[self reloadImage];
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"button_myinfo_setup_myprofile_default_profile.png" view:profileView scale:0];
    
    
    UIImageView *roundingView;
    roundingView = [[UIImageView alloc]init];
    roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
    roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
    [profileView addSubview:roundingView];

    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(imageActionSheet)
                                    frame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height) imageNamedBullet:nil
                         imageNamedNormal:nil imageNamedPressed:nil];
    
    [profileView addSubview:button];
    //		[button release];
    
    
    UILabel *name = [CustomUIKit labelWithText:dic[@"name"]
                                      fontSize:18 fontColor:GreenTalkColor
                                         frame:CGRectMake(10, CGRectGetMaxY(profileView.frame)+5, borderView.frame.size.width - 20, 24) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [borderView addSubview:name];
    //		[label release];
    

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame)+9, name.frame.size.width, 1)];
    lineView.backgroundColor = GreenTalkColor;
    [borderView addSubview:lineView];
    
    
    UIView *infoboxImage = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x,CGRectGetMaxY(name.frame)+10, name.frame.size.width, 55)];
    [borderView addSubview:infoboxImage];

    
    
    
    UILabel *titleLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"소속\n휴대폰"]
                                             fontSize:13 fontColor:GreenTalkColor
                                                frame:CGRectMake(10, 5, 40, 50) numberOfLines:2 alignText:NSTextAlignmentLeft];
    [infoboxImage addSubview:titleLabel];
    
    UILabel *lineLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"|\n|"]
                                           fontSize:12 fontColor:[UIColor grayColor]
                                              frame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 5, 10, 50) numberOfLines:2 alignText:NSTextAlignmentLeft];
    [infoboxImage addSubview:lineLabel];
  
    
    borderView.frame = CGRectMake(21, 10, 278, CGRectGetMaxY(infoboxImage.frame)+10);
    
    
    
    
    
    

    
    
}




- (void)backTo{
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)cancel
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 뒤로 버튼을 눌렀을 때. 한단계 위의 네비게이션컨트롤러로.
     연관화면 : 없음
     ****************************************************************/
    NSLog(@"self.presentingviewcontroller %@",self.presentingViewController);
//	if (self.presentingViewController) {
//        [self.navigationController popViewControllerWithBlockGestureAnimated:YES];
//
//	} else {
        [self dismissViewControllerAnimated:YES completion:nil];

//	}
}





- (void)imageActionSheet
{
    
    
//    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
//    NSLog(@"getMyProfile!!!! %@",documentPath);
//    
//    UIImage *image = [UIImage imageWithContentsOfFile:documentPath];
//    
//    NSLog(@"image %@",image);
//    UIActionSheet *actionSheet;
//    if(image == nil){
//        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
//                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
//        
//    }
//    else{
//        
//        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
//                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", @"사진 삭제", nil];
//    }
//    
////    [actionSheet showInView:self.parentViewController.tabBarController.view];
//     [actionSheet showInView:self.parentViewController.view];

}


#pragma mark - ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진을 눌렀을 때의 액션시트에서 선택한 버튼에 따른 동작을 설정
     param  - actionSheet(UIActionSheet *) : 액션시트
     - buttonIndex(NSInteger) : 액션시트 몇 번째 버튼인지
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    GKImagePicker *gkpicker = [[GKImagePicker alloc] init];
    
    
    switch (buttonIndex) {
        case 0:
            gkpicker.cropSize = CGSizeMake(320, 320);
            gkpicker.delegate = self;
                    gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self presentModalViewController:gkpicker.imagePickerController animated:YES];
            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            
            break;
        case 1:
            
//            [SharedAppDelegate.root launchQBImageController:1 con:self];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentModalViewController:picker animated:YES];
            [self presentViewController:picker animated:YES completion:nil];
            break;
        case 2:
        {
            
//            NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
//            NSLog(@"getMyProfile!!!! %@",documentPath);
//            
//            UIImage *image = [UIImage imageWithContentsOfFile:documentPath];
//            
//            NSLog(@"image %@",image);
//            
//            if(image != nil){
//                
//            [self changeUserImage:nil];
//            }
    }
            break;
//
        default:
            break;
    }
}



- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    UIImage *image = mediaInfoArray[0][UIImagePickerControllerEditedImage];//UIImagePickerControllerEditedImage
    
    PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
//    [picker presentModalViewController:photoViewCon animated:YES];
    [picker presentViewController:photoViewCon animated:YES completion:nil];
}

- (void)sendPhoto:(UIImage*)image
{
    [self changeUserImage:image];
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"gkimage picking");
    
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    
    
	[self changeUserImage:image];
}
#pragma mark - ImagePickerController Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker 
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올라온 이미지피커에서 사진 촬영 또는 앨범에서 선택하는 컨트롤러에서 취소했을 때 이미지 피커 내려줌.
     param - picker(UIImagePickerController *) : 이미지피커
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info 
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올라온 이미지피커에서 사진 촬영 또는 앨범에서 선택해 사진을 변경할 때.
     param  - picker(UIImagePickerController *) : 이미지피커
     - info(NSDictionary *) : 사진 정보가 담긴 dictionary
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    [self changeUserImage:image];
}



- (void)changeUserImage:(UIImage*)image
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진 눌러 나온 액션시트에서 사진 삭제를 선택하거나 사진을 변경할 때.
     param  - image(UIImage *) : 이미지
     연관화면 : 내 상태 변경
     ****************************************************************/
    

//    NSString *fullPathToFile = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[SharedAppDelegate readPlist:@"myinfo"][@"uid"]];
//	NSLog(@"fullPath %@",fullPathToFile);
//    if(image == nil) {
//        UIImage *image = [UIImage imageWithContentsOfFile:fullPathToFile];
//        NSLog(@"image %@",image);
//        if(image){
//            [SharedAppDelegate.root setMyProfileDelete:self];// deleteProfileImage];
//        }
//    }
//    else 
//    {
//    UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
//    UIImage *newImage2 = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(640, 640)];
//    
//        // 이미지 로컬의 도큐멘트 폴더에 저장
//        // 서버 업로드 관련은 맥부기에 이미지 post 로 검색해볼 것
////        NSData* UIImageJPEGRepresentation (UIImage *image, CGFloat compressionQuality);
//    
//    NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
//    [saveImage writeToFile:fullPathToFile atomically:YES];
//    NSData* originImage = UIImageJPEGRepresentation(newImage2, 0.8);
//	[SharedAppDelegate.root setMyProfile:originImage filename:@"filename"];
//    
//	[profileView setImage:newImage];
//
//    }
//    
////    [self reloadImage];
}

- (void)deleteProfileImage{
    [profileView setImage:[CustomUIKit customImageNamed:@"imageview_defaultprofile.png"]];
}


- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
{

    
    if (CGSizeEqualToSize(sourceImage.size, newSize))
    {
        return sourceImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    
    //draw
    [sourceImage drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}



/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 터치이벤트를 받는 메소드로 뷰의 빈 공간을 터치하면 벨소리를 멈추도록 함
	 연관화면 : 벨소리 설정
	 ****************************************************************/
    
	if(myTable.tag == kSubBell){
		[self initAudioPlayer:NO];
	}
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [myList count];
}


- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (section == 0) {
		if (tableView.tag == kSubPush) {
			
			NSString *appName = @"미래에셋무료통화";

			
			NSString *message;
            
            BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];

            
			if (currentStatus == NO) {
				message = [NSString stringWithFormat:@"푸시알림이 꺼져 있으면 %@ 알림을 받을 수 없습니다.\n푸시알림에 대한 설정은 아이폰바탕화면->설정->알림->%@에서 확인 하실 수 있습니다.",appName,appName];
			} else {
				message = [NSString stringWithFormat:@"푸시알림에 대한 설정은 아이폰바탕화면->설정->알림->%@에서 확인 하실 수 있습니다.",appName];
			}
			
			UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myTable.frame.size.width, myTable.sectionFooterHeight)] ;
			footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			
			UILabel *label = [CustomUIKit labelWithText:message fontSize:12.0 fontColor:[UIColor grayColor] frame:CGRectMake(10.0, 0.0, 300.0, footerView.frame.size.height) numberOfLines:0 alignText:NSTextAlignmentLeft];
			
			[footerView addSubview:label];
			return footerView;
		}
        
	}
	
	return nil;
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
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 교사일 때 내 상태 변경(답변가능/향후답변/수업중/이동중), 비밀번호 설정, 벨소리 설정 등 테이블뷰가 쓰이는 설정을 한 곳에서 세팅.
     param  - tableView(UITableView *) : 테이블뷰
     - indexPath(NSIndexPath *) : 선택한 indexPath
     연관화면 : 내 상태 변경/비밀번호 설정/벨소리 설정
     ****************************************************************/
    
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    
	cell.detailTextLabel.text = nil;
	if (tableView.tag == kSubPush) {
		cell.textLabel.text = myList[indexPath.row];

        BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];

        
		if (currentStatus == NO) {
			cell.detailTextLabel.text = @"꺼짐";
		} else {
			cell.detailTextLabel.text = @"켜짐";
		}
	}
	else if(tableView.tag == kSubStatus)
    {
	    cell.textLabel.text = myList[indexPath.row];
	
        if(indexPath.row+1 == preSelect)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        
	}
	    else if(tableView.tag == kSubBell)
    {
		cell.textLabel.text = myList[indexPath.row][@"name"];

        if(indexPath.row == bellPreSelect)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;	
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }    else if(tableView.tag == kSubProgram){
		cell.textLabel.text = myList[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
		cell.textLabel.text = myList[indexPath.row];
	}
    return cell;
}


#define kLib 3
#define kProgramInfo 1

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 테이블뷰의 태그에 따라 선택한 열에 맞춰 동작을 설정. 비밀번호는 스위치이므로 따로 동작한다. 내 상태 변경과 벨소리 설정은, 서버와 통신&plist에 저장. 벨소리 설정은 벨소리 재생까지 이어진다.
     param  - tableView(UITableView *) : 테이블뷰
     - indexPath(NSIndexPath *) : 선택한 indexPath
     연관화면 : 내 상태 변경/비밀번호 설정/벨소리 설정
     ****************************************************************/
    
    
    NSLog(@"didSelect %d",(int)tableView.tag);
	
    if(tableView.tag == kSubStatus)
    {
        if(indexPath.row+1 == preSelect)
            return;
        
//        [AppID writeToAllPlistWithKey:@"reply" value:[NSString stringWithFormat:@"%d",indexPath.row+1]];
//        [AppID uploadStatus:indexPath.row+1];
        preSelect = indexPath.row+1;
        
        [myTable reloadData];
    }
    else if(tableView.tag == kSubBell)
    {
        
        NSString *fullBell = myList[indexPath.row][@"filename"];        
        NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fullBell];
        
        [self initAudioPlayer:YES];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePathFromApp] error:nil];
        [player setDelegate:self];
        [player play];
        NSLog(@"indexpath.row %d bellPreSelect %d",(int)indexPath.row,(int)bellPreSelect);
        if(indexPath.row == bellPreSelect)
            return;

        
        bellPreSelect = indexPath.row;
		[SharedAppDelegate.root setMyProfileInfo:fullBell mode:1 sender:nil hud:NO con:nil];
        [myTable reloadData];
    }
    else if(tableView.tag == kSubProgram){
        
        if(indexPath.row == 0){//2){
            EmptyViewController *controller = [[EmptyViewController alloc]initWithList:nil from:kProgramInfo];
            if(![self.navigationController isKindOfClass:[controller class]])
		[self.navigationController pushViewController:controller animated:YES];
    
            
        }
    }
}

//- (void)onSwitch:(id)sender {
//		UISwitch *i = sender;
//		
//		id AppID = [[UIApplication sharedApplication] delegate];
//		
//		if ([i isOn])
//		{
//				[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//				[AppID writeToPossiblePlist:1];
//				[AppID uploadStatus:1];
//		} else {
//				[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//				[AppID writeToPossiblePlist:0];
//				[AppID uploadStatus:2];
//		}
//}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (void)initAudioPlayer:(BOOL)init {
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 오디오(벨소리) 재생을 위해 오디어플레이어를 초기화하거나 해제하는 메소드
	 param   - init(BOOL) : YES - 재생 준비, NO - 해제
	 연관화면 : 벨소리 설정
	 ****************************************************************/
    
//	id AppID = [[UIApplication sharedApplication] delegate];
	
	if(player) {
		if(player.playing) [player stop];

        player = nil;
	}
    
//	if(init == YES) {
//		[SharedAppDelegate.root setAudioRoute:YES];
//	} else {
//		[SharedAppDelegate.root setAudioRoute:NO];
//	}
}


- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self initAudioPlayer:NO];
    //		[[VoIPSingleton sharedVoIP] callSpeaker:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear %@",myTable);

}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}




@end
