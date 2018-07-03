//
//  ViewController.m
//  testURLSessionBackground
//
//  Created by gaoxiaowei on 2018/7/3.
//  Copyright © 2018年 51vv. All rights reserved.
//

#import "ViewController.h"
#import "downLoader.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray*array =@[@"http://upcdn.file.m.mvbox.cn/upload/57314fa37d2bf55dc36adbc4e97fd250_937261469_1.m4a",@"http://upcdn.file.m.mvbox.cn/upload/8f07a238b0e0cafbbdd7e9dd12c62e04_923863590_1.m4a",@"http://upcdn.file.m.mvbox.cn/upload/849b754162c31aab257ead8fa5145f9c_931484590_4.mp4",@"http://upcdn.file.m.mvbox.cn/upload/1b0e49cdbede6b51121da2d30fd7cd21_921549018_1.m4a"];
        for (NSString *object in array) {
            [[downLoader shared]beginDownloadWithUrl:object];
        }
        
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
