//
//  LibraryViewCell.h
//  English
//
//  Created by Evans on 15/9/11.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface LibraryViewCell : UICollectionViewCell
//封面
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
//标题
@property (weak, nonatomic) IBOutlet ARLabel *titleLabel;
@end
