//
//  downLoader.h
//  testURLSessionBackground
//
//  Created by gaoxiaowei on 2018/7/3.
//  Copyright © 2018年 51vv. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionHandlerType)(void);

@interface downLoader : NSObject
+(instancetype)shared;

- (void)beginDownloadWithUrl:(NSString *)downloadURLString;
- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier;

@end
