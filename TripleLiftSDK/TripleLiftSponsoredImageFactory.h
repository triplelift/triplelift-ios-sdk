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

- (id)initWithInventoryCode:(NSString *)inventoryCode;

// This method contains a synchronous network request, and
// should be run asynchronously in a background queue.
- (TripleLiftSponsoredImage *)getSponsoredImage;
- (TripleLiftSponsoredImage *)getSponsoredImageWithError:(NSError **)errorPointer;

@property (nonatomic, assign) NSDictionary *impressionBusParameters;

@end
