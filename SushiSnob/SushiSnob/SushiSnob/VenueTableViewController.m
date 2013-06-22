//
//  VenueTableViewController.m
//  SushiSnob
//
//  Created by Craig on 6/8/13.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "VenueTableViewController.h"
#import "TabMapViewController.h"


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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"venue";
    UITableViewCell* tableViewCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"venue" forIndexPath:indexPath];
    
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    VenueObject *venueObject = [distanceSortedArray objectAtIndex:indexPath.row];
    
    tableViewCell.textLabel.text = venueObject.venueName;
    tableViewCell.detailTextLabel.text = venueObject.address;
    return tableViewCell;

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
