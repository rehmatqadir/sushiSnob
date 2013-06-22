//
//  VenueDelegate.h
//  SushiSnob
//
//  Created by Craig on 6/11/13.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VenueDelegate <NSObject>

-(void)updateVenueLabel:(NSString *)venue address:(NSString*)address;

@end
