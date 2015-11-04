//
//  LocationsViewController.h
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DiningLocation.h"

@interface LocationsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *locationTable;
@property (strong, nonatomic) NSMutableArray *diningLocations;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) PFQuery *query;

- (void)showAlert;
- (void)grabInformationFromServer;

@end
