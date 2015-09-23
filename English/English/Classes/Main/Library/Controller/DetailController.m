//
//  DetailController.m
//  English
//
//  Created by Evans on 15/9/22.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import "DetailController.h"
#import "ARLabel.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioStreamer.h"
@interface DetailController ()
{
    AudioStreamer *streamer;
}
/**图书封面*/
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
/**图书内容*/
@property (weak, nonatomic) IBOutlet ARLabel *ContentLabel;
/**音频文件的url路径*/
@property(nonatomic,strong)NSString *urlStr;
@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}
/**
 *  图书数据请求
 */
-(void)getData{
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:_bookid,@"book_id",@"1",@"pagenumber", nil];
    [RequestData getDetailBook:param FinishCallbackBlock:^(NSDictionary *data) {
         NSLog(@"%@",data[@"content"][0][@"result"]);
        //获取标题
        self.ContentLabel.text=data[@"content"][0][@"result"][@"title"];
        //获取图片
        [self.bookImage sd_setImageWithURL:data[@"content"][0][@"result"][@"img_url"]];
        
        _urlStr =data[@"content"][0][@"result"][@"book_radio_url"];
    }];
}
/**
 *  播放书本音乐
 *
 *  @param sender sender description
 */
- (IBAction)playClick:(UIButton *)sender {
    if (!streamer) {
        [self createStreamer];
    }
    [streamer start];
}

- (void)createStreamer
{
    NSLog(@"---%@",_urlStr);
    [self destroyStreamer];
    NSString *escapedValue =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(Nil, (CFStringRef)_urlStr, NULL, NULL, kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:escapedValue];
    streamer = [[AudioStreamer alloc] initWithURL:url];
    
    
}

- (void)destroyStreamer
{
    if (streamer)
    {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
        
        [streamer stop];
        streamer = nil;
    }
}

@end
