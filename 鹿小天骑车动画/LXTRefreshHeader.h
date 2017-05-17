//
//  LXTRefreshHeader.h
//  鹿小天骑车动画
//
//  Created by DaBin on 2017/5/11.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

UIKIT_EXTERN CGFloat const LXTDoubleRefreshBlockOffsetY;
UIKIT_EXTERN CGFloat const LXTRefreshHeaderHeight;

typedef void (^LXTRefreshExtraBlock)();

@interface LXTRefreshHeader : MJRefreshComponent

/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock andExtraBlock:(LXTRefreshExtraBlock)extraBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

// 文字颜色
@property (nonatomic, strong) UIColor *titleLabelColor;
// 背景颜色
@property (nonatomic, strong) NSString *backgroundColorHax;

/** 这个key用来存储上一次下拉刷新成功的时间 */
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
/** 上一次下拉刷新成功的时间 */
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

@property (assign, nonatomic) NSTimeInterval refreshFastAnimationDuration;

/** 额外Block的回调 */
@property (copy, nonatomic) LXTRefreshExtraBlock extraBlock;
// 控件的高度
@property (nonatomic, assign) CGFloat refreshHeaderHeight;
// 下拉执行刷新的高度
@property (nonatomic, assign) CGFloat refreshBlockOffsetY;
// 下拉执行刷新的高度
@property (nonatomic, assign) CGFloat extraBlockOffsetY;


@end
