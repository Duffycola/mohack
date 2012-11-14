//
//  Networking.h
//  iMeetMe
//
//  Created by Eduard Feicho on 14.11.12.
//  Copyright (c) 2012 Eduard Feicho. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface Networking : NSObject<NSURLConnectionDelegate>
{
    NSString* url_path;
}

@property (nonatomic, retain) NSString* url_path;


+(Networking*)createGetRequestTo:(NSString*)path withVariables:(NSDictionary*)variables;
- (void)startAsyncRequestWithObject:(id)object andCallback:(SEL)selector;


@end
