/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBAssetCollectionViewController.h"

// Views
#import "QBImagePickerAssetCell.h"
#import "QBImagePickerFooterView.h"

@interface QBAssetCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableOrderedSet *selectedAssets;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

- (void)reloadData;
- (void)updateRightBarButtonItem;
- (void)updateDoneButton;
- (void)done;
- (void)cancel;

@end

@implementation QBAssetCollectionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        /* Initialization */
        NSLog(@"Initialization");
        self.assets = [NSMutableArray array];
        self.selectedAssets = [NSMutableOrderedSet orderedSet];
        
        self.imageSize = CGSizeMake(75, 75);
        
        
        // Table View
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.allowsSelection = YES;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self.view addSubview:tableView];
        self.tableView = tableView;
        
        self.alreadySetAssets = NO;
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear %@",self.alreadySetAssets?@"YES":@"NO");
    
    self.title = [NSString stringWithFormat:@"카메라롤 (%d/%d)",(int)[self.selectedAssets count],(int)self.maximumNumberOfSelection];
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    
    if(self.alreadySetAssets)
        return;
    // Reload
    [self reloadData];

    
    CGFloat topInset;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        topInset = ((self.edgesForExtendedLayout && UIRectEdgeTop) && (self.tableView.contentInset.top == 0)) ? (20.0 + 44.0) : 0.0;
    } else {
        topInset = (self.tableView.contentInset.top == 0) ? (20.0 + 44.0) : 0.0;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height + topInset)
                                 animated:NO];
    
    
//    if (self.fullScreenLayoutEnabled) {
//        // Set bar styles
//		self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor blackColor]};
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//        self.navigationController.navigationBar.translucent = YES;
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
//        
//        
//          if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
//                  self.navigationController.navigationBar.translucent = NO;
//          }
//        
//        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height + 20 + 44)
//                                animated:NO];
//        
//        
//        
//    }

}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    self.alreadySetAssets = YES;
    
    // Flash scroll indicators
    [self.tableView flashScrollIndicators];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    [self updateRightBarButtonItem];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    [self updateRightBarButtonItem];
}


#pragma mark - Instance Methods

- (void)reloadData
{
    NSLog(@"reload assets");
    // Reload assets
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.assets addObject:result];
        }
    }];
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0,self.tableView.contentSize.height)];
    // Set footer view
    if (self.showsFooterDescription) {
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSUInteger numberOfPhotos = self.assetsGroup.numberOfAssets;
        
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
        NSUInteger numberOfVideos = self.assetsGroup.numberOfAssets;
        
        switch(self.filterType) {
            case QBImagePickerFilterTypeAllAssets:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                break;
            case QBImagePickerFilterTypeAllPhotos:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                break;
            case QBImagePickerFilterTypeAllVideos:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                break;
        }
        
        QBImagePickerFooterView *footerView = [[QBImagePickerFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
        
        if (self.filterType == QBImagePickerFilterTypeAllAssets) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfPhotos:numberOfPhotos numberOfVideos:numberOfVideos];
        } else if (self.filterType == QBImagePickerFilterTypeAllPhotos) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfPhotos:numberOfPhotos];
        } else if (self.filterType == QBImagePickerFilterTypeAllVideos) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfVideos:numberOfVideos];
        }
        
        self.tableView.tableFooterView = footerView;
    } else {
        QBImagePickerFooterView *footerView = [[QBImagePickerFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 4)];
        
        self.tableView.tableFooterView = footerView;
    }
}

- (void)backTo//:(id)sender
{
    NSLog(@"backTo");
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)updateRightBarButtonItem
{
    
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_next.png" target:self selector:@selector(next)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
    self.doneButton = btnNavi;
    self.doneButton.enabled = NO;
    
    
//    if (self.allowsMultipleSelection) {
//        // Set done button
////        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
////        doneButton.enabled = NO;
////        
////        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
////      
//        
//    } else if (self.showsCancelButton) {
//        // Set cancel button
////        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
////
////        [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
//    } else {
////        [self.navigationItem setRightBarButtonItem:nil animated:NO];
//    }
}

