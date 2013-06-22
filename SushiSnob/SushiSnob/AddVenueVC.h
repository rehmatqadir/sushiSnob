//
//  AddVenueVC.h
//  SushiSnob
//
//  Created by Craig on 6/11/13.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueObject.h"
#import "AddSushiViewController.h"
#import "TabMapViewController.h"
#import "VenueDelegate.h"

@interface AddVenueVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (retain, nonatomic) id<VenueDelegate>venueDelegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *venueTextField;
- (IBAction)addVenueWithButton:(id)sender;



@end

NSString *selectedSushiVenue;
NSString *sushiAddress;