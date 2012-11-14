//
//  Networking.m
//  iMeetMe
//
//  Created by Eduard Feicho on 14.11.12.
//  Copyright (c) 2012 Eduard Feicho. All rights reserved.
//

#import "Networking.h"
#import "NSString+URL.h"

@implementation Networking

@synthesize url_path;



const NSString* SERVER_IP = @"martinmatysiak.de";
const NSInteger SERVER_PORT = 10101;


+(Networking*)createGetRequestTo:(NSString*)path withVariables:(NSDictionary*)variables;
{
    Networking* result = [[Networking alloc] init];
    
    NSMutableString* variables_string = [NSMutableString stringWithString:@""];
    
    NSArray* keys = [variables allKeys];
    NSEnumerator* e = [keys objectEnumerator];
    NSString* key;
    while (key = [e nextObject]) {
        [variables_string appendFormat:@"%@=%@&",key, [(NSString*)[variables objectForKey:key] urlencode] ];
    }
    
    result.url_path = [NSString stringWithFormat:@"http://%@:%d/meetme/%@?%@", SERVER_IP, SERVER_PORT, path, variables_string];
    
    return result;
}



- (void)startAsyncRequestWithObject:(id)object andCallback:(SEL)selector;
{
    NSLog(@"Sending GET to %@", self.url_path);
    NSURL* url = [NSURL URLWithString:self.url_path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [[NSURLConnection connectionWithRequest:request delegate:self] start];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error){
         if (error) {
             NSLog(@"[ERROR] connection failed: %@", [error localizedDescription]);
         } else {
             [object performSelectorOnMainThread:selector withObject:data waitUntilDone:NO];
         }
     }
    ];
    
}



#pragma mark - Protocol NSURLConnectionDelegate



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    NSLog(@"[ERROR] connection failed: %@", [error userInfo]);
}



@end
