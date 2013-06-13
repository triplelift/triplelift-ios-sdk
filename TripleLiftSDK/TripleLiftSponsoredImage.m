//
//  SponsoredImage.m
//  TripleLiftApp
//
//  Created by Brian D Lee on 5/31/13.
//  Copyright (c) 2013 Triple Lift. All rights reserved.
//

#import "TripleLiftSponsoredImage.h"

// private class constants
static NSString *const IMPRESSION_ENDPOINT = @"http://eb.3lift.com/mbi?id=%@&ii=%@&publisher=%@&&platform=%@";
static NSString *const CLICKTHROUGH_ENDPOINT = @"http://eb.3lift.com/mbc?id=%@&ii=%@&publisher=%@&&platform=%@";
static NSString *const EVENT_ENDPOINT = @"http://eb.3lift.com/mbs?id=%@&ii=%@&publisher=%@&&platform=%@&&st=%@";

@implementation TripleLiftSponsoredImage {
    // private instance variables
    NSString *_publisher;
    NSString *_contentID;
    NSString *_platform;
    NSString *_imageID;
    NSString *_imageExtension;
    NSString *_adpinrImageURL;
    
    // encoded variables for url
    NSString *_encodedPublisher;
    NSString *_encodedContentID;
    NSString *_encodedPlatform;
    NSString *_encodedImageID;
}

- (id)initFromObject:(NSDictionary *)jsonObject publisher:(NSString *)publisher sponsoredContentID:(NSString *)contentID mobilePlatform:(NSString *)platform{
    self = [super init];
    
    _publisher = publisher;
    _contentID = contentID;
    _platform = platform;
    _imageID = [jsonObject objectForKey:@"id"];
    _imageExtension = [jsonObject objectForKey:@"extension"];
    _imageWidth = [[jsonObject objectForKey:@"width"] intValue];
    _imageHeight = [[jsonObject objectForKey:@"height"] intValue];
    _caption = [jsonObject objectForKey:@"caption"];
    _fullCaption = [jsonObject objectForKey:@"full_caption"];
    _clickthroughLink = [self urlDecode:[jsonObject objectForKey:@"link"]];
    
    _adpinrImageURL = [NSString stringWithFormat:@"http://images.adpinr.com/%@%@",_imageID,_imageExtension];
    
    _encodedPublisher = [self urlEncode:_publisher];
    _encodedContentID = [self urlEncode:_contentID];
    _encodedPlatform = [self urlEncode:_platform];
    _encodedImageID = [self urlEncode:_imageID];
    
    return self;
}

- (NSString *)getImageURL {
    return [self getImageURLWithWidth:self.imageWidth height:self.imageHeight];
}
- (NSString *)getImageURLWithWidth:(int)width {
    int height = self.imageWidth * self.imageHeight / width;
    return [self getImageURLWithWidth:width height:height];
}
- (NSString *)getImageURLWithWidth:(int)width height:(int)height {
    NSString *encodedAdpinrURL = [self urlEncode:_adpinrImageURL];
    
    return [NSString stringWithFormat:@"http://img.3lift.com/?width=%d&height=%d&url=%@",width,height,encodedAdpinrURL];
}

- (UIImage *)getImage {
    return [self getImageWithWidth:self.imageWidth height:self.imageHeight];
}
- (UIImage *)getImageWithWidth:(int)width {
    int height = self.imageWidth * self.imageHeight / width;
    return [self getImageWithWidth:width height:height];
}
- (UIImage *)getImageWithWidth:(int)width height:(int)height {
    NSString *imageURL = [self getImageURLWithWidth:width height:height];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

- (void)logImpression {
    return [self logImpressionWithError:nil];
}
- (void)logImpressionWithError:(NSError **)errorPointer {
    NSString *impressionURL = [NSString stringWithFormat:IMPRESSION_ENDPOINT,_encodedContentID,_encodedImageID,_encodedPublisher,_encodedPlatform];
    [self makeGenericRequest:impressionURL error:errorPointer];
    return;
}

- (void)logClickthrough {
    return [self logClickthroughWithError:nil];
}
- (void)logClickthroughWithError:(NSError **)errorPointer {
    NSString *clickthroughURL = [NSString stringWithFormat:CLICKTHROUGH_ENDPOINT,_encodedContentID,_encodedImageID,_encodedPublisher,_encodedPlatform];
    [self makeGenericRequest:clickthroughURL error:errorPointer];
    return;
}

- (void)logEvent:(NSString *)eventName {
    return [self logEvent:eventName error:nil];
}
- (void)logEvent:(NSString *)eventName error:(NSError **)errorPointer {
    NSString *encodedEventName = [self urlEncode:eventName];
    NSString *eventURL = [NSString stringWithFormat:EVENT_ENDPOINT,_encodedContentID,_encodedImageID,_encodedPublisher,_encodedPlatform,encodedEventName];
    [self makeGenericRequest:eventURL error:errorPointer];
    return;
}

// private functions
- (NSString *)urlEncode:(NSString *)unencodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unencodedString, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
}
- (NSString *)urlDecode:(NSString *)encodedString {
    return [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (void)makeGenericRequest:(NSString *)url error:(NSError **)errorPointer {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if ([httpResponse statusCode] == 200) {
                               } else {
                                   if(error) {
                                       NSLog(@"Error encountered: %@",error.description);
                                   }
                               }
                           }];
}

@end
