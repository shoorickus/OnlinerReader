//
//  ExtendedURL.h
//  OnlinerReader
//
//  Created by Alexander Dyubkin on 05.12.13.
//  Copyright (c) 2013 Dmitry Savitskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtendedURL : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *help;

- (id)initWithStringUrl:(NSString *)url caption:(NSString *)caption help:(NSString *)help;
@end
