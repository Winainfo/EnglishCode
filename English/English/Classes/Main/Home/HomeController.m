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
@interface HomeController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题
    self.title=@"首页";
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti Sc" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getBookImage];
}
-(void)getBookImage{
    //调用评论接口
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pageSize",@"1",@"pageIndex",@"1",@"book_team", nil];
    [RequestData getIndexBook:param FinishCallbackBlock:^(NSDictionary *data) {
        //NSLog(@"%@",data[@"content"][0][@"result"][@"book_img_url"]);
        [self.bookImage sd_setImageWithURL:data[@"content"][0][@"result"][@"book_img_url"]];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
