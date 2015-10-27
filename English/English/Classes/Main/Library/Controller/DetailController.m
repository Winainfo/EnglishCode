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
#import "AudioStreamer.h"
#import "RecordHUD.h"
@interface DetailController ()
{
    AudioStreamer *streamer;
    AudioStreamer *recordStm;
}
/**图书封面*/
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
/**图书内容*/
@property (weak, nonatomic) IBOutlet ARLabel *ContentLabel;
/**图书详情id*/
@property (nonatomic,strong) NSString *detail_id;
/**音频文件的url路径*/
@property(nonatomic,strong)NSString *urlStr;
/**录音文件的url路径*/
@property(nonatomic,strong)NSString *recordURL;
/**录音按钮*/
@property (weak, nonatomic) IBOutlet D3RecordButton *recordBtn;
/**录音播放按钮*/
@property (weak, nonatomic) IBOutlet UIButton *playRecordBtn;
/**结束播放按钮*/
@property (weak, nonatomic) IBOutlet UIButton *endPlay;
/**网络播放按钮*/
@property (weak, nonatomic) IBOutlet UIButton *NetPlayBtn;
/**网络播放结束按钮*/
@property (weak, nonatomic) IBOutlet UIButton *NetEndBtn;

@end

@implementation DetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    /**获取用户录音*/
    [self getUserRecord];
    //录音
    [_recordBtn initRecord:self maxtime:60];
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
        _detail_id=data[@"content"][0][@"result"][@"detail_id"];
    }];
}
/**
 *  获取用户录音
 */
-(void)getUserRecord{
 NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:_detail_id,@"detail_id",@"1",@"uid", nil];
    [RequestData getRecord:param FinishCallbackBlock:^(NSDictionary *data) {
        if([data[@"code"] isEqualToString:@"0"]){
            _recordURL=@"http://42.62.50.218:6789/file_upload/1441080018008_1-1. My Room.mp3";
            _playRecordBtn.hidden=YES;
            _endPlay.hidden=YES;
            _NetEndBtn.hidden=YES;
            _NetPlayBtn.hidden=NO;
        }else{
            _playRecordBtn.hidden=NO;
            _endPlay.hidden=YES;
            _NetEndBtn.hidden=YES;
            _NetPlayBtn.hidden=YES;
        }
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
/**
 *  创建音乐流
 *
 *  @return <#return value description#>
 */

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

/**
 *  创建网络录音流
 *
 *  @return <#return value description#>
 */

- (void)createRecordStreamer
{
    [self destroyRecordStreamer];
    NSString *escapedValue =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(Nil, (CFStringRef)_recordURL, NULL, NULL, kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:escapedValue];
    recordStm = [[AudioStreamer alloc] initWithURL:url];
}

- (void)destroyRecordStreamer
{
    if (recordStm)
    {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:recordStm];
        [recordStm stop];
        recordStm = nil;
    }
}

/**
 *  实现录音代理
 *
 *  @param voiceData <#voiceData description#>
 */
-(void)endRecord:(NSData *)voiceData{
    NSError *error;
    play = [[AVAudioPlayer alloc]initWithData:voiceData error:&error];
    play.volume = 1.0f;
//    NSLog(@"yesssssssssss..........%f",play.duration);
}

/**
 *
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btnDown:(D3RecordButton *)sender {
    [self.playRecordBtn setBackgroundImage:[UIImage imageNamed:@"bf_no.png"] forState:UIControlStateNormal];
    self.playRecordBtn.userInteractionEnabled=NO;
}

- (IBAction)btnUp:(D3RecordButton *)sender {
    [self.playRecordBtn setBackgroundImage:[UIImage imageNamed:@"bf.png"] forState:UIControlStateNormal];
    self.playRecordBtn.userInteractionEnabled=YES;
    
    NSDictionary *up_param=[NSDictionary dictionaryWithObjectsAndKeys:@"http://42.62.50.218:6789/file_upload/1441080018008_1-1. My Room.mp3",@"url", nil];
    [RequestData uploadRecord:up_param FinishCallbackBlock:^(NSDictionary *data) {
    }];
    
//    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:_detail_id,@"detail_id",@"1",@"uid",[NSString stringWithFormat:@"%f",play.duration],@"record_time",[_recordBtn stopRecord],@"radio_url",@"1",@"permission", nil];
//    [RequestData insertRecord:param FinishCallbackBlock:^(NSDictionary *data) {
//        
//    }];
}


/**
 *  播放用户的录音
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playRecord:(UIButton *)sender {
    [play play];
    self.playRecordBtn.hidden=YES;
    self.endPlay.hidden=NO;
}

/**
 *  结束播放用户录音
 *
 *  @param sender <#sender description#>
 */
- (IBAction)endPlayRecord:(UIButton *)sender {
    self.playRecordBtn.hidden=NO;
    self.endPlay.hidden=YES;
    [play stop];
}

/**
 *  播放用户网络的录音
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playNetRecord:(UIButton *)sender {
    if (!recordStm) {
        [self createRecordStreamer];
    }
    [recordStm start];
    _NetPlayBtn.hidden=YES;
    _NetEndBtn.hidden=NO;
}
/**
 *  结束播放用户网络的录音
 *
 *  @param sender <#sender description#>
 */
- (IBAction)endPlayNetRecord:(id)sender {
    [recordStm stop];
    _NetPlayBtn.hidden=NO;
    _NetEndBtn.hidden=YES;
}
@end