- (void)updateDoneButton
{
    
    if (self.limitsMinimumNumberOfSelection) {
        NSLog(@"updatedone. limitsminimum");
        self.doneButton.enabled = (self.selectedAssets.count >= self.minimumNumberOfSelection);
    } else {
        NSLog(@"updatedone. else");
        self.doneButton.enabled = (self.selectedAssets.count > 0);
    }
}

- (void)next
{
//    if([self.selectedAssets.array count]<1)
//        return;
    
    [self.delegate assetCollectionViewController:self didFinishPickingAssets:self.selectedAssets.array];
}

- (void)cancel
{
    [self.delegate assetCollectionViewControllerDidCancel:self];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
    
    switch(section) {
        case 0: case 1:
        {
            if (self.allowsMultipleSelection && !self.limitsMaximumNumberOfSelection && self.showsHeaderButton) {
                numberOfRowsInSection = 1;
            }
        }
            break;
        case 2:
        {
            NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
            numberOfRowsInSection = self.assets.count / numberOfAssetsInRow;
            if ((self.assets.count - numberOfRowsInSection * numberOfAssetsInRow) > 0) numberOfRowsInSection++;
        }
            break;
    }
    
    return numberOfRowsInSection;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch(indexPath.section) {
        case 0:
        {
            NSLog(@"cellforrow sec 0");
            NSString *cellIdentifier = @"HeaderCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            
            if (self.selectedAssets.count == self.assets.count) {
                cell.textLabel.text = [self.delegate descriptionForDeselectingAllAssets:self];
                
                // Set accessory view
                UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
                accessoryView.image = [UIImage imageNamed:@"QBImagePickerController.bundle/minus.png"];
                
                accessoryView.layer.shadowColor = [[UIColor colorWithWhite:0 alpha:1.0] CGColor];
                accessoryView.layer.shadowOpacity = 0.70;
                accessoryView.layer.shadowOffset = CGSizeMake(0, 1.4);
                accessoryView.layer.shadowRadius = 2;
                
                cell.accessoryView = accessoryView;
            } else {
                cell.textLabel.text = [self.delegate descriptionForSelectingAllAssets:self];
                
                // Set accessory view
                UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
                accessoryView.image = [UIImage imageNamed:@"QBImagePickerController.bundle/plus.png"];
                
                accessoryView.layer.shadowColor = [[UIColor colorWithWhite:0 alpha:1.0] CGColor];
                accessoryView.layer.shadowOpacity = 0.70;
                accessoryView.layer.shadowOffset = CGSizeMake(0, 1.4);
                accessoryView.layer.shadowRadius = 2;
                
                cell.accessoryView = accessoryView;
            }
        }
            break;
        case 1:
        {
            NSLog(@"cellforrow sec 1");
            NSString *cellIdentifier = @"SeparatorCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                // Set background view
                UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
                backgroundView.backgroundColor = [UIColor colorWithWhite:0.878 alpha:1.0];
                
                cell.backgroundView = backgroundView;
            }
        }
            break;
        case 2:
        {
            NSLog(@"cellforrow sec 2");
            NSString *cellIdentifier = @"AssetCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
                CGFloat margin = round((self.view.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
                
                cell = [[QBImagePickerAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier imageSize:self.imageSize numberOfAssets:numberOfAssetsInRow margin:margin];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [(QBImagePickerAssetCell *)cell setDelegate:self];
                [(QBImagePickerAssetCell *)cell setAllowsMultipleSelection:self.allowsMultipleSelection];
            }
            
            // Set assets
            NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
            NSInteger offset = numberOfAssetsInRow * indexPath.row;
            NSInteger numberOfAssetsToSet = (offset + numberOfAssetsInRow > self.assets.count) ? (self.assets.count - offset) : numberOfAssetsInRow;
            
            NSMutableArray *assets = [NSMutableArray array];
            for (NSUInteger i = 0; i < numberOfAssetsToSet; i++) {
                ALAsset *asset = [self.assets objectAtIndex:(offset + i)];
                
                [assets addObject:asset];
            }
            
            [(QBImagePickerAssetCell *)cell setAssets:assets];
            
            // Set selection states
            for (NSUInteger i = 0; i < numberOfAssetsToSet; i++) {
                ALAsset *asset = [self.assets objectAtIndex:(offset + i)];
                
                if ([self.selectedAssets containsObject:asset]) {
                    [(QBImagePickerAssetCell *)cell selectAssetAtIndex:i];
                    
                    
                } else {
                    [(QBImagePickerAssetCell *)cell deselectAssetAtIndex:i];
                }
            }
        }
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0;
    
    switch(indexPath.section) {
        case 0:
        {
            heightForRow = 44;
        }
            break;
        case 1:
        {
            heightForRow = 1;
        }
            break;
        case 2:
        {
            NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
            CGFloat margin = round((self.view.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
            heightForRow = margin + self.imageSize.height;
        }
            break;
    }
    
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.selectedAssets.count == self.assets.count) {
            // Deselect all assets
            [self.selectedAssets removeAllObjects];
        } else {
            // Select all assets
            [self.selectedAssets addObjectsFromArray:self.assets];
        }
        
        // Set done button state
        [self updateDoneButton];
        
        // Update assets
        if (self.showsFooterDescription) {
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        // Update header text
        if (self.showsHeaderButton) {
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        // Cancel table view selection
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - QBImagePickerAssetCellDelegate

- (BOOL)assetCell:(QBImagePickerAssetCell *)assetCell canSelectAssetAtIndex:(NSUInteger)index
{
//    NSLog(@"canSelectAssetAtIndex %d",index);
    BOOL canSelect = YES;
    
    if (self.allowsMultipleSelection && self.limitsMaximumNumberOfSelection) {
        canSelect = (self.selectedAssets.count < self.maximumNumberOfSelection);
    }
    NSLog(@"canSelect %@",canSelect?@"YES":@"NO");
    
    return canSelect;
}

- (void)assetCell:(QBImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index
{
    NSLog(@"didChangeAssetsState");
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:assetCell];
    
    NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
    NSInteger assetIndex = indexPath.row * numberOfAssetsInRow + index;
    ALAsset *asset = [self.assets objectAtIndex:assetIndex];
//    UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(assetCell.bounds.size.width-28, 0,28,28)];
//    overlayImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ph_badge_%02d.png",[self.selectedAssets count]+1]];
//    [assetCell.contentView addSubview:overlayImageView];
    
    if (self.allowsMultipleSelection) {
        if (selected) {
            NSLog(@"add");
            [self.selectedAssets addObject:asset];       
            
//            [assetCell addSubview:overlayImageView];
            
        } else {
            NSLog(@"Remove");
            [self.selectedAssets removeObject:asset];
//            [overlayImageView removeFromSuperview];
        }
        NSLog(@"selectedAssets %@",self.selectedAssets);
//        if(self.maximumNumberOfSelection>1){
//        if([self.selectedAssets count]>0)
            self.title = [NSString stringWithFormat:@"카메라롤 (%d/%d)",(int)[self.selectedAssets count],(int)self.maximumNumberOfSelection];
//        else
//            self.title = @"카메라롤";
//        NSLog(@"self.title %@",self.title);
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//        // Set done button state
//        }
        [self updateDoneButton];
        
        // Update header text
        if (self.showsHeaderButton) {
            NSLog(@"showsheader");
            if ((selected && self.selectedAssets.count == self.assets.count) ||
               (!selected && self.selectedAssets.count == self.assets.count - 1)) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    } else {
        NSLog(@"else");
        [self.delegate assetCollectionViewController:self didFinishPickingAsset:asset];
    }
}

@end
