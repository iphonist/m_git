//
//  ContactViewController.h
//  ViewDeckExample
//

#import <UIKit/UIKit.h>
#import "SelectContactViewController.h"


@interface AllContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    //    NSMutableArray *memberList;
    NSMutableArray *favList;
//    NSMutableArray *chatList;
    UITableView *myTable;
    //    UIImageView *disableView;
    UISearchBar *search;
    //    UIButton *cancelBtn;
    //    NSMutableArray *favList;
    NSMutableArray *copyList;
    //    NSMutableArray *waitList;
    
    SelectContactViewController *selectContact;
}

//@property (nonatomic, retain) NSMutableArray *favList;
//@property (nonatomic, retain) IBOutlet UITableView* tableView;
//@property (nonatomic, retain) IBOutlet UIButton* pushButton;
//
//- (IBAction)defaultCenterPressed:(id)sender;
//- (IBAction)swapLeftAndCenterPressed:(id)sender;
//- (IBAction)centerNavController:(id)sender;
//- (IBAction)pushOverCenter:(id)sender;
- (void)tableSetEditingNO;
- (void)setFavoriteList;
- (void)setCopyList;
- (void)fetchFavorite;
//- (void)setNewChatlist;
- (void)setRecentList;
//- (void)setMyInfo;

@end
