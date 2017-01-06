//
//  SelectContactViewController.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 18..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectContactViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *myList;
    UITableView *myTable;
}

@end
