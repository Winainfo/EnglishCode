//
//  RequestData.h
//  English
//
//  Created by Evans on 15/9/10.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestData : NSObject
//获取首页图书接口
+(void)getIndexBook:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block;
//获取图书列表
+(void)getLibraryBook:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block;
//获取图书详细页
+(void)getDetailBook:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block;
/**上传用户录音的接口*/
+(void)uploadRecord:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block;
/**数据库插入用户录音的接口*/
+(void)insertRecord:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block;
/**获取用户录音*/
+(void)getRecord:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block;
@end
