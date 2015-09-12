//
//  LibraryController.h
//  English
//
//  Created by Evans on 15/9/11.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryViewCell.h"
#import "RequestData.h"
@interface LibraryController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
