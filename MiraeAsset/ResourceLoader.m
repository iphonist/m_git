//
//  ResourceLoader.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import "ResourceLoader.h"

@implementation ResourceLoader

+ (ResourceLoader*)sharedInstance
{
	static ResourceLoader *resourceLoader = nil;
	
	if (resourceLoader == nil) {
		@synchronized(self) {
			if (resourceLoader == nil) {
				resourceLoader = [[ResourceLoader alloc] init];
//				resourceLoader.cache_profileImageDirectory = [NSMutableArray arrayWithArray:[SQLiteDBManager getProfileImageDirectory]];
				resourceLoader.deptList = [[NSMutableArray alloc] init];
				resourceLoader.contactList = [[NSMutableArray alloc] init];
                resourceLoader.allContactList = [[NSMutableArray alloc] init];
                resourceLoader.customerContactList = [[NSMutableArray alloc] init];
                resourceLoader.myDeptList = [[NSMutableArray alloc] init];
				resourceLoader.favoriteList = [[NSMutableArray alloc] init];
				
                resourceLoader.myUID = [SharedAppDelegate readPlist:@"myinfo"][@"uid"];
                resourceLoader.mySessionkey = [SharedAppDelegate readPlist:@"myinfo"][@"sessionkey"];
			}
		}
	}
	return resourceLoader;
}

#pragma mark - ProfileImage Public Methods

+ (NSURL*)resourceURLfromJSONString:(NSString*)jsonString num:(int)num thumbnail:(BOOL)thumb
{
	if(!jsonString || [jsonString length] < 1){
        return nil;
    }
    NSDictionary *dict = [jsonString objectFromJSONString];
	
	NSString *filename;
	if(![dict objectForKey:@"thumbnail"] || [[dict objectForKey:@"thumbnail"] count] < 1 || thumb == NO) {
		if ([dict objectForKey:@"filename"] && [[dict objectForKey:@"filename"] count] > 0) {
			filename = [[dict objectForKey:@"filename"] objectAtIndex:num];
		} else {
			return nil;
		}
	} else {
		filename = [[dict objectForKey:@"thumbnail"] objectAtIndex:num];
	}
	
	NSString *serverAddress = [dict objectForKey:@"server"];
	NSString *urlStr = [NSString stringWithFormat:@"%@://%@%@%@",[dict objectForKey:@"protocol"],serverAddress,[dict objectForKey:@"dir"],filename];
	NSURL *URL = [NSURL URLWithString:urlStr];
	return URL;
}

+ (NSString*)checkProfileImageWithUID:(NSString *)uid
{
    if ([uid length] < 1 || uid == nil) {
        return nil;
    }

	NSString *imgString = [[ResourceLoader sharedInstance] getProfileImageAtUID:uid];
    if ([imgString length] < 1 || imgString == nil) {
        return nil;
    }
	
	return imgString;
}

#pragma mark - ProfileImage Private Methods

- (NSString*)getProfileImageAtUID:(NSString*)uid
{
	NSString *profile = [NSString string];

	for (NSDictionary *dic in self.cache_profileImageDirectory) {
		if ([[dic objectForKey:@"uid"] isEqualToString:uid]) {
			profile = [dic objectForKey:@"profileimage"];
			break;
		}
	}
	return profile;
}

- (void)cache_profileImageDirectoryUpdateObjectAtUID:(NSString*)uid andProfileImage:(NSString*)profile
{
	BOOL isExist = NO;
	NSInteger index = 0;
	for (NSDictionary *dic in self.cache_profileImageDirectory) {
		if ([[dic objectForKey:@"uid"] isEqualToString:uid]) {
			isExist = YES;
			break;
		}
		index++;
	}
	
	NSURL *url = [ResourceLoader resourceURLfromJSONString:[self getProfileImageAtUID:uid] num:0 thumbnail:YES];
	[[SDImageCache sharedImageCache] removeImageForKey:[url description]];
	if (isExist) {
		NSLog(@"cache_update");
		
		if ([uid isEqualToString:[ResourceLoader sharedInstance].myUID]) {
			NSLog(@"MyProfile Update IN Cache %@, %@",uid,profile);
			NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",uid];
			NSURL *imgURL = [NSURL fileURLWithPath:documentPath];
			[[SDImageCache sharedImageCache] removeImageForKey:[imgURL description] fromDisk:NO];
		}
		
		[self.cache_profileImageDirectory replaceObjectAtIndex:index withObject:@{@"uid": uid, @"profileimage": profile}];
	} else {
		NSLog(@"cache_create");
		[self.cache_profileImageDirectory addObject:@{@"uid": uid, @"profileimage": profile}];
	}
}

