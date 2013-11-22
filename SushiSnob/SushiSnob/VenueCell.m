//
//  VenueCell.m
//  SushiSnob
//
//  Created by MasterRyuX on 6/15/13.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "VenueCell.h"
#import "VenueTableViewController.h"

@implementation VenueCell
{
    VenueTableViewController *venueTableViewController;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
