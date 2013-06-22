//
//  MySushiMapPictureViewController.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-11.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySushiMapPictureViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *fileName;

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *documentsDirectory;
@end
