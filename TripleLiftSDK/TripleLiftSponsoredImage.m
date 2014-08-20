//
//  SponsoredImage.m
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import "TripleLiftSponsoredImage.h"

@interface TripleLiftSponsoredImage ()

@property (nonatomic) NSOperationQueue *queue;

@end

@implementation TripleLiftSponsoredImage

- (id)initFromObject:(NSDictionary *)serverInfo mobilePlatform:(NSString *)platform
{
    self = [super init];
    if (self) {
        _advertiser_name    = TPL_SAFE_STRING(serverInfo[@"advertiser_name"]);
        _caption            = TPL_SAFE_STRING(serverInfo[@"caption"]);
        _clickthroughLink   = TPL_SAFE_STRING(serverInfo[@"clickthrough_url"]);
        _imageUrl           = TPL_SAFE_STRING(serverInfo[@"image_url"]);
        _imageThumbnailUrl  = TPL_SAFE_STRING(serverInfo[@"image_thumbnail_url"]);
        
        _impressionPixels   = TPL_SAFE_CAST([NSArray class], serverInfo[@"impression_pixels"]);
        _clickthroughPixels = TPL_SAFE_CAST([NSArray class], serverInfo[@"clickthrough_pixels"]);
        _interactionPixels  = TPL_SAFE_CAST([NSArray class], serverInfo[@"interaction_pixels"]);
        
        _sharePixels = TPL_SAFE_CAST([NSDictionary class], serverInfo[@"share_pixels"]);
        
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (UIImage *)getImage
{
    return [self doGetImage:self.imageUrl];
}

- (UIImage *)getImageThumbnail
{
    return [self doGetImage:self.imageThumbnailUrl];
}

- (UIImage *)doGetImage:(NSString *)imageUrl
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    return [UIImage imageWithData:imageData];
}

- (void)logImpression {
    for (NSString *impressionURL in self.impressionPixels) {
        [self makeGenericRequest:impressionURL];
    }
}

- (void)logClickthrough
{
    for (NSString *clickthroughURL in self.clickthroughPixels) {
        [self makeGenericRequest:clickthroughURL];
    }
}

- (void)logInteraction
{
    for (NSString *interactionURL in self.interactionPixels) {
        [self makeGenericRequest:interactionURL];
    }
}

- (void)logShare:(NSString *)shareType;
{
    NSString *shareURL = self.sharePixels[shareType];
    if (shareURL) {
        [self makeGenericRequest:shareURL];
    }
}

#pragma mark - Private methods

- (NSString *)urlEncode:(NSString *)unencodedString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unencodedString, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
}

- (NSString *)urlDecode:(NSString *)encodedString
{
    return [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)makeGenericRequest:(NSString *)url
{
    // properly escape the urls before requesting
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if ([httpResponse statusCode] == 200) {
                               } else {
                                   if (error) {
                                       NSLog(@"Error encountered: %@",error.description);
                                   } else {
                                       NSLog(@"Error encountered: unknown HTTP error");
                                   }
                               }
                           }];
}

#pragma mark - Helper functions

id TPL_SAFE_CAST(Class klass, id obj)
{
    return [obj isKindOfClass:klass]? obj : nil;
}

id TPL_SAFE_STRING(id obj)
{
    return TPL_SAFE_CAST([NSString class], obj);
}



@end
