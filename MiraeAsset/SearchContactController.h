//
//  UrlContactController.h
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 10. 15..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchContactController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSMutableArray *myList;
    NSMutableArray *searchList;
    UITableView *myTable;
    BOOL searching;
    NSMutableArray *chosungArray;
//    NSString *urlMsg;
//    NSInteger fromWhere;
    UISearchBar *search;
    
//    NSMutableArray *favList;
//    NSMutableArray *deptList;
}

//- (id)initFromWhere:(int)tag;
- (void)setListAndTable:(int)tag;
- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav;

@end
