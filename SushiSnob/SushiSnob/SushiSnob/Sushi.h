//
//  Sushi.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sushi : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * japaneseName;
@property (nonatomic, retain) NSString * sushiDescription;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSData * sushiImage;
@property (nonatomic, retain) NSNumber * isRatedGood;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSData * cannonicalURL;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
