//
//  LibraryViewCell.h
//  English
//
//  Created by Evans on 15/9/11.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
//添加代理，用于按钮删除的实现
@protocol LibraryDelegate <NSObject>

-(void)btnClick:(UICollectionViewCell *)cell andBookId:(NSString*)bookid;

@end
@interface LibraryViewCell : UICollectionViewCell
//封面
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
//标题
@property (weak, nonatomic) IBOutlet ARLabel *titleLabel;
/**图书id*/
@property (retain,nonatomic) NSString *bookid;

@property(assign,nonatomic)id<LibraryDelegate>delegate;
@end
