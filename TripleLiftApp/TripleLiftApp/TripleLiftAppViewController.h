//
//  TripleLiftAppViewController.h
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/29/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripleLiftSponsoredImageFactory.h"
#import "TripleLiftSponsoredImage.h"

@interface TripleLiftAppViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIView *informationImage;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)likeButtonPressed: (id)sender;
- (IBAction)refreshButtonPressed: (id)sender;

@end
