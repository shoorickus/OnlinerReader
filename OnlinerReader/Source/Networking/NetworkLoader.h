//
// Created by Dmitry Savitskiy on 04/12/13.
// Copyright (c) 2013 Dmitry Savitskiy. All rights reserved.
//
// Created by JetBrains AppCode
//


#import <Foundation/Foundation.h>


typedef void(^ResultHandler)(NSData *receivedData);


@interface NetworkLoader : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate>

+ (id)sharedInstance;

- (void)downloadDataWithURl:(NSURL *)url resultHandler:(ResultHandler)handler;

@end