//
//  VenueTableViewController.h
//  SushiSnob
//
//  Created by Craig on 6/8/13.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabMapViewController.h"
#import "VenueObject.h"
#import "MapVenueWebViewViewController.h"

@interface VenueTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *venueTableView;
//@property (strong, nonatomic) VenueObject *venueFSWeb;




@end
