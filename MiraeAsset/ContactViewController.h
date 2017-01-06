//
//  AddMemberViewController.h
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 2..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UIScrollViewDelegate>{
    
    UITableView *myTable;
    NSMutableArray *myList;
    NSMutableArray *originList;
    
    NSMutableArray *chosungArray;
    NSMutableArray *copyList;
    
    UISearchBar *search;
    
    BOOL searching;
    int tag;
    
    NSMutableArray *addArray;
    NSMutableArray *alreadyArray;
    
    int viewTag;
    id target;
    SEL selector;
    
    BOOL addRest;
    BOOL progressing;
    BOOL fetching;
    NSMutableArray *checkNumberArray;
    UIButton *countButton;
    UILabel *countLabel;
    
}


@end
