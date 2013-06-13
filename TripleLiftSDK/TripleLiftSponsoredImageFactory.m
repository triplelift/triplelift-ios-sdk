//
//  SponsoredImageFactory.m
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import "TripleLiftSponsoredImageFactory.h"

@implementation TripleLiftSponsoredImageFactory {
    // private instance variables
    // api endpoints
    NSString *_appNexusAuctionEndpoint;
    NSString *_sponsoredImageEndpoint;
    // the publisher
    NSString *_publisher;
    // array of image objects
    NSArray *_sponsoredImages;
}
- (id)init {
    self = [super init];
    return self;
}
- (id)initWithTagCode:(NSString *)tagCode publisher:(NSString *)publisher{
    self = [super init];
    if(self) {
        _appNexusAuctionEndpoint = [NSString stringWithFormat:@"http://ib.adnxs.com/ttj?inv_code=%@&member=1314", tagCode];
        _publisher = publisher;
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
    
    _sponsoredImageEndpoint = [NSString stringWithFormat:@"http://dynamic.3lift.com/live_stream/%@", creativeCode];
    // get the sponsored image data
    NSURLRequest *sponsoredImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_sponsoredImageEndpoint]];
    NSURLResponse *sponsoredImageResponse = nil;
    NSData *sponsoredImageData = [NSURLConnection sendSynchronousRequest: sponsoredImageRequest returningResponse: &sponsoredImageResponse error: errorPointer];
    if(sponsoredImageData == nil) {
        return nil;
    }
    
    NSString *sponsoredImageString = [[NSString alloc] initWithData:sponsoredImageData encoding:NSUTF8StringEncoding];
    //get the response and then parse out the json string
    if([sponsoredImageString hasPrefix:@"live_stream("] && [sponsoredImageString hasSuffix:@");"]) {
        NSString *jsonString = [sponsoredImageString substringWithRange:NSMakeRange(12, ([sponsoredImageString length] - 14))];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *returnedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:errorPointer];
        
        if(returnedObject == nil) {
            return nil;
        }
        
        _sponsoredImages = [returnedObject objectForKey:@"trending_items"];
        
        if(_sponsoredImages) {
            NSDictionary *imageDictionary = [_sponsoredImages objectAtIndex:arc4random_uniform([_sponsoredImages count])];
            
            TripleLiftSponsoredImage *sponsoredImage = [[TripleLiftSponsoredImage alloc] initFromObject:imageDictionary
                                                                                              publisher:_publisher
                                                                                       sponsoredContentID:creativeCode
                                                                                         mobilePlatform:@"ios"];
            return sponsoredImage;
        }
    } else {
        NSString *domain = @"com.TripleLift.SponsoredImages.LiveStreamFormatError";
        NSString *description = @"returned response improperly formatted";
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : description };
        *errorPointer = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];;
    }
    return nil;
}

@end
