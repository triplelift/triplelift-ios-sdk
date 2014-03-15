//
//  SponsoredImageFactory.m
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import "TripleLiftSponsoredImageFactory.h"

static NSString *const IBP_ENDPOINT = @"http://ibp.3lift.com/ttj?inv_code=%@";

@implementation TripleLiftSponsoredImageFactory {
    // private instance variables
    // api endpoints
    NSString *_ibp_endpoint;
    // the publisher
    NSString *_inventoryCode;
}
- (id)init {
    self = [super init];
    return self;
}
- (id)initWithInventoryCode:(NSString *)inventoryCode{
    self = [super init];
    if(self) {
        _ibp_endpoint = [NSString stringWithFormat:IBP_ENDPOINT, inventoryCode];
        _inventoryCode = inventoryCode;
    }
        
    return self;
}

- (TripleLiftSponsoredImage *)getSponsoredImage {
    return [self getSponsoredImageWithError:nil];
}
- (TripleLiftSponsoredImage *)getSponsoredImageWithError:(NSError **)errorPointer {
    // get the sponsored image data
    NSURLRequest *sponsoredImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_ibp_endpoint]];
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
    } else {
        TripleLiftSponsoredImage *sponsoredImage = [[TripleLiftSponsoredImage alloc] initFromObject:returnedObject
                                                                                     mobilePlatform:@"ios"];
        return sponsoredImage;
    }
    return nil;
}

@end
