//
//  VenueCell.h
//  SushiSnob
//
//  Created by Craig on 6/15/13.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *venueName;
@property (strong, nonatomic) IBOutlet UILabel *venueAddress;
@property (strong, nonatomic) IBOutlet UILabel *venueDistance;

@end
