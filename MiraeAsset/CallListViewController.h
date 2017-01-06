//
//  RecentCallViewController.h
//  LEMPMobile
//
//  Created by Hyemin Kim on 11. 10. 19..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
    
    UITableView *myTable;
    NSMutableArray *myList;
    
}

//- (void)setPushButton;
//- (void)setModalButton;
- (NSUInteger)myListCount;
- (NSUInteger)selectListCount;
- (void)startEditing;
- (void)endEditing;
- (void)refreshContents;
- (void)commitDelete;

@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, retain) NSMutableArray *myList;

@end

