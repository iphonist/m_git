//
//  PhotoViewController.m
//  LEMPMobile
//
//  Created by Hyeong Jun Park on 12. 3. 12..
//  Copyright (c) 2012년 Benchbee. All rights reserved.
//

#import "PhotoViewController.h"
#import "SVProgressHUD.h"
//#import "ChatViewC.h"


#define PI 3.14159265358979323846

static inline float radians(double degrees) { return degrees * PI / 180; }

@implementation PhotoViewController
//@synthesize imageCount, titleString, imageExtension, imagePrefix;



- (id)initWithImage:(UIImage*)img parentPicker:(id)picker parentViewCon:(UIViewController*)PVC
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 앨범에서 사진을 선택하여 전송할때 이미지를 받아오면서 초기화
	 param - img(UIImage*) : 선택한 이미지 데이터
			 - picker(UIImagePickerController*) : 이미지를 선택했던 UIImagePickerController
			 - PVC(UIViewController*) : 이 메소드를 호출한 뷰컨트롤러(채팅뷰)
	 연관화면 : 채팅 - 사진선택
	 ****************************************************************/

	self = [super init];
	if (self) {
		// Custom initialization
		image = img;
		parentVC = PVC;
		pickerCon = (UIImagePickerController*)picker;
		type = 0;
//		self.imageCount = 1;
		
		self.title = @"사진 선택";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
		[self.view setBackgroundColor:[UIColor blackColor]];
		
		bottomView = [[UIImageView alloc] initWithImage:[CustomUIKit customImageNamed:@"pht_tabbg.png"]];
		[bottomView setFrame:CGRectMake(0, self.view.frame.size.height - 43, 320, 43)];
		[bottomView setUserInteractionEnabled:YES];
		[bottomView setAlpha:0.8];
        
		UIButton *button;
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(5, 7, 50, 28)];
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"pt_tabbtn.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
		UILabel *label = [CustomUIKit labelWithText:@"취소" fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 4, 50, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
        
		UILabel *titlelabel = [CustomUIKit labelWithText:@"사진선택" fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 12, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
         titlelabel.shadowOffset = CGSizeMake(-1, -1);
        titlelabel.shadowColor = [UIColor darkGrayColor];
		[bottomView addSubview:titlelabel];
//		[label release];
		
        button = [[UIButton alloc]initWithFrame:CGRectMake(320-50-5, 7, 50, 28)];
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"pt_tabbtn.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
        label = [CustomUIKit labelWithText:@"선택" fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 4, 50, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [button addSubview:label];
        
        
		[self.view addSubview:bottomView];
        

	}
	return self;
}




- (void)saveToAlbum
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : "저장"버튼을 눌렀을때 동작, 컨텐츠를 사용자의 앨범으로 복사하는 메소드
	 연관화면 : 채팅 - 사진보기,동영상보기
	 ****************************************************************/
   NSLog(@"saveToAlbum");
    
    [SVProgressHUD showWithStatus:@"사진을 저장하는 중입니다"];
		UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);		
	
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    
    // Was there an error?
    [SVProgressHUD dismiss];
	if (error != NULL)
	{
      // Show error message...
		[CustomUIKit popupAlertViewOK:nil msg:@"사진 저장에 실패하였습니다!\n저장 공간이 부족하거나 파일이 손상되었을 수 있습니다."];
	}
	else  // No errors
	{
      // Show message image successfully saved
		[CustomUIKit popupAlertViewOK:nil msg:@"앨범에 사진을 저장하였습니다."];
	}
}



- (void)selectPhoto
{
    NSLog(@"selectPhoto %@",parentVC);
	
//	[parentVC sendPhoto:image];
	[parentVC performSelector:@selector(sendPhoto:) withObject:image];
    [parentVC dismissViewControllerAnimated:NO completion:nil];
//    [pickerCon popViewControllerWithBlockGestureAnimated:NO];
//	[pickerCon dismissModalViewControllerAnimated:YES];
//	[pickerCon release];
}

