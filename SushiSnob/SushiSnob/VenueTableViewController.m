//
//  VenueTableViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 6/8/13.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "VenueTableViewController.h"
#import "TabMapViewController.h"
#import "VenueCell.h"


@interface VenueTableViewController ()

@end
VenueObject *selectedVenue;


@implementation VenueTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return distanceSortedArray.count;
    NSLog(@"%i count", distanceSortedArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"venue";
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[VenueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    VenueObject *venueObject = [distanceSortedArray objectAtIndex:indexPath.row];
    cell.venueAddress.text = venueObject.subtitle;
    cell.venueName.text = venueObject.title;
    float distanceInMeters = [venueObject.distance floatValue];
    float mileDistance = distanceInMeters * 0.00062137;
    cell.venueDistance.text = [NSString stringWithFormat:@"%0.2f miles", mileDistance];
    
    NSLog(@"distance as string: %@", [NSString stringWithFormat:@"%f", mileDistance]);
    
    
;
    
        
    NSLog(@"%@ distance", venueObject.distance);
    
   // cell.venueDistance.text = venueObject.distance;
    
    
    
    NSLog(@"the array: %@", venueObject.title);
    NSLog(@"test");


    return cell;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tableToWebView"]) {
        MapVenueWebViewViewController *mapVenueWebViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.venueTableView indexPathForSelectedRow];
        VenueObject *selectedVenue = [distanceSortedArray objectAtIndex:indexPath.row];
        mapVenueWebViewController.fourSquareVenueWebPage = selectedVenue.fourSquareVenuePage;

    }
}


@end
