//
//  EmptyListViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 5. 21..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTable;
    NSMutableArray *myList;
    id target;
    SEL selector;
    NSMutableArray *resultArray;
	
}


@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (id)initWithList:(NSMutableArray *)array from:(int)tag;
@end
