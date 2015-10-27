//
//  DetailController.h
//  English
//
//  Created by Evans on 15/9/22.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3RecordButton.h"
#import "Mp3Recorder.h"
@interface DetailController : UIViewController<D3RecordDelegate>{
    AVAudioPlayer *play;
    Mp3Recorder *mp3;
}
@property (retain,nonatomic)NSString *bookid;
@end
