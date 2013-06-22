//
//  SushiCell.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SushiCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *sushiName;
@property (strong, nonatomic) IBOutlet UILabel *sushiDate;
@property (strong, nonatomic) IBOutlet UILabel *sushiRestauraunt;
@property (strong, nonatomic) IBOutlet UILabel *sushiNameJapanese;
@property (strong, nonatomic) IBOutlet UIImageView *sushiImageView;

@end
