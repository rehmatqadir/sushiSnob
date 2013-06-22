//
//  AddSushiDelegate.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-07.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddSushiDelegate <NSObject>

-(void) addSushiName:(NSString*)sushiName
addSushiPicture: (UIImage*) sushiPicutre
        addSushiDate: (NSDate*) sushiDate
   addSushiGoodOrNot: (BOOL) sushiGoodOrNot
addSushiVenue: (NSString*)sushiVenue
 addSushiDescription: (NSString*) sushiDescription
addSushiAddress: (NSString*) sushiAddress
         addLatitude: (float) latitude
        addLongitude: (float) longitude;

@end
