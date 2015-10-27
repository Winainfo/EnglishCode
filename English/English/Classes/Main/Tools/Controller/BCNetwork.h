//
//  BCNetwork.h
//  English
//
//  Created by Evans on 15/9/15.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^BaseHttpToolSucess)(id json);
typedef void (^BaseHttpToolFailur)(NSError *error);
@interface BCNetwork : NSObject
+ (instancetype)center;

typedef NS_ENUM(NSUInteger, BcRequestCenterCachePolicy) {
    
    /**
     *  普通网络请求,不会有缓存
     */
    BcRequestCenterCachePolicyNormal,
    
    /**
     *  优先读取本地，不管有没有网络，优先读取本地
     */
    BcRequestCenterCachePolicyCacheAndLocal
};

/**
 *  普通的 post 请求
 *
 *  @param url        接口地址 Url
 *  @param parameters 请求参数
 *  @param sucess     成功后的回调
 *  @param failur     失败后的回调
 */
-(void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sucess:(BaseHttpToolSucess)sucess failur:(BaseHttpToolFailur)failur;

/**
 *  带缓存的 get 请求
 *
 *  @param url        接口地址 Url
 *  @param option     枚举,选择缓存策略
 *  @param parameters 请求参数
 *  @param sucess     成功后的回调
 *  @param failur     失败后的回调
 */
-(void)getCacheWithUrl:(NSString *)url option:(BcRequestCenterCachePolicy)option parameters:(NSDictionary *)parameters sucess:(BaseHttpToolSucess)sucess failur:(BaseHttpToolFailur)failur;

/**
 *  PUT
 *
 *  @param url    请求的 url
 *  @param parm   请求的参数
 *  @param sucess 请求成功后的回调
 *  @param failur 请求失败后的回调
 */
-(void)putWithUrl:(NSString *)url parm:(id)parm sucess:(void (^)(id json))sucess failur:(void (^)(NSError *error))failur;

/**
 *  DELETE
 *
 *  @param url    请求的 url
 *  @param parm   请求的参数
 *  @param sucess 请求成功后的回调
 *  @param failur 请求失败后的回调
 */
-(void)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters sucess:(void (^)(id json))sucess failur:(void (^)(NSError *error))failur;
@end
