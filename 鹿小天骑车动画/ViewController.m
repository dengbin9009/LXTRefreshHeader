//
//  ViewController.m
//  鹿小天骑车动画
//
//  Created by DaBin on 2017/5/11.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "ViewController.h"
#import "LXTRefreshHeader.h"
#import "ViewController2.h"
#import "FDHomePresentingAnimator.h"
#import "FDHomeDismissingAnimator.h"

static CGFloat kLXT_RefreshHeaderHeight = 0;

@interface ViewController ()<UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 用于在下拉H5时记录Tableview的变量
@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.clipsToBounds = NO;
    [self setupH5Refresh];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 集成带有二楼H5的的刷新控件
- (void)setupH5Refresh
{
    __weak __typeof(&*self)weakSelf = self;
    LXTRefreshHeader *header = [LXTRefreshHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    } andExtraBlock:^{
        [weakSelf open];
    }];
    kLXT_RefreshHeaderHeight = [UIScreen mainScreen].bounds.size.width*(1075/375.0);
    header.refreshHeaderHeight = kLXT_RefreshHeaderHeight;
    header.extraBlockOffsetY = LXTRefreshHeaderHeight;
    // 强转只为去除警告
    self.tableView.mj_header = (MJRefreshHeader *)header;
}

- (void)open{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.8 animations:^{
        [weakSelf pushTableViewDown];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            ViewController2 *modalViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
            modalViewController.hidesBottomBarWhenPushed = YES;
            modalViewController.transitioningDelegate = self;
            modalViewController.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:modalViewController
                               animated:YES
                             completion:^{
                                 [weakSelf resetTableViewContentInset];
                             }];
        });
        
    }];
}

- (void)pushTableViewDown{
    self.originalFrame = self.tableView.frame;
    [self.tableView setFrame:CGRectMake(0, kLXT_RefreshHeaderHeight, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.tableView.frame))];
}

- (void)resetTableViewContentInset{
    [self.tableView setFrame:self.originalFrame];
    [self setupH5Refresh];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [FDHomePresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [FDHomeDismissingAnimator new];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
