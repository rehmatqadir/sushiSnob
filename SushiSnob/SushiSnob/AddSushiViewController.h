//
//  AddSushiViewController.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSushiDelegate.h"
//for picture taking
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import "AddVenueVC.h"
#import "VenueDelegate.h"



@interface AddSushiViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, VenueDelegate>



//for pic taking
@property (strong, nonatomic) IBOutlet UIView *sushiPictureViewHolder;
@property (strong, nonatomic) IBOutlet UIImageView *sushiPic;
@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UILabel *addSushiPictureLabel;
@property (weak, nonatomic) IBOutlet UIView *takePictureView;
@property (weak, nonatomic) IBOutlet UIImageView *takePictureViewImageView;

//for sushi name
@property (strong, nonatomic) IBOutlet UITextField *sushiNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *sushiNameLabel;
@property (weak, nonatomic) IBOutlet UIView *addSushiNameView;
@property (weak, nonatomic) IBOutlet UIImageView *addSushiNameImageView;

//for venue
@property (strong, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UIView *addVenueView;
@property (weak, nonatomic) IBOutlet UIImageView *addVenueViewImageView;
@property (strong, nonatomic) NSString *sushiAddress;

//good or bad
@property (weak, nonatomic) IBOutlet UIView *thumbsUpView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbsUpImageView;
@property (weak, nonatomic) IBOutlet UIView *thumbsDownView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbsDownImageView;
@property (weak, nonatomic) IBOutlet UILabel *enjoyItLabel;
@property (nonatomic) BOOL sushiIsGood;

//type
@property (weak, nonatomic) IBOutlet UIView *rollView;
@property (weak, nonatomic) IBOutlet UIImageView *rollImageView;
@property (weak, nonatomic) IBOutlet UIView *sushiView;
@property (weak, nonatomic) IBOutlet UIImageView *sushiImageView;
@property (weak, nonatomic) IBOutlet UIView *sashimiView;
@property (weak, nonatomic) IBOutlet UIImageView *sashimiImageView;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UIImageView *otherImageView;
@property (weak, nonatomic) IBOutlet UILabel *sushiTypeLabel;

@property (strong, nonatomic) NSString *sushiDescription;

@property (strong, nonatomic) id <AddSushiDelegate> addSushiDelegate;

//nav bar
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet NSString *sushiCityName;

- (IBAction)doneAddingSushi:(id)sender;
- (IBAction)cancelAddingSushi:(id)sender;

//- (IBAction)changeSushiGoodOrNot:(id)sender;

- (IBAction)add4QVenue:(id)sender;

@end

//NSArray *distanceSortedArray;
