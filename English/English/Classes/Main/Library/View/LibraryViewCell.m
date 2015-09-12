//
//  LibraryViewCell.m
//  English
//
//  Created by Evans on 15/9/11.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import "LibraryViewCell.h"

@implementation LibraryViewCell

- (void)awakeFromNib {
    //设置圆角
    self.bookImage.layer.cornerRadius=6;
    self.bookImage.layer.masksToBounds=YES;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"LibraryViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
@end
