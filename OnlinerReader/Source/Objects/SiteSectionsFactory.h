//
//  GroupOfNewsFactory.h
//  OnlinerReader
//
//  Created by Alexander Dyubkin on 05.12.13.
//  Copyright (c) 2013 Dmitry Savitskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteSectionsFactory : NSObject

+ (id)sharedInstance;

/*
    @return
    An array of ExtendedURL objects of all basic news sections of site
 */

- (NSArray *)groupOfNews;

@end
