//
//  HttpSwssion.h
//  NSURLSession
//
//  Created by lee on 16/5/26.
//  Copyright © 2016年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^myBlock)(NSData *data,NSError *error);
@interface HttpSwssion : NSObject<NSURLSessionDataDelegate>


@property (nonatomic,strong)myBlock block;
@property (nonatomic,strong)UIImageView *imageView;

//网络请求数据
- (void)postRequest:(NSString *)urlStr Param:(NSDictionary *)dict Block:(myBlock )block;

//异步加载图片，图片缓存
- (void)sd_setImageWithUrl:(NSString *)urlStr PlaceHolder:(NSString *)placeStr ImageView:(UIImageView *)imageView;

@end
