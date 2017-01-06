//
//  SetupViewController.h
//  bSampler
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *myTable;
	NSMutableArray *myList;
//	NSMutableArray *myImageList;

	NSInteger push;
	NSInteger status;
	NSInteger history;
	NSInteger password;
	NSInteger replySort;
	NSInteger globalFontSize;
	NSInteger alarm;
	NSInteger bell;
	NSInteger shareAccount;
	NSInteger programInfo;
	NSInteger initContact;
	NSInteger logOut;
    NSInteger allSetup;
    NSInteger echoCancel;
}

@end
