//
//  BCNetwork.m
//  English
//
//  Created by Evans on 15/9/15.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import "BCNetwork.h"
#import <YTKKeyValueStore/YTKKeyValueStore.h>
#import <AFNetworking/AFNetworking.h>
@interface BCNetwork()
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@end
@implementation BCNetwork
static NSString *_tableName;
static YTKKeyValueStore *_store;

static BCNetwork *center;
+ (instancetype)center {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!center) {
            center = [[BCNetwork alloc]init];
        }
    });
    return center;
}

+(void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _store = [[YTKKeyValueStore alloc] initDBWithName:@"CBTCache.db"];
        _tableName = @"user_table";
        [_store createTableWithName:_tableName];
    });
}

-(AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        [_manager.requestSerializer setValue:@"accessToken" forHTTPHeaderField:@"Authorization"];
        [AFHTTPRequestSerializer serializer].timeoutInterval = 1;
    }
    return _manager;
}

// POST
-(void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sucess:(BaseHttpToolSucess)sucess failur:(BaseHttpToolFailur)failur
{
    // 2.发送请求
    [self.manager POST:url parameters:parameters
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   if (sucess) {
                       sucess(responseObject);
                   }
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if (failur) {
                       failur(error);
                   }
               }];
}

// GET
-(void)getCacheWithUrl:(NSString *)url option:(BcRequestCenterCachePolicy)option parameters:(NSDictionary *)parameters sucess:(BaseHttpToolSucess)sucess failur:(BaseHttpToolFailur)failur
{
    switch (option) {
        case BcRequestCenterCachePolicyNormal:{ // 普通的网络请求
            
            [self.manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (sucess) {
                    sucess(responseObject);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failur) {
                    failur(error);
                }
            }];
            
        }
            break;
        case BcRequestCenterCachePolicyCacheAndLocal:{ //优先读取本地，不管有没有网络，优先读取本地
            
            NSDictionary *queryUser = [_store getObjectById:url fromTable:_tableName];
            if (queryUser) {
                sucess(queryUser);
                                NSLog(@"系统有缓存 %@",queryUser);
            }
            
            [self.manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (sucess) {
                    if (!queryUser) {
                        sucess(responseObject);
                                            NSLog(@"第一次进入系统没有缓存");
                    }
                    [_store putObject:responseObject withId:url intoTable:_tableName];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failur) {
                    failur(error);
                }
            }];
        }
            break;
    }
}

/**
 *  PUT
 *
 *  @param url    请求的 url
 *  @param parm   请求的参数
 *  @param sucess 请求成功后的回调
 *  @param failur 请求失败后的回调
 */
-(void)putWithUrl:(NSString *)url parm:(id)parm sucess:(void (^)(id json))sucess failur:(void (^)(NSError *error))failur
{
    [[AFHTTPSessionManager manager] PUT:url parameters:parm success:^(NSURLSessionDataTask *task, id responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failur) {
            failur(error);
        }
    }];
}

/**
 *  DELETE
 *
 *  @param url    请求的 url
 *  @param parm   请求的参数
 *  @param sucess 请求成功后的回调
 *  @param failur 请求失败后的回调
 */
-(void)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters sucess:(void (^)(id json))sucess failur:(void (^)(NSError *error))failur
{
    [self.manager DELETE:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failur) {
            failur(error);
        }
    }];
}
@end
