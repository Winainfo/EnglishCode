//
//  RequestData.m
//  English
//
//  Created by Evans on 15/9/10.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import "RequestData.h"
#import <AFNetworking.h>
#import <EGOCache.h>
@implementation RequestData
#pragma marl 首页图书接口
//获取首页图书接口
+(void)getIndexBook:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block
{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"pageSize"]=[data objectForKey:@"pageSize"];
    params[@"pageIndex"]=[data objectForKey:@"pageIndex"];
    params[@"book_team"]=[data objectForKey:@"book_team"];
    NSString *forkey= [NSString stringWithFormat:@"IndexBook%@",[data objectForKey:@"pageIndex"]];
    NSLog(@"------%@",forkey);
    EGOCache *cache=[EGOCache new];
    if([cache hasCacheForKey:forkey])
    {
        NSDictionary *book=(NSDictionary *)[[EGOCache globalCache]objectForKey:forkey];
        NSLog(@"缓存存在---");
        block(book);
    }else {
        NSLog(@"没有缓存---");
        //3.发生请求
        [mgr GET:@"http://42.62.50.218:8875/server/query_book_list" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [[EGOCache globalCache]setObject:responseObject forKey:forkey withTimeoutInterval:24*60*60];
            block(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"请求失败-%@",error);
        }];
    }
}


//获取图书列表接口
+(void)getLibraryBook:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block
{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"pageSize"]=[data objectForKey:@"pageSize"];
    params[@"pageIndex"]=[data objectForKey:@"pageIndex"];
    params[@"book_team"]=[data objectForKey:@"book_team"];
    //NSLog(@"%@",params);
    NSString *forkey= [NSString stringWithFormat:@"LibraryBook%@",[data objectForKey:@"pageSize"]];
    NSLog(@"------%@",forkey);
    EGOCache *cache=[EGOCache new];
    if([cache hasCacheForKey:forkey])
    {
        NSDictionary *book=(NSDictionary *)[[EGOCache globalCache]objectForKey:forkey];
       // NSLog(@"缓存存在---");
        block(book);
    }else {
        //NSLog(@"没有缓存---");
        //3.发生请求
        [mgr GET:@"http://42.62.50.218:8875/server/query_book_list" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"数据：%@",responseObject);
            [[EGOCache globalCache]setObject:responseObject forKey:forkey withTimeoutInterval:24*60*60];
            block(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"请求失败-%@",error);
        }];
    }
}

/**
 *  获取图书详细页
 *
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)getDetailBook:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"book_id"]=[data objectForKey:@"book_id"];
    params[@"pagenumber"]=[data objectForKey:@"pagenumber"];
    NSString *Key=[NSString stringWithFormat:@"%@%@",[data objectForKey:@"book_id"],[data objectForKey:@"pagenumber"]];
    NSLog(@"----%@",Key);
    NSString *forkey= [NSString stringWithFormat:@"DetailBook%@",Key];
    NSLog(@"------%@",forkey);
    EGOCache *cache=[EGOCache new];
    if([cache hasCacheForKey:forkey])
    {
        NSDictionary *book=(NSDictionary *)[[EGOCache globalCache]objectForKey:forkey];
        block(book);
    }else {
        //3.发生请求
        [mgr GET:@"http://42.62.50.218:8875/server/query_book_info" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [[EGOCache globalCache]setObject:responseObject forKey:forkey withTimeoutInterval:24*60*60];
            block(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"请求失败-%@",error);
        }];
    }
}



/**
 * 上传音频文件至服务端
 * 需要传递的参数：
 * url:音频所在的url
 * 返回参数：
 * 上传url文件至吾幼服务端的文件路径
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)uploadRecord:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"url"]=[data objectForKey:@"url"];
    NSLog(@"%@----",[data objectForKey:@"url"]);
    //3.发生请求
    [mgr POST:@"http://42.62.50.218:8875/server/radio_load" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"请求成功-%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"请求失败-%@",error);
    }];
}

/**
 *  上传录音接口
 * 需要传递的参数
 * detail_id 对应书详情页内容的id
 * uid 用户的id
 * record_time 录音的总时间（注意时间格式应为：13:42:27或者00:42:27）
 * radio_url 录音存储的url地址
 * permission:本条录音的权限，默认为1（详情查看录音表）
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)insertRecord:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"detail_id"]=[data objectForKey:@"detail_id"];
    params[@"uid"]=[data objectForKey:@"uid"];
    params[@"record_time"]=[data objectForKey:@"record_time"];
    params[@"radio_url"]=[data objectForKey:@"radio_url"];
    params[@"permission"]=[data objectForKey:@"permission"];
    //3.发生请求
    [mgr POST:@"http://42.62.50.218:8875/server/insert_radio" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"请求成功-%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"请求失败-%@",error);
    }];
}
/**
 *  获取用户录音
 * 需要传递的参数：
 * uid 用户的id
 * detail_id:图书的详情内容id
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)getRecord:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"detail_id"]=[data objectForKey:@"detail_id"];
    params[@"uid"]=[data objectForKey:@"uid"];
    //3.发生请求
    [mgr GET:@"http://42.62.50.218:8875/server/query_radio" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"请求成功-%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"请求失败-%@",error);
    }];
}
@end
