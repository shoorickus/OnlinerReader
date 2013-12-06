//
//  ExtendedURL.m
//  OnlinerReader
//
//  Created by Alexander Dyubkin on 05.12.13.
//  Copyright (c) 2013 Dmitry Savitskiy. All rights reserved.
//

#import "ExtendedURL.h"

@implementation ExtendedURL

-(id)initWithStringUrl:(NSString *)url caption:(NSString *)caption help:(NSString *)help {
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:url];
        self.caption = caption;
        self.help = help;
    }
    return self;
}

@end
