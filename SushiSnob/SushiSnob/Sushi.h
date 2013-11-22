//
//  Sushi.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-18.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sushi : NSManagedObject

@property (nonatomic, retain) NSData * cannonicalURL;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isRatedGood;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * sushiImage;
@property (nonatomic, retain) NSString * sushiImageURL;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * sushiDescription;

@end
