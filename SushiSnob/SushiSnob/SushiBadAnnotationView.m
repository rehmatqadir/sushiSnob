//
//  SushiBadAnnotationView.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-17.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "SushiBadAnnotationView.h"

@implementation SushiBadAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [UIImage imageNamed:@"thumbsDownPink.png"];
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
