//
//  HttpSwssion.m
//  NSURLSession
//
//  Created by lee on 16/5/26.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "HttpSwssion.h"
#import <CommonCrypto/CommonDigest.h>
#define CC_MD5_DIGEST_LENGTH 16
@implementation HttpSwssion


- (void)sd_setImageWithUrl:(NSString *)urlStr PlaceHolder:(NSString *)placeStr ImageView:(UIImageView *)imageView
{
    self.imageView = imageView;
    //判断占位图片是否存在，存在则先显示占位图片
    if (placeStr != nil) {
        self.imageView.image = [UIImage imageNamed:placeStr];
    }
    
    if (urlStr != nil) {
        //根据图片的url字符串来设置图片
        [self setImageWithrUrl:urlStr];
    }
}

- (void)setImageWithrUrl:(NSString *)url
{
    //判断本地是否存在，如果存在则加载本地图片
    //a,获取沙盒的指定文件夹路径
    //b,格式化url字符串
    //c,组合成一个完成的图片在本地的路径
    //d,判断本地沙盒是否有该图片
    NSString *path = [[self getDownloadDirPath] stringByAppendingString:[NSString stringWithFormat:@"/%@",[self getMd5_32Bit_String:url]]];
    NSLog(@"%@",path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.imageView.image = [UIImage imageWithContentsOfFile:path];
    }else
    {
        //如果不存在，则从网路获取，并且移动到制定的文件夹下
        [self dwonloadImageFromUrl:url Path:path];
    }
}
/**
 从网络获取图片
 **/
- (void)dwonloadImageFromUrl:(NSString *)urlStr Path:(NSString *)pathStr
{
    NSURLSessionConfiguration *con = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:con];
    [[session downloadTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:pathStr error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithContentsOfFile:pathStr];
            });
        }else
        {
            NSLog(@"%@",error);
        }
        
    }] resume];
}

/**
 格式化url
 **/
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    
    const char *cStr = [srcString UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [result appendFormat:@"%02x", digest];

    return [result lowercaseString];
    
    
}


/**
 获取沙盒中图片的指定文件夹路径
 **/
- (NSString *)getDownloadDirPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@",path);
    path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",@"webcachedir"]];
    NSLog(@"%@",path);
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

//网络请求数据
- (void)postRequest:(NSString *)urlStr Param:(NSDictionary *)dict Block:(myBlock )block
{
    self.block = block;
    NSString *myStr = urlStr;
    if (dict != nil) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (NSString *str in dict.allValues) {
            [arr addObject:str];
        }
        NSString *dictStr = [arr componentsJoinedByString:@"&"];
        myStr = [myStr stringByAppendingString:[NSString stringWithFormat:@"?%@",dictStr]];
    }
    NSURLSessionConfiguration *con = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:con];
    [[session dataTaskWithURL:[NSURL URLWithString:myStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (self.block != nil) {
            self.block(data,error);
        }
    }] resume];
  
}



@end
