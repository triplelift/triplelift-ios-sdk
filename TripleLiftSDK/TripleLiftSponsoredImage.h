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

@property (nonatomic, readonly, copy) NSString *advertiser_name;
@property (nonatomic, readonly, copy) NSString *heading;
@property (nonatomic, readonly, copy) NSString *caption;
@property (nonatomic, readonly, copy) NSString *clickthroughLink;

@property (nonatomic, readonly, copy) NSString *imageUrl;
@property (nonatomic, readonly, copy) NSString *imageThumbnailUrl;

@property (nonatomic, readonly) NSArray *impressionPixels;
@property (nonatomic, readonly) NSArray *clickthroughPixels;
@property (nonatomic, readonly) NSArray *interactionPixels;
@property (nonatomic, readonly) NSDictionary *sharePixels;

- (UIImage *)getImage;
- (UIImage *)getImageThumbnail;

- (void)logImpression;
- (void)logClickthrough;
- (void)logInteraction;
- (void)logShare:(NSString *)shareType;

@end
