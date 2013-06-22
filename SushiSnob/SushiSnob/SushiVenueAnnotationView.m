//
//  SushiVenueAnnotationView.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-15.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "SushiVenueAnnotationView.h"

@implementation SushiVenueAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [UIImage imageNamed:@"sushiPin.png"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
