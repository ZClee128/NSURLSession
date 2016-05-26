//
//  ViewController.m
//  NSURLSession
//
//  Created by lee on 16/5/26.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "ViewController.h"
#import "HttpSwssion.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",NSHomeDirectory());
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:imgV];
    NSString *url = @"https://sf-sponsor.b0.upaiyun.com/45fa66791e4b4231fe4b3f335700aa5d.png";
    HttpSwssion *swssion = [[HttpSwssion alloc]init];
//    [swssion postRequest:url Param:nil Block:^(NSData *data, NSError *error) {
//        imgV.image = [UIImage imageWithData:data];
//    }];
    [swssion sd_setImageWithUrl:url PlaceHolder:@"boy" ImageView:imgV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
