//
//  SelectContactViewController.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 18..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "SelectContactViewController.h"
#import "OrganizeViewController.h"

@interface SelectContactViewController ()

@end

@implementation SelectContactViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.title = @"조직도";
   }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    NSLog(@"viewdidload");
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    

    
//    UIButton *button = [CustomUIKit closeRightButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];

    
    
    
    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSearch) frame:CGRectMake(0, 0, 21, 21) imageNamedBullet:nil imageNamedNormal:@"button_searchview_search.png" imageNamedPressed:nil];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];

    
    UISearchBar *search;
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    search.delegate = self;
	
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(242,242,242);
        }
    }
    else{
        search.tintColor = RGB(242,242,242);
    }
	//    search.backgroundImage = [CustomUIKit customImageNamed:@"n04_secbg.png"];
    search.placeholder = @"이름(초성), 부서, 전화번호 검색";
    [self.view addSubview:search];
    
    NSLog(@"self.view %f",self.view.frame.size.height);

    
    
    UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 40)];
//    groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
     groupNameView.backgroundColor = RGB(229, 229, 226);
    [self.view addSubview:groupNameView];
    groupNameView.userInteractionEnabled = YES;
    
//    int w = 0;
    
    UILabel *addName;
    UIButton *addNameImage;
    //		UIImageView *pathImage;
    
				CGSize size;
    size = [@"홈" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    
    addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(3, 3, size.width + 15, groupNameView.frame.size.height-6)];
    addNameImage.tag = 100;
//    [addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
    
    [groupNameView addSubview:addNameImage];
//    [addNameImage release];
    
//    [addNameImage setBackgroundImage:[CustomUIKit customImageNamed:@"adduser_01.png"] forState:UIControlStateNormal];
    //						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_01.png"];
    
    [addNameImage setBackgroundImage:[[UIImage imageNamed:@"imageview_roundingbox_green.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
    
    addName = [CustomUIKit labelWithText:@"홈" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(3, 0, size.width + 10, addNameImage.frame.size.height) numberOfLines:1
                               alignText:UITextAlignmentCenter];
    
				[addNameImage addSubview:addName];
    
    
    
    
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height - search.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
    
    
    float viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44 + 20;
    } else {
        viewY = 44;
        
    }
    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(groupNameView.frame), 320, self.view.frame.size.height - viewY - CGRectGetMaxY(groupNameView.frame) - 49); // search
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//        myTable.frame = CGRectMake(0, CGRectGetMaxY(groupNameView.frame), 320, self.view.frame.size.height - 44 - CGRectGetMaxY(groupNameView.frame) - 49 - 20); // search
    myTable.rowHeight = 50;
    myTable.delegate = self;
    myTable.dataSource = self;
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.view addSubview:myTable];
//    [myTable release];
    
    myList = [[NSMutableArray alloc]init];

 

}

- (void)backTo//:(id)sender
{
    NSLog(@"backTo");
    
    [(CBNavigationController*)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    
}


- (void)backAll{
    
    [(CBNavigationController*)self.navigationController popToRootViewControllerWithBlockGestureAnimated:YES];
}

#define kOrganize 4
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    
    [SharedAppDelegate.root loadSearch:kOrganize];
    
    
    return NO;
}

- (void)loadSearch{
     [SharedAppDelegate.root loadSearch:kOrganize];
}


- (void)cancel{
    NSLog(@"cancel!!!!!!!!!!!!!!!!");
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myList count];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cellForRow");
    
    static NSString *CellIdentifier = @"Cell";

    UILabel *name;
//    UIImageView *profileView;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
//        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(6,6,43,43)];
//        profileView.tag = 1;
//        [cell.contentView addSubview:profileView];
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 120, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:17];
//        name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
//        [name release];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else{
//        profileView = (UIImageView *)[cell viewWithTag:1];
        name = (UILabel *)[cell viewWithTag:2];

    }
    
//            profileView.image = [CustomUIKit customImageNamed:@"n07_gmanic.png"];;
    NSLog(@"mylist 0 %@",myList[indexPath.row]);
            name.text = [[ResourceLoader sharedInstance] searchCode:myList[indexPath.row]];
    NSLog(@"name.text %@",name.text);
    
        
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"viewwill top %@",[SharedAppDelegate readPlist:@"toptree"]);
    [myList setArray:[SharedAppDelegate readPlist:@"toptree"]];
    NSLog(@"mylist %@",myList);
    [myTable reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewdidappear");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselect");
//    OrganizeViewController *organizeController = [[OrganizeViewController alloc]init];
    
    NSString *listName = [[ResourceLoader sharedInstance] searchCode:myList[indexPath.row]];
    NSLog(@"listName %@",listName);
    [SharedAppDelegate.root.organize.selectCodeList removeAllObjects];
    [SharedAppDelegate.root.organize.selectCodeList addObject:myList[indexPath.row]];
    [SharedAppDelegate.root.organize.addArray removeAllObjects];
    [SharedAppDelegate.root.organize.addArray addObject:listName];
    //    NSLog(@"org addarray %@ addobject %@",organizeController.addArray,listName);
    if(![self.navigationController isKindOfClass:[SharedAppDelegate.root.organize class]])
    [self.navigationController pushViewController:SharedAppDelegate.root.organize animated:NO];
    [SharedAppDelegate.root.organize setFirst:listName];
    [SharedAppDelegate.root.organize checkSameLevel:myList[indexPath.row]];
//    [organizeController release];
}

- (void)viewDidUnload{
    [super viewDidUnload];
//    [myList release];
}

@end