- (void)cancel
{
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backTo
{
    
//	[self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

-(void)getFile
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 파일을 다운로드 함.
	 연관화면 : 채팅 - 사진보기,동영상보기
	 ****************************************************************/
    
    NSLog(@"getFile");

    
    if(type == 12){
        
        NSLog(@"type 12");
        NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),fileName];
           
        if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
            NSLog(@"fileexist %@",cachefilePath);
            
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            image = [UIImage imageWithContentsOfFile:cachefilePath];
            [mrView displayImage:image];
            NSLog(@"image %@",image);
            return;
		}
    }
    
    
	downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	[downloadProgress setFrame:CGRectMake(30, 340, 260, 10)];
	[self.view addSubview:downloadProgress];

//	id AppID = [[UIApplication sharedApplication]delegate];
	
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",fileServer]]];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:roomkey,@"roomkey",
//                                [SharedAppDelegate readPlist:@"was"],@"Was",
//                                fileName,@"messageidx",
//                                [[SharedAppDelegate readPlist:@"myinfo"]objectForKey:@"uniqueid"],@"uniqueid", [SharedAppDelegate readPlist:@"skey"],@"sessionkey",nil];
//    NSLog(@"parameters %@",parameters);
//    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"getFile.xfon" parameters:parameters];
//    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];

    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileServer] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    //                    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:nil];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                  
         [downloadProgress setProgress:(float)totalBytesRead / totalBytesExpectedToRead];

     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        
        
        [downloadProgress removeFromSuperview];
        
        downloadProgress = nil;
        
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
        
        if(roomkey != nil && [roomkey length]>0){
            [operation.responseData writeToFile:filePath atomically:YES];
            
            NSString *savedIdx = [fileName substringToIndex:[fileName length]-4];
            [SQLiteDBManager updateReadInfo:@"0" changingIdx:savedIdx idx:savedIdx];
            
            
            
        }
        
        if(type == 12){
            NSLog(@"else %@",fileName);
            NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),fileName];
            NSLog(@"cachefilepath %@",cachefilePath);
            [operation.responseData writeToFile:cachefilePath atomically:YES];

        }
        
        
//
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
		
		if(type == 2 || type == 12) {
			image = [UIImage imageWithData:operation.responseData];
			NSLog(@"length %d",(int)[operation.responseData length]);
			NSLog(@"image %@",image);
			
			if (profileInfo) {
				NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:profileInfo num:0 thumbnail:YES];
				NSLog(@"IMGURL - %@",[[SDImageCache sharedImageCache] imageFromKey:[imgURL absoluteString]]);
				[[SDImageCache sharedImageCache] removeImageForKey:[imgURL absoluteString]];
							
//				if (uid && [uid isEqualToString:[ResourceLoader sharedInstance].myUID]) {
//					
//					NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//					NSString *fullPathToFile = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",uid];
//					NSURL *imgURL = [NSURL fileURLWithPath:fullPathToFile];
//					[[SDImageCache sharedImageCache] removeImageForKey:[imgURL description] fromDisk:YES];
//					
//					UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
//					NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
//					[saveImage writeToFile:fullPathToFile atomically:YES];
//					[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
//				}
			}
			
			[mrView displayImage:image];
		} else if (type == 5) {
			//        [self.navigationController popViewControllerWithBlockGestureAnimated:NO];
			//		[parentVC playMedia:type withPath:filePath];
			[self playMovie:filePath];
		}
	
		if(fileName != nil) {
			fileName = nil;
		}
		fileName = [[NSString alloc] initWithString:filePath];

            
                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"failed %@",error);
		[HTTPExceptionHandler handlingByError:error];

    }];
    [operation start];

    
}


-(NSNumber *) fileOneSize:(NSString *)file
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 인자로 받은 파일경로에 해당하는 파일의 크기를 반환하는 메소드
	 param	- file(NSString*) : 파일경로
	 연관화면 : 없음
	 ****************************************************************/
    
    NSLog(@"fileOneSize");
	NSDictionary *fileAttributes=[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];	
	return fileAttributes[NSFileSize];
}


- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진을 변경할 때 바로 서버와 통신하지 않고 사이즈 조절 후 통신하기 위해 사이즈를 조절.
     param  - sourceImage(UIImage *) : 변경할 이미지
     - newSize(CGSize) : 변경할 사이즈
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;

//	self.wantsFullScreenLayout = YES;
	// Do any additional setup after loading the view, typically from a nib.
	[self setHidesBottomBarWhenPushed:YES];
	
//	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	NSLog(@"%f,%f,%f,%f",[[UIScreen mainScreen] bounds].origin.x,[[UIScreen mainScreen] bounds].origin.y,[[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width);
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	
	scrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	scrollView.pagingEnabled = YES;
	scrollView.bounces = YES;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width,
													pagingScrollViewFrame.size.height);
	scrollView.delegate = self;
		
	UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	[doubleTapGesture setNumberOfTapsRequired:2];
	[scrollView addGestureRecognizer:doubleTapGesture];

	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];    
	[tapGesture requireGestureRecognizerToFail:doubleTapGesture];
	[scrollView addGestureRecognizer:tapGesture];
	[self.view addSubview:scrollView];
	[self.view sendSubviewToBack:scrollView];
    
//	recycledPages = [[NSMutableSet alloc] init];
//	visiblePages  = [[NSMutableSet alloc] init];
	
	[self tilePages];    

    
	if(type == 5 || type == 6) {
		CGPoint viewCenter = self.view.center;
//		if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
			viewCenter.y -= 40.0;
//		}
		playButton = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(replay) frame:CGRectMake(viewCenter.x-56, viewCenter.y-56, 113, 113) imageNamedBullet:nil imageNamedNormal:@"movie_playbtn.png" imageNamedPressed:nil];
		[playButton setEnabled:NO];
		[self.view addSubview:playButton];
	}
	if(type == 12 || type == 2 || type == 5) {
		[self getFile];
	} 
}

- (void)handleGesture:(UIGestureRecognizer*)gesture {
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진보기 중 화면을 한번 터치하면 iOS 기본UI들을 숨기거나 표시
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/

    NSLog(@"1");
	if(playButton)
		return;
	
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSLog(@"2");
    if(type != 1)
        [[UIApplication sharedApplication] setStatusBarHidden:![[UIApplication sharedApplication] isStatusBarHidden] withAnimation:UIStatusBarAnimationNone];
  
  
    
    NSLog(@"4");
//    [self.view setNeedsDisplay];
    
    
	[self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
    if(self.navigationController.navigationBar.hidden){
        
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
            self.view.frame = [[UIScreen mainScreen] bounds];
        }
        else{
            mrView.frame = CGRectMake(0,44,320,self.view.bounds.size.height);
            if(type == 0)
                mrView.frame = CGRectMake(0,0,320,self.view.bounds.size.height);
            
        }
    }
    else{
        
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
            self.view.frame = [[UIScreen mainScreen] bounds];
        }
        else{
            
            mrView.frame = CGRectMake(0,-20,320,self.view.bounds.size.height+20+44);
            if(type == 0)
                mrView.frame = CGRectMake(0,0,320,self.view.bounds.size.height);
        }
    }
	NSLog(@"frame %@",NSStringFromCGRect(mrView.frame));
	
    double KEYBOARD_SPEED;
    
    
    if (version >= 5.0)
        KEYBOARD_SPEED = 0.25f;        
    
    else
        KEYBOARD_SPEED = 0.3f;
    
	if (bottomView) {
		CGRect rect = bottomView.frame;
		rect.origin.y = (bottomView.frame.origin.y<self.view.frame.size.height)?self.view.frame.size.height:self.view.frame.size.height-43;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:KEYBOARD_SPEED];
		[bottomView setFrame:rect];
		[UIView commitAnimations];
	}
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)recognizer  {
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진보기 중 화면을 두번 터치하면 사진을 확대하거나 축소
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/

	if(playButton)
		return;

	if(mrView.zoomScale == mrView.maximumZoomScale)
		[mrView setZoomScale:mrView.minimumZoomScale animated:YES];
	else
		[mrView setZoomScale:mrView.maximumZoomScale animated:YES];
}

