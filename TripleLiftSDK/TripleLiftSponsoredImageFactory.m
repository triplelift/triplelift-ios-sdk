//
//  SponsoredImageFactory.m
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import "TripleLiftSponsoredImageFactory.h"

static NSString *const AUCTION_ENDPOINT = @"http://ib.adnxs.com/ttj?inv_code=%@&member=1314";
static NSString *const SPONSORED_IMAGE_ENDPOINT = @"http://dynamic.3lift.com/sc/advertiser/json/%@";

@implementation TripleLiftSponsoredImageFactory {
    // private instance variables
    // api endpoints
    NSString *_appNexusAuctionEndpoint;
    NSString *_sponsoredImageEndpoint;
    // the publisher
    NSString *_inventoryCode;
    // array of image objects
    NSArray *_sponsoredImages;
}
- (id)init {
    self = [super init];
    return self;
}
- (id)initWithInventoryCode:(NSString *)inventoryCode{
    self = [super init];
    if(self) {
        _appNexusAuctionEndpoint = [NSString stringWithFormat:AUCTION_ENDPOINT, inventoryCode];
        _inventoryCode = inventoryCode;
    }
        
    return self;
}

- (TripleLiftSponsoredImage *)getSponsoredImage {
    return [self getSponsoredImageWithError:nil];
}
- (TripleLiftSponsoredImage *)getSponsoredImageWithError:(NSError **)errorPointer {
    // get creative code from auction endpoint
    NSURLRequest *auctionRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_appNexusAuctionEndpoint]];
    NSURLResponse *auctionResponse = nil;
    NSData *auctionData = [NSURLConnection sendSynchronousRequest: auctionRequest returningResponse: &auctionResponse error: errorPointer];
    if(auctionData == nil) {
        return nil;
    }
    
    NSString *creativeCode = [[NSString alloc] initWithData:auctionData encoding:NSUTF8StringEncoding];
    
    _sponsoredImageEndpoint = [NSString stringWithFormat:SPONSORED_IMAGE_ENDPOINT, creativeCode];
    
    // get the sponsored image data
    NSURLRequest *sponsoredImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_sponsoredImageEndpoint]];
    NSURLResponse *sponsoredImageResponse = nil;
    NSData *sponsoredImageData = [NSURLConnection sendSynchronousRequest: sponsoredImageRequest returningResponse: &sponsoredImageResponse error: errorPointer];
    if(sponsoredImageData == nil) {
        return nil;
    }
    
    NSString *jsonString = [[[NSString alloc] initWithData:sponsoredImageData encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *returnedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:errorPointer];
    
    if(returnedObject == nil) {
        NSString *domain = @"com.TripleLift.SponsoredImages.JSONFormatError";
        NSString *description = @"Returned response improperly formatted";
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : description };
        *errorPointer = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];
        return nil;
    }
    
    _sponsoredImages = [returnedObject objectForKey:@"images"];
    
    if(_sponsoredImages) {
        NSDictionary *imageDictionary = [_sponsoredImages objectAtIndex:arc4random_uniform([_sponsoredImages count])];
        
        TripleLiftSponsoredImage *sponsoredImage = [[TripleLiftSponsoredImage alloc] initFromObject:imageDictionary
                                                                                      inventoryCode:_inventoryCode
                                                                                 sponsoredContentID:creativeCode
                                                                                     mobilePlatform:@"ios"];
        return sponsoredImage;
    } else {
        NSString *domain = @"com.TripleLift.SponsoredImages.JSONFormatError";
        NSString *description = @"Returned response missing image data";
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : description };
        *errorPointer = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];
    }
    return nil;
}

@end
