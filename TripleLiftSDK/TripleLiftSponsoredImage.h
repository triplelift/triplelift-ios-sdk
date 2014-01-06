//
//  SponsoredImage.h
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripleLiftSponsoredImage : NSObject

- (id)initFromObject:(NSDictionary *)jsonObject inventoryCode:(NSString *)inventoryCode sponsoredContentID:(NSString *)contentID mobilePlatform:(NSString *)platform;

@property (readonly, copy) NSString *heading;
@property (readonly, copy) NSString *caption;
@property (readonly, copy) NSString *imgServerParams;
@property (readonly, copy) NSString *clickthroughLink;
@property (readonly) int imageWidth;
@property (readonly) int imageHeight;

- (NSString *)getImageURL;
- (NSString *)getImageURLWithWidth:(int)width;
- (NSString *)getImageURLWithWidth:(int)width height:(int)height;

- (UIImage *)getImage;
- (UIImage *)getImageWithWidth:(int)width;
- (UIImage *)getImageWithWidth:(int)width height:(int)height;

- (void)logImpression;
- (void)logImpressionWithError:(NSError **)errorPointer;

- (void)logClickthrough;
- (void)logClickthroughWithError:(NSError **)errorPointer;

- (void)logEvent:(NSString *)eventName;
- (void)logEvent:(NSString *)eventName error:(NSError **)errorPointer;

@end
