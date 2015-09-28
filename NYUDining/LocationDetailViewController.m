//
//  LocationDetailViewController.m
//  NYUDining
//
//  Created by Ross Freeman on 9/24/15.
//  Copyright © 2015 Ross Freeman. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _location.name;
    
    NSString *urlString = _location.logoURL;
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    _locationLogo.image = [UIImage imageWithData:data];
    
    
    if ([_location isOpen]) {
        _locationStatusLabel.text = @"Open";
        _locationStatusLabel.textColor = [UIColor colorWithRed:0.133f green:0.580f blue:0.282f alpha:1.00f];
    }
    
    else {
        _locationStatusLabel.text = @"Closed";
        _locationStatusLabel.textColor = [UIColor redColor];
    }
    
    
    // Create a GMSCameraPosition that tells the map to display the
   // coordinate -33.86,151.20 at zoom level 6.
    
    double x = [_location.coordinates[0] doubleValue];
    double y = [_location.coordinates[1] doubleValue];
   
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:x
                                                            longitude:y
                                                                 zoom:16];
    
    _mapView.frame = CGRectZero;
    _mapView.camera = camera;
    
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(x, y);
    marker.title = _location.name;
    marker.snippet = _location.address;
    marker.map = _mapView;
    
    _mapView.selectedMarker = marker;
     
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
