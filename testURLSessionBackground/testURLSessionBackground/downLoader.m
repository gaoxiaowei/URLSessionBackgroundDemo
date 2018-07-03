//
//  downLoader.m
//  testURLSessionBackground
//
//  Created by gaoxiaowei on 2018/7/3.
//  Copyright © 2018年 51vv. All rights reserved.
//

#import "downLoader.h"

@interface downLoader()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property(nonatomic,strong)NSURLSession*session;
@property(nonatomic,strong)NSMutableDictionary*completionHandlerDictionary;

@end

@implementation downLoader
+(instancetype)shared{
    static downLoader * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[downLoader alloc] init];
        [instance Init];
    });
    return instance;
}
-(void)Init{
    NSString *identifier = @"com.51vv.mvbox.BackgroundSession";
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                            delegate:self
                                       delegateQueue:[NSOperationQueue mainQueue]];
    self.completionHandlerDictionary =[NSMutableDictionary new];

}

- (void)beginDownloadWithUrl:(NSString *)downloadURLString {
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    NSURLSessionDownloadTask *downloadTask = [_session downloadTaskWithRequest:request];
    [downloadTask resume];
}

- (void)addCompletionHandler:(CompletionHandlerType)handler
                  forSession:(NSString *)identifier {
    NSURLSession *backgroundSession =self.session;
    NSLog(@"Rejoining session with identifier %@ %@", identifier, backgroundSession);
    if ([self.completionHandlerDictionary objectForKey:identifier]) {
        NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
    }
    [self.completionHandlerDictionary setObject:handler forKey:identifier];
}


//NSURLSessionDelegate委托方法，会在NSURLSessionDownloadDelegate委托方法后执行
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"Background URL session %@ finished events.\n", session);
    if (session.configuration.identifier) {
        // 调用在 -application:handleEventsForBackgroundURLSession: 中保存的 handler
        [self callCompletionHandlerForSession:session.configuration.identifier];
    }
}
- (void)callCompletionHandlerForSession:(NSString *)identifier {
    CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey: identifier];
    if (handler) {
        [self.completionHandlerDictionary removeObjectForKey: identifier];
        NSLog(@"Calling completion handler for session %@", identifier);
        handler();
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    NSLog(@"download didCompleteWithError:%@",error);
}
#pragma mark - NSURLSessionDownloadTaskDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"download didFinishDownloadingToURL");
}

- (void)URLSession:(__unused NSURLSession *)session
      downloadTask:(__unused NSURLSessionDownloadTask *)downloadTask
      didWriteData:(__unused int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"totalBytesWritten:%@,totalBytesExpectedToWrite:%@",@(totalBytesExpectedToWrite),@(totalBytesWritten));
}

@end
