//
//  SponsoredImageFactory.h
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripleLiftSponsoredImage.h"

@interface TripleLiftSponsoredImageFactory : NSObject

- (id)initWithTagCode:(NSString *)tagCode publisher:(NSString *)publisher;

- (TripleLiftSponsoredImage *)getSponsoredImage;
- (TripleLiftSponsoredImage *)getSponsoredImageWithError:(NSError **)errorPointer;

@end