- (void)cache_profileImageDirectoryDeleteObjectAtUID:(NSString*)uid
{
	BOOL isExist = NO;
	NSInteger index = 0;
	for (NSDictionary *dic in self.cache_profileImageDirectory) {
		if ([[dic objectForKey:@"uid"] isEqualToString:uid]) {
			isExist = YES;
			break;
		}
		index++;
	}
	
	if (isExist) {
		NSLog(@"cache_delete");
		NSURL *url = [ResourceLoader resourceURLfromJSONString:[self getProfileImageAtUID:uid] num:0 thumbnail:YES];
		[[SDImageCache sharedImageCache] removeImageForKey:[url description] fromDisk:YES];
		
		if ([uid isEqualToString:[ResourceLoader sharedInstance].myUID]) {
			NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",uid];
			NSLog(@"@@@@@@@@@@ %@",documentPath);
			NSURL *imgURL = [NSURL fileURLWithPath:documentPath];
			[[SDImageCache sharedImageCache] removeImageForKey:[imgURL description] fromDisk:YES];
		}
		
		[self.cache_profileImageDirectory removeObjectAtIndex:index];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
	}
}



#pragma mark - Round Corner Image Process

-(void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight
{
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
	
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth (rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (void)roundCornersOfImage:(UIImage *)source scale:(int)scale block:(void(^)(UIImage *roundedImage))block
{
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

		CGFloat w = source.size.width;
		CGFloat h = source.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, w, h);
//		addRoundedRectToPath(context, rect, scale, scale);
		[[ResourceLoader sharedInstance] addRoundedRectToPath:context rect:rect ovalWidth:scale ovalHeight:scale];
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
		UIImage *roundedImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
		
        //back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            block(roundedImage);
        });
    });
}

#pragma mark - Data Array
- (void)settingContactList
{
	NSLog(@"init Contacts");

    NSMutableArray *contactArray = [NSMutableArray array];
    
    contactArray  = [SQLiteDBManager getList];
    
    NSLog(@"deptArray count %d",[contactArray count]);
    
        for(int j = 0; j < [contactArray count]; j++) {
            //    for(NSDictionary *aDic in contactArray){
            NSDictionary *aDic = contactArray[j];
            NSString *deptcode = aDic[@"deptcode"];
            for(NSDictionary *dic in self.deptList) {
                NSString *mycode = dic[@"mycode"];
                if([deptcode isEqualToString:mycode]) {
                    NSString *newDeptName = dic[@"shortname"];
                    NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:newDeptName key:@"team"];
                    [contactArray replaceObjectAtIndex:j withObject:newDic];
                    
                }
                
            }
            
        }
        
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"newfield2" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCompare:)];
    
    [contactArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
    [self.allContactList setArray:contactArray];
    
        [contactArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, sortName, nil]];
        [self.contactList setArray:contactArray];
    NSLog(@"contactList %d",[self.contactList count]);
    
    
    
        [self.myDeptList removeAllObjects];
    
        for(NSDictionary *dic in [self.contactList copy]){
            if([dic[@"deptcode"]isEqualToString:[SharedAppDelegate readPlist:@"myinfo"][@"deptcode"]]){
                [self.myDeptList addObject:dic];
            }

        }
        NSLog(@"self.myDeptList count %d",[self.myDeptList count]);
        NSLog(@"Contacts initializing complete.");
    
    
}

- (void)settingDeptList
{
    NSLog(@"init DeptList");
    
    NSMutableArray *deptArray = [NSMutableArray array];

    
    deptArray = [SQLiteDBManager getOrganizing];
    
    NSLog(@"deptArray count %d",[deptArray count]);
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"newfield1" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortTeamName = [NSSortDescriptor sortDescriptorWithKey:@"shortname" ascending:YES selector:@selector(localizedCompare:)];
	
    [deptArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, sortTeamName, nil]];
    [self.deptList setArray:deptArray];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
//});
	NSLog(@"DeptList initializing complete.");


}



#pragma mark - Data Search
- (NSArray *)deptRecursiveSearch:(NSString*)myCode
{
	NSMutableArray *selectedDeptArray = [NSMutableArray array];
	[selectedDeptArray addObject:myCode];
	
	for (NSDictionary *dic in [self.deptList copy]) {
		if ([dic[@"parentcode"] isEqualToString:myCode]) {
			[selectedDeptArray addObjectsFromArray:[self deptRecursiveSearch:dic[@"mycode"]]];
		}
	}
	
	return (NSArray*)selectedDeptArray;
}

- (NSString *)searchCode:(NSString *)code
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 공지사항을 받았을 때 조직코드에 맞는 조직이름을 찾아 리턴한다.
     param  - code(NSString *) : 조직코드
     연관화면 : 없음
     ****************************************************************/
    
    NSString *dept = [NSString string];
    for(NSDictionary *forDic in [self.deptList copy]) {
        if([forDic[@"mycode"] isEqualToString:code]) {
            dept = forDic[@"shortname"];
			break;
        }
    }
    if(dept == nil)
        dept = @"";
    
    return dept;
}

- (NSString *)getUserName:(NSString *)uid
{
    NSLog(@"uid %@",uid);
//uid = [SharedFunctions minusMe:uid];
    
    if([uid hasSuffix:@","])
        uid = [uid substringWithRange:NSMakeRange(0,[uid length]-1)];
    
    NSString *userName = [NSString string];
    NSLog(@"_allContactList %d",[_allContactList count]);
	for(NSDictionary *forDic in [_allContactList copy]) {
        if([forDic[@"uniqueid"] isEqualToString:uid]) {
            userName = forDic[@"name"];
			break;
        }
    }
    NSLog(@"returnName %@",userName);
    return userName;
}

@end
