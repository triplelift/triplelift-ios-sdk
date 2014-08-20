//
//  SponsoredImage.h
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripleLiftSponsoredImage : NSObject

- (id)initFromObject:(NSDictionary *)jsonObject mobilePlatform:(NSString *)platform;

@property (readonly, copy) NSString *advertiser_name;
@property (readonly, copy) NSString *heading;
@property (readonly, copy) NSString *caption;
@property (readonly, copy) NSString *clickthroughLink;

@property (readonly, copy) NSString *imageUrl;
@property (readonly, copy) NSString *imageThumbnailUrl;

@property (readonly, copy) NSArray *impressionPixels;
@property (readonly, copy) NSArray *clickthroughPixels;
@property (readonly, copy) NSArray *interactionPixels;
@property (readonly, copy) NSArray *sharePixels;

- (UIImage *)getImage;
- (UIImage *)getImageThumbnail;

- (void)logImpression;
- (void)logClickthrough;
- (void)logInteraction;
- (void)logShare;


@end
