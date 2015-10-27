//
//  HomeController.m
//  English
//
//  Created by Evans on 15/9/10.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import "HomeController.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import "BCNetwork.h"

@interface HomeController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;

@end

@implementation HomeController

-(void)viewWillAppear:(BOOL)animated
{
    //加载数据
    [self getBookImage];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题
    self.title=@"首页";
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti Sc" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
/**
 *  请求首页的数据
 */
-(void)getBookImage{
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pageSize",@"1",@"pageIndex",@"1",@"book_team", nil];
    [RequestData getIndexBook:param FinishCallbackBlock:^(NSDictionary *data) {
        [self.bookImage sd_setImageWithURL:data[@"content"][0][@"result"][@"book_img_url"]];
    }];
}
/**
 *  请求图书列表页的数据
 */
-(void)getData{
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"pageSize",@"1",@"pageIndex",@"1",@"book_team", nil];
    [RequestData getLibraryBook:param FinishCallbackBlock:^(NSDictionary *data) {
    }];
}
@end
