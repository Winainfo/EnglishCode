//
//  RequestData.m
//  English
//
//  Created by Evans on 15/9/10.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import "RequestData.h"
#import <AFNetworking.h>
#define URL @"http://www.alayicai.com/service"
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
    NSLog(@"%@",params);
    //3.发生请求
    [mgr GET:@"http://42.62.50.218:8875/server/query_book_list" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       NSLog(@"请求成功---%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"请求失败-%@",error);
    }];
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
    NSLog(@"%@",params);
    //3.发生请求
    [mgr GET:@"http://42.62.50.218:8875/server/query_book_list" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"请求成功---%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"请求失败-%@",error);
    }];
}


//+(void)getCodeTest:(NSString *)Uid andToken:(NSString *)Token FinishCallbackBlock:(void (^)(NSString *, NSString *))block{
//    //请求路径:http://1.youngcouple.sinaapp.com/getCode.php
//    /**
//     请求参数
//     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
//     uid	false	int64	需要查询的用户ID。
//     参数uid与screen_name二者必选其一，且只能选其一；
//     */
//    //1.请求管理者
//    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
//    //2.拼接请求参数
//    NSMutableDictionary *params=[NSMutableDictionary dictionary];
//    AccountModel *account=[AccountTool account];
//    params[@"uid"]=Uid;
//    params[@"access_token"]=Token;
//    //3.发生请求
//    [mgr GET:@"http://1.youngcouple.sinaapp.com/getCode.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        account.codestr=responseObject[@"code"];
//        account.uida=responseObject[@"uidb"];
//        [AccountTool saveAccount:account];
//        NSLog(@"请求成功-----%@",responseObject);
//        block(responseObject[@"code"],responseObject[@"uidb"]);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showMessage:@"正在加载..."];
//        NSLog(@"请求失败-%@",error);
//    }];
//}
@end
