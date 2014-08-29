//
//  SponsoredImageFactory.m
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import "TripleLiftSponsoredImageFactory.h"

static NSString *const IBP_ENDPOINT     = @"http://ibp.3lift.com/ttj?inv_code=%@";

@interface TripleLiftSponsoredImageFactory ()

// API endpoint
@property (nonatomic, readonly) NSString *ibpEndpoint;

// the TripleLift placement identification code
@property (nonatomic) NSString *inventoryCode;

@end

@implementation TripleLiftSponsoredImageFactory

- (id)initWithInventoryCode:(NSString *)inventoryCode{
    self = [super init];
    if (self) {
        _inventoryCode = inventoryCode;
    }
    return self;
}

- (NSString *)ibpEndpoint
{
    NSString *endpoint = [NSString stringWithFormat:IBP_ENDPOINT, self.inventoryCode];
    
    NSLog(@"former endpoint: %@", endpoint);
    if (self.impressionBusParameters.count > 0) {
        for(NSString *key in [self.impressionBusParameters allKeys]) {
            NSString *value = [self.impressionBusParameters objectForKey:(key)];
            endpoint = [NSString stringWithFormat:@"%@&%@=%@",endpoint,key,value];
        }
    }
    NSLog(@"new endpoint: %@", endpoint);
    
    return endpoint;
}

- (TripleLiftSponsoredImage *)getSponsoredImage
{
    return [self getSponsoredImageWithError:nil];
}

- (TripleLiftSponsoredImage *)getSponsoredImageWithError:(NSError **)errorPointer
{
    NSURLRequest *sponsoredImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.ibpEndpoint]];
    NSURLResponse *sponsoredImageResponse;
    NSData *sponsoredImageData = [NSURLConnection sendSynchronousRequest:sponsoredImageRequest
                                                       returningResponse:&sponsoredImageResponse
                                                                   error:errorPointer];
    if(!sponsoredImageData) {
        return nil;
    }
    
    NSDictionary *returnedObject = [NSJSONSerialization JSONObjectWithData:sponsoredImageData options:0 error:errorPointer];
    
    if(!returnedObject) {
        return nil;
    }
    
    TripleLiftSponsoredImage *sponsoredImage = [[TripleLiftSponsoredImage alloc] initFromObject:returnedObject
                                                                                 mobilePlatform:@"ios"];
    if (!sponsoredImage) {
        NSString *domain = @"com.TripleLift.SponsoredImages.ObjectInitializationError";
        NSString *description = @"There was a problem initializing the sponsored image.";
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : description };
        *errorPointer = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];
    }
    
    return sponsoredImage;
}

@end
