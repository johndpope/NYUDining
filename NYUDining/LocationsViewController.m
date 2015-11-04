//
//  LocationsViewController.m
//  NYUDining
//
//  Created by Ross Freeman on 9/8/15.
//  Copyright (c) 2015 Ross Freeman. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationDetailViewController.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:12.0 target:self selector:@selector(showAlert) userInfo:nil repeats:NO];
    
    _diningLocations = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self grabInformationFromServer];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.locationTable reloadData];
    
    for (NSIndexPath *indexPath in _locationTable.indexPathsForSelectedRows) {
        [_locationTable deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)grabInformationFromServer {
    _query = [PFQuery queryWithClassName:@"Locations"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [_timer invalidate];
            
            for (PFObject *object in objects) {
                DiningLocation *location = [[DiningLocation alloc] initWithData:object];
                [_diningLocations addObject:location];
            }
            
            _diningLocations = [[_diningLocations sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *name1 = [(DiningLocation *)a name];
                NSString *name2 = [(DiningLocation *)b name];
                return [name1 compare:name2];
                
            }] mutableCopy];
            
            [self.locationTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action) {
                                                                    [self viewDidLoad];
                                                                }];
            [alert addAction:retryAction];
            [self presentViewController:alert animated:YES completion:^{}];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)showAlert {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [_query cancel];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connection Error"
                                                                   message:@"It looks like you're not connected to the internet :("
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self grabInformationFromServer];
                                                        }];
    [alert addAction:retryAction];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)_diningLocations.count);
    return _diningLocations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"location"];
    
    cell.textLabel.text = [_diningLocations[indexPath.row] name];
    NSLog(@"%@", [_diningLocations[indexPath.row] name]);
    
    if ([_diningLocations [indexPath.row] isOpen] == YES) {
        cell.detailTextLabel.text = @"Open";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.133f green:0.580f blue:0.282f alpha:1.00f];
    }
    
    else if ([_diningLocations [indexPath.row] isOpenTest] == NO) {
        cell.detailTextLabel.text = @"Closed";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    else {
        cell.detailTextLabel.text = @"Unknown";
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetails" sender:indexPath];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = (NSIndexPath *)sender;
    
    DiningLocation *selectedLocation = _diningLocations[path.row];
    LocationDetailViewController *dest = segue.destinationViewController;
    dest.location = selectedLocation;
}


@end
