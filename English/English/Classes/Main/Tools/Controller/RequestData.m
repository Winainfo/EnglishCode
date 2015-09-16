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
        //NSLog(@"缓存存在---");
        block(book);
    }else {
        //NSLog(@"没有缓存---");
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
            [[EGOCache globalCache]setObject:responseObject forKey:forkey withTimeoutInterval:24*60*60];
            block(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"请求失败-%@",error);
        }];
    }
}


@end
