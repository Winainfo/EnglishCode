//
//  LibraryController.m
//  English
//
//  Created by Evans on 15/9/11.
//  Copyright © 2015年 Evans. All rights reserved.
//

#import "LibraryController.h"
#import "DetailController.h"
#import <UIImageView+WebCache.h>
#import "SDRefresh.h"
#import "BCNetwork.h"
@interface LibraryController ()<LibraryDelegate>
@property (nonatomic,retain)NSArray *bookArray;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//@property (nonatomic,assign) int page;
@end

static int page=6;
@implementation LibraryController
-(void)viewWillAppear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.title=@"图书馆";
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti Sc" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //注册
    [self.collectionView registerClass:[LibraryViewCell class] forCellWithReuseIdentifier:@"LibraryViewCell"];
    [self getData];
    //下拉刷新
    [self pullRefresh];
    //上拉加载
    [self setupFooter];
}

//下拉刷新
-(void)pullRefresh{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.collectionView];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        //调用评论接口
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"pageSize",@"1",@"pageIndex",@"1",@"book_team", nil];
        [RequestData getLibraryBook:param FinishCallbackBlock:^(NSDictionary *data) {
            self.bookArray=data[@"content"];
            //调用主线程
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [weakRefreshHeader endRefreshing];
            });
        }];
    };
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.collectionView];

    [refreshFooter addTarget:self refreshAction:@selector(pushRefresh)];
    _refreshFooter = refreshFooter;
}
/**
 *  上拉加载
 */
-(void)pushRefresh{
    page=page+6;
    NSString *pageIndex=[NSString stringWithFormat:@"%i",page];
    //调用评论接口
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:pageIndex,@"pageSize",@"1",@"pageIndex",@"1",@"book_team", nil];
    [RequestData getLibraryBook:param FinishCallbackBlock:^(NSDictionary *data) {
        self.bookArray=data[@"content"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),   dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.refreshFooter endRefreshing];
            });
    }];
}

/**
 *  请求数据
 */
-(void)getData{
    //调用评论接口
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"pageSize",@"1",@"pageIndex",@"1",@"book_team", nil];
    [RequestData getLibraryBook:param FinishCallbackBlock:^(NSDictionary *data) {
        self.bookArray=data[@"content"];
        //调用主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}

/**
 *  每个section的item个数
 *
 *  @param collectionView <#collectionView description#>
 *  @param section        <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bookArray.count;
}

/**
 *  设置单元内容
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LibraryViewCell *cell = (LibraryViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LibraryViewCell" forIndexPath:indexPath];
    //获取图片
    [cell.bookImage sd_setImageWithURL:self.bookArray[indexPath.row][@"result"][@"book_img_url"]];
    //获取标题
    cell.titleLabel.text=self.bookArray[indexPath.row][@"result"][@"book_name"];
    //获取图书id
    cell.bookid=self.bookArray[indexPath.row][@"result"][@"book_id"];
    cell.delegate=self;
    return cell;
}
#pragma mark -- 实现点击跳转代理事件
-(void)btnClick:(UICollectionViewCell *)cell andBookId:(NSString *)bookid{
    //设置故事板为第一启动
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailController *detail=[storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    detail.bookid=bookid;
    [self.navigationController pushViewController:detail animated:YES];
    NSLog(@"图书：%@",bookid);
}
@end
