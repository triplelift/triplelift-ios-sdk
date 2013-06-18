//
//  TripleLiftAppViewController.m
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/29/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import "TripleLiftAppViewController.h"

@interface TripleLiftAppViewController ()

@end

@implementation TripleLiftAppViewController {
    TripleLiftSponsoredImageFactory *_sponsoredImageFactory;
    TripleLiftSponsoredImage *_sponsoredImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create the sponsored image factory with tag code and publisher
    _sponsoredImageFactory = [[TripleLiftSponsoredImageFactory alloc] initWithTagCode:@"defaultplacement_mobile" publisher:@"TripleLift Test App"];
    
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self.informationImage addSubview:imageHolder];
    // add tap recognizer to capture taps on the image
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [imageHolder addGestureRecognizer:tapRecognizer];
    imageHolder.userInteractionEnabled = NO;
    
    [self createSponsoredImageUnit];
}

// private method
- (void)createSponsoredImageUnit {
    UIImageView *imageHolder = (UIImageView *)[self.informationImage.subviews objectAtIndex:0];
    imageHolder.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = [[NSError alloc] init];
        _sponsoredImage = [_sponsoredImageFactory getSponsoredImageWithError:&error];
        if(_sponsoredImage == nil) {
            NSLog(@"%@", error);
            return;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // set the text on the main thread
            self.informationLabel.text = _sponsoredImage.caption;
            
            // load the actual image from the remote location
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [_sponsoredImage getImageWithWidth:150 height:150];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // replace the image on the main thread
                    imageHolder.image = image;
                    
                    imageHolder.userInteractionEnabled = YES;
                    
                    // log the impression
                    [_sponsoredImage logImpression];
                });
            });
        });
    });
}

- (IBAction)shareButtonPressed:(id)sender {
    NSLog(@"share button pressed");
    
    [_sponsoredImage logEvent:@"share"];
    // do additional share logic below
}
- (IBAction)likeButtonPressed:(id)sender {
    NSLog(@"like button pressed");
    
    [_sponsoredImage logEvent:@"like"];
    // do additional like logic below
}

- (IBAction)refreshButtonPressed:(id)sender {
    NSLog(@"refreshing!");
    [self createSponsoredImageUnit];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"clicking through!");
    [_sponsoredImage logClickthrough];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _sponsoredImage.clickthroughLink]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
