//
//  ResourceLoader.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceLoader : NSObject

+ (ResourceLoader*)sharedInstance;
+ (NSURL*)resourceURLfromJSONString:(NSString*)jsonString num:(int)num thumbnail:(BOOL)thumb;
+ (NSString*)checkProfileImageWithUID:(NSString *)uid;

- (void)cache_profileImageDirectoryUpdateObjectAtUID:(NSString*)uid andProfileImage:(NSString*)profile;
- (void)cache_profileImageDirectoryDeleteObjectAtUID:(NSString*)uid;

+ (void)roundCornersOfImage:(UIImage *)source scale:(int)scale block:(void(^)(UIImage *roundedImage))block;

- (void)settingContactList;
- (void)settingDeptList;

- (NSString *)searchCode:(NSString *)code;
- (NSArray *)deptRecursiveSearch:(NSString*)myCode;
- (NSString *)getUserName:(NSString *)uid;

@property (nonatomic, retain) NSMutableArray *cache_profileImageDirectory;
@property (nonatomic, retain) NSMutableArray *deptList;
@property (nonatomic, retain) NSMutableArray *contactList;
@property (nonatomic, retain) NSMutableArray *allContactList;
@property (nonatomic, retain) NSMutableArray *customerContactList;
@property (nonatomic, retain) NSMutableArray *myDeptList;
@property (nonatomic, retain) NSMutableArray *favoriteList;

@property (nonatomic, retain) NSString *myUID;
@property (nonatomic, retain) NSString *mySessionkey;
@end
