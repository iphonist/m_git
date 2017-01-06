//
//  PhotoViewController.h
//  bSampler
//
//  Created by Hyeong Jun Park on 12. 3. 12..
//  Copyright (c) 2012년 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRScrollView.h"

@interface PhotoViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
{
	UIImage *image;
	UIViewController *parentVC;
	UIImagePickerController *pickerCon;
//	UIImageView *imageViewer;
	
	NSMutableData *receivedData;
	UIProgressView *downloadProgress;
	long totalFileSize;
	float downloadSize;
	
	int type;
	NSString *fileName;
	NSString *roomkey;
	NSString *fileServer;
	NSString *profileInfo;
	NSURLConnection *downConnection;
	
	UIButton *playButton;
	
	UITapGestureRecognizer *tapGesture;
	
	/////// 이미지 컨트롤 ////////
//	NSString	*titleString;
//	NSString *imagePrefix;
//	NSString *imageExtension;
//	NSUInteger imageCount;
	MRScrollView *mrView;
	UIScrollView *scrollView;	
	UIImageView *bottomView;
	
	NSString *uid;
//	NSMutableSet *recycledPages;
//	NSMutableSet *visiblePages;
	////////////////////////////
}

//@property (nonatomic, retain)   NSString              *titleString;
//@property (nonatomic, retain)   NSString              *imagePrefix;
//@property (nonatomic, retain)   NSString              *imageExtension;
//@property (nonatomic, assign)   NSUInteger            imageCount;

- (id)initWithPath:(NSString*)path type:(int)t;
- (id)initWithImage:(UIImage*)img parentPicker:(id)picker parentViewCon:(UIViewController*)PVC;
- (id)initWithFileName:(NSString*)name image:(UIImage*)thumbnail type:(int)t parentViewCon:(UIViewController*)PVC roomkey:(NSString*)rk server:(NSString*)server;
- (id)initWithJSONdata:(NSString*)profileImageInfo image:(UIImage*)thumbnail type:(int)t parentViewCon:(UIViewController*)PVC uniqueID:(NSString *)uniqueID;
- (void)playMovie:(NSString*)filePath;


//- (BOOL)isDisplayingSubViewForIndex:(int)index;
//- (MRScrollView*)dequeueRecycledSubView;
- (void)tilePages;
- (CGRect)frameForPagingScrollView;
//- (CGRect)frameForPageAtIndex:(NSUInteger)index;
//- (NSUInteger)imageCount;
//- (void)moveForPageAtIndex:(NSUInteger)index;
//- (void)configureSubView:(MRScrollView*)subView forIndex:(int)index;

@end