#pragma mark - Frame Caculating methods
#define PADDING 10

- (CGRect)frameForPagingScrollView {
	
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진보기 뷰의 프레임 사이즈를 결정하여 반환
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/

	CGRect frame;// = [[UIScreen mainScreen] bounds];
  
  

    if ([[UIDevice currentDevice].systemVersion floatValue]  < 7.0f) {
        
        frame = [[UIScreen mainScreen] bounds];
    }
    else{
        frame = CGRectMake(0,0-44,320,self.view.bounds.size.height+44);
        
        if(type == 0){
            frame = CGRectMake(0,0,320,self.view.bounds.size.height);
        }
    }
    	NSLog(@"frame %@",NSStringFromCGRect(frame));
    
//	if( UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) ) {
//		CGFloat width = frame.size.height;
//		CGFloat height = frame.size.width;
//		frame.size = CGSizeMake(width, height);
//	}
	
//	frame.origin.x -= PADDING;
//	frame.size.width += (2 * PADDING);
	return frame;
}

//- (CGRect)frameForPageAtIndex:(NSUInteger)index {
//	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
//	
//	CGRect pageFrame = pagingScrollViewFrame;
//	pageFrame.size.width -= (2 * PADDING);
//	pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
//	return pageFrame;
//}
//
//- (void)moveForPageAtIndex:(NSUInteger)index {
//	CGRect visibleRect = [self frameForPageAtIndex:index];
//	[scrollView setContentOffset:visibleRect.origin animated:YES];
//	
//	[self tilePages];
//}
//
//- (void)configureSubView:(MRScrollView*)subView forIndex:(int)index {
//	
//	subView.index = index;
//	subView.frame = [self frameForPageAtIndex:index];
//	
//	NSString *imageName = [NSString stringWithFormat:@"%@_%d",self.imagePrefix,index];
//	NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:self.imageExtension];
//	
//	[subView displayImage:image];
//}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	[self tilePages];   
}

- (void)tilePages 
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사진보기 뷰를 초기화하고 이미지를 설정
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/


    
	if (mrView == nil) 
		mrView = [[MRScrollView alloc] init] ;
	mrView.frame = [self frameForPagingScrollView];
    
	[mrView displayImage:image];
	[scrollView addSubview:mrView];
    NSLog(@"scrollView %f %f %f %f",scrollView.frame.origin.x,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height);
    
//	}    
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	
	scrollView.frame = pagingScrollViewFrame;    
	scrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width,
													pagingScrollViewFrame.size.height);
	
	[mrView displayImage:image];
	
//	NSUInteger index;
//	for(MRScrollView *page in visiblePages) {
//		[self configureSubView:page forIndex:page.index];
//		index = page.index;        
//	}
//	[self moveForPageAtIndex:index];
}


- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
//	[imageViewer release];
	
}

- (void)viewWillAppear:(BOOL)animated
{

	
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
	SharedAppDelegate.window.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setBackgroundImage:[CustomUIKit customImageNamed:@"photoviewbarbg.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//		[self.navigationController.navigationBar setBackgroundImage:[CustomUIKit customImageNamed:@"photoviewbarbg_ios7.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barTintColor = RGB(37, 37, 37);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(225, 223, 224)}];
        
    }

}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
	if(type == 6) {
		[self playMovie:fileName];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
 	
    NSLog(@"viewWillDisappear");
    
    self.wantsFullScreenLayout = NO;
	SharedAppDelegate.window.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
		[self.navigationController.navigationBar setBackgroundImage:[CustomUIKit customImageNamed:@"navibar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
		[self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barTintColor = RGB(226, 226, 226);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        
    }
    
    
    


}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations.
//    return YES;
//}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}




@end
