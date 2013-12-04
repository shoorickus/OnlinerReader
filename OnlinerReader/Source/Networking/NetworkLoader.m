//
// Created by Dmitry Savitskiy on 04/12/13.
// Copyright (c) 2013 Dmitry Savitskiy. All rights reserved.
//
// Created by JetBrains AppCode
//


#import "NetworkLoader.h"


@interface NetworkLoader ()

@property (nonatomic, retain) NSURLSession *urlSession;

@end


@implementation NetworkLoader {

}

+ (id)sharedInstance
{
    static  NetworkLoader *networkLoader = nil;
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        networkLoader = [[self alloc] init];
    });

    return networkLoader;
}

- (id)init
{
    self = [super init];

    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

        // 1
        sessionConfig.allowsCellularAccess = YES;
        // 2
//        [sessionConfig setHTTPAdditionalHeaders:
//                @{@"Accept": @"application/json"}];
        // 3
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 60.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;

        self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }

    return self;
}


#pragma mark - NSURlSession delegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
}

- (void)URLSession:(NSURLSession *)session
        didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
        completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
}


#pragma mark - NSURLSessionTask delegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
        willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
        completionHandler:(void (^)(NSURLRequest *))completionHandler
{
}

- (void)URLSession:(NSURLSession *)session
                       task:(NSURLSessionTask *)task
        didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
          completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
        totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{}


#pragma mark - network operations

- (void)downloadDataWithURl:(NSURL *)url resultHandler:(ResultHandler)handler
{
    NSURLSessionDataTask *sessionDownloadTask = [self.urlSession dataTaskWithURL:url
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                                                                   if (error) {
                                                                       NSLog(@"Downloading Error: %@", [error localizedDescription]);

                                                                   } else {
                                                                       handler(data);
                                                                   }
                                                               }];

    [sessionDownloadTask resume];
}

@end