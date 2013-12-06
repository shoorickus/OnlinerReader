//
//  GroupOfNewsFactory.m
//  OnlinerReader
//
//  Created by Alexander Dyubkin on 05.12.13.
//  Copyright (c) 2013 Dmitry Savitskiy. All rights reserved.
//

#import "SiteSectionsFactory.h"
#import "ExtendedURL.h"


@implementation SiteSectionsFactory

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (id)sharedInstance {
    static SiteSectionsFactory *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SiteSectionsFactory alloc] init];
        
    });
    return instance;
}

-(NSArray *)groupOfNews {
    static NSMutableArray *groupOfNews = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        groupOfNews = [[NSMutableArray alloc] init];
        
        ExtendedURL *tect = [[ExtendedURL alloc] initWithStringUrl:@"http://tech.onliner.by" caption:@"tech" help:@"Раздел новостей о технологиях"];
        [groupOfNews addObject:tect];
        
        ExtendedURL *realt = [[ExtendedURL alloc] initWithStringUrl:@"http://realt.onliner.by" caption:@"realt" help:@"Раздел новостей о недвижимости"];
        [groupOfNews addObject:realt];
        
        ExtendedURL *dengi = [[ExtendedURL alloc] initWithStringUrl:@"http://dengi.onliner.by" caption:@"dengi" help:@"Раздел новостей о деньгах"];
        [groupOfNews addObject:dengi];
        
        ExtendedURL *gomelNews = [[ExtendedURL alloc] initWithStringUrl:@"http://gomelnews.onliner.by" caption:@"gomelnews" help:@"Раздел региональных новостей гомельской области"];
        [groupOfNews addObject:gomelNews];
    });
    return groupOfNews;
}

@end
