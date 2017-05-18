//
//  LXTRefreshHeader.m
//  鹿小天骑车动画
//
//  Created by DaBin on 2017/5/11.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "LXTRefreshHeader.h"
#import "UIColor+Fruitday.h"
#import <pop/POP.h>
#import <Masonry.h>
// 刷新Header的默认高度
CGFloat const LXTRefreshHeaderHeight = 150;
// 默认的执行刷新Block的OffsetY
CGFloat const LXTDoubleRefreshBlockOffsetY = 100;
// 默认的执行额外Block的OffsetY
static CGFloat const LXTDoubleExtraBlockOffsetY = LXTRefreshHeaderHeight;
// 松手即可执行extraBlock的状态 同MJRefreshState
static CGFloat const LXTRefreshStateExtraBlockPulling = 987890;
// 正在执行extraBlock的状态 同MJRefreshState
static CGFloat const LXTRefreshStateExtraBlocking = 987891;

static CGFloat const horsemanViewWidth    = 32;
static CGFloat const horsemanViewHeight   = 68;

static CGFloat const carEndTop            = 21;
static CGFloat const carEndWidth          = 28;
static CGFloat const carEndHeight         = 36;

static CGFloat const personTop            = 1;
static CGFloat const personWidth          = 32;
static CGFloat const personHeight         = 56;

static CGFloat const carHeadTop           = 21;
static CGFloat const carHeadWidth         = 32;
static CGFloat const carHeadHeight        = 43;

static CGFloat const eye1Top              = 10;
static CGFloat const eye2Top              = 11;
static CGFloat const eye1Width            = 6;
static CGFloat const eye2Width            = 4;

static CGFloat const eyeLeft1Left         = 8;
static CGFloat const eyeLeft2Left         = 9;

static CGFloat const eyeRight1Left        = 19;
static CGFloat const eyeRight2Left        = 20;

static CGFloat const balloonWidth         = 40;
static CGFloat const balloonHeight        = 115;
static CGFloat const balloonLeft          = 30;
static CGFloat const balloonBottom        = 18;


@interface LXTRefreshHeader()

@property (assign, nonatomic) CGFloat insetTDelta;

/*! 背景图片 */
@property (nonatomic, strong) UIImageView *backgroundImageView;
/*! 道路图片 */
@property (nonatomic, strong) UIImageView *roadImageView;
/*! 道路虚线的背景View，为了锚点存在 */
@property (nonatomic, strong) UIView *roadLineContainrerView;
/*! 道路虚线 */
@property (nonatomic, strong) UIImageView *roadLineView;
/*! 道路虚线2 */
@property (nonatomic, strong) UIImageView *roadLineView2;
/*! 整个小骑手的View */
@property (nonatomic, strong) UIView *horsemanView;
/*! 车子头 */
@property (nonatomic, strong) UIImageView *carHeadImageView;
/*! 车子尾 */
@property (nonatomic, strong) UIImageView *carEndImageView;
/*! 鹿小天 */
@property (nonatomic, strong) UIImageView *personImageView;
/*! 左眼黑色眼珠 */
@property (nonatomic, strong) UIImageView *eyeLeft1ImageView;
/*! 右眼黑色眼珠 */
@property (nonatomic, strong) UIImageView *eyeRight1ImageView;
/*! 左眼眼白 */
@property (nonatomic, strong) UIImageView *eyeLeft2ImageView;
/*! 右眼眼白 */
@property (nonatomic, strong) UIImageView *eyeRight2ImageView;
/*! 气球 */
@property (nonatomic, strong) UIImageView *balloonImageView;
/*! 状态Label */
@property (nonatomic, strong) UILabel *statusLabel;

// 记录所有元素的中心点，方便动画运算
/*! 车子头 */
@property (nonatomic, assign) CGPoint carHeadCenter;
/*! 鹿小天 */
@property (nonatomic, assign) CGPoint personCenter;
/*! 车子尾 */
@property (nonatomic, assign) CGPoint carEndCenter;
/*! 左眼黑色眼珠 */
@property (nonatomic, assign) CGPoint eyeLeft1Center;
/*! 右眼黑色眼珠 */
@property (nonatomic, assign) CGPoint eyeRight1Center;
/*! 左眼眼白 */
@property (nonatomic, assign) CGPoint eyeLeft2Center;
/*! 右眼眼白 */
@property (nonatomic, assign) CGPoint eyeRight2Center;

/*! 是否需要停止所有动画 */
@property (nonatomic, assign) BOOL stopAllAnimation;
/*! 道路运动的Timer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LXTRefreshHeader

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    self.refreshFastAnimationDuration = MJRefreshFastAnimationDuration;
    // 设置key
    self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
    
    // 设置高度
    self.mj_h = LXTRefreshHeaderHeight;
    self.refreshBlockOffsetY = LXTDoubleRefreshBlockOffsetY;
    self.extraBlockOffsetY = LXTDoubleExtraBlockOffsetY;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
    [self initialization];
}

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock andExtraBlock:(LXTRefreshExtraBlock)extraBlock{
    LXTRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    cmp.extraBlock = extraBlock;
    return cmp;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    LXTRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    return [self headerWithRefreshingBlock:refreshingBlock andExtraBlock:NULL];
}

#pragma mark - initialization
// 鹿小天专属
- (void)initialization {
    self.stopAllAnimation = YES;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.mj_h = LXTRefreshHeaderHeight+screenHeight;
    
    // 所有空间的frame在placeSubviews中设置
    // 初始化背景图片
    self.backgroundImageView = [UIImageView new];
    self.backgroundImageView.image = [UIImage imageNamed:@"LXT_2ndFloor_bg"];
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.backgroundImageView];
    
    // 道路图片
    self.roadImageView = [UIImageView new];
    self.roadImageView.image = [UIImage imageNamed:@"LXT_road_bg"];
    self.roadImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.roadImageView];
    
    // 道路虚线
    self.roadLineContainrerView = [UIView new];
    self.roadLineContainrerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.roadLineContainrerView];
    
    // 道路虚线
    self.roadLineView = [UIImageView new];
    self.roadLineView.image = [UIImage imageNamed:@"LXT_roadLine"];
    self.roadLineView.backgroundColor = [UIColor clearColor];
    self.roadLineView.contentMode = UIViewContentModeScaleAspectFill;
    [self.roadLineContainrerView addSubview:self.roadLineView];
    
    // 道路虚线2
    self.roadLineView2 = [UIImageView new];
    self.roadLineView2.image = [UIImage imageNamed:@"LXT_roadLine"];
    self.roadLineView2.backgroundColor = [UIColor clearColor];
    self.roadLineView2.contentMode = UIViewContentModeScaleAspectFill;
    [self.roadLineContainrerView addSubview:self.roadLineView2];

    // 整个小骑手的View
    self.horsemanView = [UIView new];
    self.horsemanView.backgroundColor = [UIColor clearColor];
    self.horsemanView.clipsToBounds = NO;
    [self addSubview:self.horsemanView];
    
    // 车子尾
    self.carEndImageView = [UIImageView new];
    self.carEndImageView.image = [UIImage imageNamed:@"LXT_car2"];
    self.carEndImageView.backgroundColor = [UIColor clearColor];
    self.carEndImageView.contentMode = UIViewContentModeCenter;
    [self.horsemanView addSubview:self.carEndImageView];
    
    // 鹿小天
    self.personImageView = [UIImageView new];
    self.personImageView.image = [UIImage imageNamed:@"LXT_luxiaotian_noeye"];
    self.personImageView.backgroundColor = [UIColor clearColor];
    self.personImageView.contentMode = UIViewContentModeCenter;
    [self.horsemanView addSubview:self.personImageView];
    
    // 车子头
    self.carHeadImageView = [UIImageView new];
    self.carHeadImageView.image = [UIImage imageNamed:@"LXT_car1"];
    self.carHeadImageView.backgroundColor = [UIColor clearColor];
    self.carHeadImageView.contentMode = UIViewContentModeCenter;
    [self.horsemanView addSubview:self.carHeadImageView];
    
    // 左眼黑色眼珠
    self.eyeLeft1ImageView = [UIImageView new];
    self.eyeLeft1ImageView.image = [UIImage imageNamed:@"LXT_eye2"];
    self.eyeLeft1ImageView.backgroundColor = [UIColor clearColor];
    [self.horsemanView addSubview:self.eyeLeft1ImageView];
    
    // 右眼黑色眼珠
    self.eyeRight1ImageView = [UIImageView new];
    self.eyeRight1ImageView.image = [UIImage imageNamed:@"LXT_eye2"];
    self.eyeRight1ImageView.backgroundColor = [UIColor clearColor];
    [self.horsemanView addSubview:self.eyeRight1ImageView];
    
    // 左眼黑色眼珠
    self.eyeLeft2ImageView = [UIImageView new];
    self.eyeLeft2ImageView.image = [UIImage imageNamed:@"LXT_eye3"];
    self.eyeLeft2ImageView.backgroundColor = [UIColor clearColor];
    [self.horsemanView addSubview:self.eyeLeft2ImageView];
    
    // 右眼黑色眼珠
    self.eyeRight2ImageView = [UIImageView new];
    self.eyeRight2ImageView.image = [UIImage imageNamed:@"LXT_eye3"];
    self.eyeRight2ImageView.backgroundColor = [UIColor clearColor];
    [self.horsemanView addSubview:self.eyeRight2ImageView];
    
    // 右眼黑色眼珠
    self.balloonImageView = [UIImageView new];
    self.balloonImageView.image = [UIImage imageNamed:@"LXT_balloon"];
    self.balloonImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.balloonImageView];
    
    // 状态Label
    self.statusLabel = [UILabel new];
    self.statusLabel.text = @"";
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.statusLabel];
    
    [self initializAutolayout];
}

- (void)dealloc {
    NSLog(@"LXTRefreshHeader_dealloc");
}

// 初始化所有的约束
- (void)initializAutolayout {
    // 约束
    __weak __typeof(&*self)weakSelf = self;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.roadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@52);
    }];
    [self.roadLineContainrerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@52);
    }];
    [self.roadLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.roadLineContainrerView);
        make.bottom.equalTo(@20);
        make.height.equalTo(@100);
        make.width.equalTo(@(200));
    }];
    [self.roadLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.roadLineContainrerView);
        make.bottom.equalTo(@20);
        make.height.equalTo(@100);
        make.width.equalTo(@(200));
    }];
    [self.horsemanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(@-14);
        make.width.equalTo(@(horsemanViewWidth));
        make.height.equalTo(@(horsemanViewHeight));
    }];
    
    // 给道路增加透视效果
    CATransform3D rotate = CATransform3DMakeRotation(LXT_radians(90), 1, 0, 0);
    self.roadLineView.layer.transform = LXT_CATransform3DPerspect(rotate, CGPointMake(0, -20), 50);
    self.roadLineView2.layer.transform = LXT_CATransform3DPerspect(rotate, CGPointMake(0, -20), 50);
    
    
    // 气球
    self.balloonImageView.frame = CGRectMake(balloonLeft, [self balloonTop], balloonWidth, balloonHeight);
    // 状态label
    self.statusLabel.frame = CGRectMake(0, self.mj_h-20, self.mj_w, 20);

    // 由于horsemanView大小固定，为了效率，里面的view可以不用约束设置
    self.carEndImageView.frame = CGRectMake(2, carEndTop, carEndWidth, carEndHeight);
    self.personImageView.frame = CGRectMake(0, personTop, personWidth, personHeight);
    self.carHeadImageView.frame = CGRectMake(0, carHeadTop, carHeadWidth, carHeadHeight);
    // 眼睛
    self.eyeLeft1ImageView.frame = CGRectMake(eyeLeft1Left, eye1Top, eye1Width, eye1Width);
    self.eyeLeft2ImageView.frame = CGRectMake(eyeLeft2Left, eye2Top, eye2Width, eye2Width);
    self.eyeRight1ImageView.frame = CGRectMake(eyeRight1Left, eye1Top, eye1Width, eye1Width);
    self.eyeRight2ImageView.frame = CGRectMake(eyeRight2Left, eye2Top, eye2Width, eye2Width);

    // 获取所有元素的中心点
    self.carEndCenter = self.carEndImageView.center;
    self.personCenter = self.personImageView.center;
    self.carHeadCenter = self.carHeadImageView.center;
    // 眼睛
    self.eyeLeft1Center = self.eyeLeft1ImageView.center;
    self.eyeLeft2Center = self.eyeLeft2ImageView.center;
    self.eyeRight1Center = self.eyeRight1ImageView.center;
    self.eyeRight2Center = self.eyeRight2ImageView.center;
    
}

#pragma mark - Private Method
- (void)setRefreshBlockOffsetY:(CGFloat)refreshBlockOffsetY{
    _refreshBlockOffsetY = refreshBlockOffsetY;
}

- (void)setRefreshHeaderHeight:(CGFloat)refreshHeaderHeight{
    _refreshHeaderHeight = refreshHeaderHeight;
    self.mj_h = refreshHeaderHeight;
}

- (void)setExtraBlockOffsetY:(CGFloat)extraBlockOffsetY{
    _extraBlockOffsetY = extraBlockOffsetY;
}

- (void)setTitleLabelColor:(UIColor *)color{
    _titleLabelColor = color;
}

- (void)setBackgroundColorHax:(NSString *)backgroundColorHax{
    _backgroundColorHax = backgroundColorHax;
    if ( backgroundColorHax ) {
        self.backgroundColor = [UIColor colorWithHexString:backgroundColorHax alpha:0.4];
    }
    else{
        self.backgroundColor = [UIColor clearColor];
    }
}

- (CGFloat)balloonTop{
    CGFloat top = self.frame.size.height-balloonBottom-balloonHeight;
    return top;
}

#pragma mark 动画相关

// 停止所有动画
- (void)removeAllAnimation{
    self.stopAllAnimation = YES;
    self.roadLineView2.hidden = YES;
//    self.balloonImageView.hidden = YES;
    if ( [self.timer isValid] ) {
        [self.timer invalidate];
        anchor = minAnchorPointX;
        anchor2 = -maxAnchorPointX2;
    }
    for (UIView *subView in self.subviews) {
        [subView pop_removeAllAnimations];
    }
    for (UIView *subView in self.horsemanView.subviews) {
        [subView pop_removeAllAnimations];
    }
}

// 执行骑手的所有动画
- (void)executeAllAnimation{
    self.stopAllAnimation = NO;
    self.roadLineView2.hidden = NO;
//    self.balloonImageView.hidden = NO;
    [self executeRoadLineAnimation];
    [self executeHorsemanAnimation];
    [self executeHorsemanEyeAnimation];
    [self executeBalloonAnimation];
}

static CGFloat const minAnchorPointX = -0.6;
static CGFloat const maxAnchorPointX2 = 3.8;
static CGFloat anchor = minAnchorPointX;
static CGFloat anchor2 = -maxAnchorPointX2;
// 执行道路透视效果
- (void)executeRoadLineAnimation{
    // 给道路增加透视效果
    CATransform3D rotate = CATransform3DMakeRotation(LXT_radians(90), 1, 0, 0);
    self.roadLineView.layer.transform = LXT_CATransform3DPerspect(rotate, CGPointMake(0, -20), 50);
    
    self.timer = [NSTimer timerWithTimeInterval:0.002 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerHandler:(NSTimer *)timer{
    if ( self.stopAllAnimation ) {
        [timer invalidate];
        return ;
    }
    anchor+=0.015;
    anchor2+=0.015;
    if ( anchor>=maxAnchorPointX2 ) {
        anchor=-maxAnchorPointX2;
    }
    if ( anchor2>=maxAnchorPointX2 ) {
        anchor2=-maxAnchorPointX2;
    }
    // 移动相对道路虚线的锚点，相当于拉远距离（远视效果）
    self.roadLineView.layer.anchorPoint = CGPointMake(0.5, anchor);
    self.roadLineView2.layer.anchorPoint = CGPointMake(0.5, anchor2);
}

// 执行骑手上下抖动的动画
- (void)executeHorsemanAnimation{
    if ( self.stopAllAnimation ) return;
    CGFloat duration = 0.175;
    // 车头的上下振幅
    POPBasicAnimation *carHeadUp = [POPBasicAnimation linearAnimation];
    carHeadUp.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    carHeadUp.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.personImageView.frame), self.carHeadCenter.y-1.25)];
    @weakify(self);
    carHeadUp.duration = duration;
    [self.carHeadImageView pop_addAnimation:carHeadUp forKey:@"carHeadAnimation"];
    [carHeadUp setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        @strongify(self);
        POPBasicAnimation *carHeadDown = [POPBasicAnimation linearAnimation];
        carHeadDown.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
        carHeadDown.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.personImageView.frame), self.carHeadCenter.y+1.25)];
        carHeadDown.duration = duration;
        [self.carHeadImageView pop_addAnimation:carHeadDown forKey:@"carHeadAnimation"];
        [carHeadDown setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            [self executeHorsemanAnimation];
        }];
    }];
    
    // 鹿小天和车尾上下的振幅
    CGFloat rangeY = 0.75;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration/5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 鹿小天的身子
        POPBasicAnimation *personUp = [POPBasicAnimation linearAnimation];
        personUp.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
        personUp.toValue = [NSValue valueWithCGPoint:CGPointMake(self.personCenter.x, self.personCenter.y-rangeY)];
        personUp.duration = duration;
        [self.personImageView pop_addAnimation:personUp forKey:@"personAnimation"];
        [personUp setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *personDown = [POPBasicAnimation linearAnimation];
            personDown.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
            personDown.toValue = [NSValue valueWithCGPoint:CGPointMake(self.personCenter.x, self.personCenter.y+rangeY)];
            personDown.duration = duration;
            [self.personImageView pop_addAnimation:personDown forKey:@"personAnimation"];
        }];
        
        // 车尾
        POPBasicAnimation *cartEndUp = [POPBasicAnimation linearAnimation];
        cartEndUp.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
        cartEndUp.toValue = [NSValue valueWithCGPoint:CGPointMake(self.carEndCenter.x, self.carEndCenter.y-rangeY)];
        cartEndUp.duration = duration;
        [self.carEndImageView pop_addAnimation:cartEndUp forKey:@"cartEndAnimation"];
        [cartEndUp setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *cartEndDown = [POPBasicAnimation linearAnimation];
            cartEndDown.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
            cartEndDown.toValue = [NSValue valueWithCGPoint:CGPointMake(self.carEndCenter.x, self.carEndCenter.y+rangeY)];
            cartEndDown.duration = duration;
            [self.carEndImageView pop_addAnimation:cartEndDown forKey:@"cartEndAnimation"];
        }];
        
        // 眼睛
        CGFloat eye1frameY = self.eyeRight1Center.y-eye1Width/2.0+3;
        CGFloat eye2frameY = self.eyeRight2Center.y-eye2Width/2.0+2;
        POPBasicAnimation *eyeLeft1UpAni = [POPBasicAnimation linearAnimation];
        eyeLeft1UpAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        eyeLeft1UpAni.toValue = @(eye1frameY-rangeY);
        eyeLeft1UpAni.duration = duration;
        [self.eyeLeft1ImageView.layer pop_addAnimation:eyeLeft1UpAni forKey:@"eyeLeft1UpDownAnimation"];
        [eyeLeft1UpAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *eyeLeft1DownAni = [POPBasicAnimation linearAnimation];
            eyeLeft1DownAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
            eyeLeft1DownAni.toValue = @(eye1frameY+rangeY);
            eyeLeft1DownAni.duration = duration;
            [self.eyeLeft1ImageView.layer pop_addAnimation:eyeLeft1DownAni forKey:@"eyeLeft1UpDownAnimation"];
        }];
        
        POPBasicAnimation *eyeLeft2UpAni = [POPBasicAnimation linearAnimation];
        eyeLeft2UpAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        eyeLeft2UpAni.toValue = @(eye2frameY-rangeY);
        eyeLeft2UpAni.duration = duration;
        [self.eyeLeft2ImageView.layer pop_addAnimation:eyeLeft2UpAni forKey:@"eyeLeft2UpDownAnimation"];
        [eyeLeft2UpAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *eyeLeft2DownAni = [POPBasicAnimation linearAnimation];
            eyeLeft2DownAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
            eyeLeft2DownAni.toValue = @(eye2frameY+rangeY);
            eyeLeft2DownAni.duration = duration;
            [self.eyeLeft2ImageView.layer pop_addAnimation:eyeLeft2DownAni forKey:@"eyeLeft2UpDownAnimation"];
        }];
        
        POPBasicAnimation *eyeRight1UpAni = [POPBasicAnimation linearAnimation];
        eyeRight1UpAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        eyeRight1UpAni.toValue = @(eye1frameY-rangeY);
        eyeRight1UpAni.duration = duration;
        [self.eyeRight1ImageView.layer pop_addAnimation:eyeRight1UpAni forKey:@"eyeRight1UpDownAnimation"];
        [eyeRight1UpAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *eyeRight1DownAni = [POPBasicAnimation linearAnimation];
            eyeRight1DownAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
            eyeRight1DownAni.toValue = @(eye1frameY+rangeY);
            eyeRight1DownAni.duration = duration;
            [self.eyeRight1ImageView.layer pop_addAnimation:eyeRight1DownAni forKey:@"eyeRight1UpDownAnimation"];
        }];
        
        POPBasicAnimation *eyeRight2UpAni = [POPBasicAnimation linearAnimation];
        eyeRight2UpAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
        eyeRight2UpAni.toValue = @(eye2frameY-rangeY);
        eyeRight2UpAni.duration = duration;
        [self.eyeRight2ImageView.layer pop_addAnimation:eyeRight2UpAni forKey:@"eyeRight2UpDownAnimation"];
        [eyeRight2UpAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *eyeRight2DownAni = [POPBasicAnimation linearAnimation];
            eyeRight2DownAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
            eyeRight2DownAni.toValue = @(eye2frameY+rangeY);
            eyeRight2DownAni.duration = duration;
            [self.eyeRight2ImageView.layer pop_addAnimation:eyeRight2DownAni forKey:@"eyeRight2UpDownAnimation"];
        }];
    });
}

// 执行骑手眼睛左右移动的动画
- (void)executeHorsemanEyeAnimation{
    if ( self.stopAllAnimation ) return;
    @weakify(self);
    CGFloat duration = 0.175*3;
    // 眼睛
    CGFloat eye1LeftframeX = self.eyeLeft1Center.x-eye1Width/2.0+3;
    CGFloat eye2LeftframeX = self.eyeLeft2Center.x-eye2Width/2.0+2;
    CGFloat eye1RightframeX = self.eyeRight1Center.x-eye1Width/2.0+3;
    CGFloat eye2RightframeX = self.eyeRight2Center.x-eye2Width/2.0+2;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration/5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        POPBasicAnimation *eyeLeft1LeftAni = [POPBasicAnimation linearAnimation];
        eyeLeft1LeftAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
        eyeLeft1LeftAni.toValue = [NSValue valueWithCGPoint:CGPointMake(eye1LeftframeX-0.5, self.eyeLeft1Center.y)];
        eyeLeft1LeftAni.duration = duration;
        [self.eyeLeft1ImageView pop_addAnimation:eyeLeft1LeftAni forKey:@"eyeLeft1Animation"];
        [eyeLeft1LeftAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *eyeLeft1RightAni = [POPBasicAnimation linearAnimation];
            eyeLeft1RightAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
            eyeLeft1RightAni.toValue = [NSValue valueWithCGPoint:CGPointMake(eye1LeftframeX+0.5, self.eyeLeft1Center.y)];
            eyeLeft1RightAni.duration = duration;
            [self.eyeLeft1ImageView pop_addAnimation:eyeLeft1RightAni forKey:@"eyeLeft1Animation"];
        }];
        
        POPBasicAnimation *eyeLeft2LeftAni = [POPBasicAnimation linearAnimation];
        eyeLeft2LeftAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
        eyeLeft2LeftAni.toValue = [NSValue valueWithCGPoint:CGPointMake(eye2LeftframeX-1, self.eyeLeft2Center.y)];
        eyeLeft2LeftAni.duration = duration;
        [self.eyeLeft2ImageView pop_addAnimation:eyeLeft2LeftAni forKey:@"eyeLeft2Animation"];
        [eyeLeft2LeftAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *eyeLeft2RightAni = [POPBasicAnimation linearAnimation];
            eyeLeft2RightAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
            eyeLeft2RightAni.toValue = [NSValue valueWithCGPoint:CGPointMake(eye2LeftframeX+1, self.eyeLeft2Center.y)];
            eyeLeft2RightAni.duration = duration;
            [self.eyeLeft2ImageView pop_addAnimation:eyeLeft2RightAni forKey:@"eyeLeft2Animation"];
        }];
        
        POPBasicAnimation *eyeRight1LeftAni = [POPBasicAnimation linearAnimation];
        eyeRight1LeftAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
        eyeRight1LeftAni.toValue = [NSValue valueWithCGPoint:CGPointMake(eye1RightframeX-0.5, self.eyeRight1Center.y)];
        eyeRight1LeftAni.duration = duration;
        [self.eyeRight1ImageView pop_addAnimation:eyeRight1LeftAni forKey:@"eyeRight1Animation"];
        [eyeRight1LeftAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *eyeRight1RightAni = [POPBasicAnimation linearAnimation];
            eyeRight1RightAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
            eyeRight1RightAni.toValue = [NSValue valueWithCGPoint:CGPointMake(eye1RightframeX+0.5, self.eyeRight1Center.y)];
            eyeRight1RightAni.duration = duration;
            [self.eyeRight1ImageView pop_addAnimation:eyeRight1RightAni forKey:@"eyeRight1Animation"];
        }];
        
        POPBasicAnimation *eyeRight2LeftAni = [POPBasicAnimation linearAnimation];
        eyeRight2LeftAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
        eyeRight2LeftAni.toValue = [NSValue valueWithCGPoint:CGPointMake(eye2RightframeX-1, self.eyeRight2Center.y)];
        eyeRight2LeftAni.duration = duration;
        [self.eyeRight2ImageView pop_addAnimation:eyeRight2LeftAni forKey:@"eyeRight2Animation"];
        [eyeRight2LeftAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            @strongify(self);
            POPBasicAnimation *eyeRight2RightAni = [POPBasicAnimation linearAnimation];
            eyeRight2RightAni.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
            eyeRight2RightAni.toValue = [NSValue valueWithCGPoint:CGPointMake(eye2RightframeX+1, self.eyeRight2Center.y)];
            eyeRight2RightAni.duration = duration;
            [self.eyeRight2ImageView pop_addAnimation:eyeRight2RightAni forKey:@"eyeRight2Animation"];
            [eyeRight2RightAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
                [self executeHorsemanEyeAnimation];
            }];
        }];
    });
}

// 执行气球动画
- (void)executeBalloonAnimation{
    CGFloat swingX = ((round(arc4random() % 3)) - 1)*5;
    CGFloat swingY = ((round(arc4random() % 3)) - 1)*5;
    POPBasicAnimation *balloonAni = [POPBasicAnimation easeOutAnimation];
    balloonAni.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    balloonAni.toValue = [NSValue valueWithCGRect:CGRectMake(balloonLeft+swingX, [self balloonTop]+swingY, balloonWidth, balloonHeight)];
    balloonAni.duration = 2;
    [self.balloonImageView pop_addAnimation:balloonAni forKey:@"balloonAnimation"];
    @weakify(self);
    [balloonAni setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        @strongify(self);
        if ( !self.stopAllAnimation ) {
            [self executeBalloonAnimation];
        }
    }];
}

// 执行Refresh结束动画
- (void)executeRefreshOverAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        self.horsemanView.layer.transform = CATransform3DMakeScale(10, 10 ,10);
    }];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing或者执行ExtraBlock的状态
    if (self.state == MJRefreshStateRefreshing ||
        self.state == LXTRefreshStateExtraBlocking) {
        if (self.window == nil) return;
        // sectionheader停留解决
        if ( self.state == MJRefreshStateRefreshing ) {
            self.scrollView.mj_insetT = self.refreshBlockOffsetY;
            self.insetTDelta = _scrollViewOriginalInset.top - self.refreshBlockOffsetY;
        }
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.refreshBlockOffsetY;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.refreshBlockOffsetY;
    
    // 即将刷新 和 extraBlock 的临界点
    CGFloat pulling2extraOffsetY = happenOffsetY - self.extraBlockOffsetY;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle){
            if ( normal2pullingOffsetY > offsetY && offsetY > pulling2extraOffsetY ) {
                // 转为即将刷新状态
                self.state = MJRefreshStatePulling;
            }
            else if ( offsetY <= pulling2extraOffsetY ){
                self.state = LXTRefreshStateExtraBlockPulling;
            }
            else { self.state = MJRefreshStateIdle; }
        }
        else if ( self.state == MJRefreshStatePulling ) {
            if ( offsetY >= normal2pullingOffsetY ) {
                // 转为普通状态
                self.state = MJRefreshStateIdle;
            }
            else if ( offsetY <= pulling2extraOffsetY ){
                self.state = LXTRefreshStateExtraBlockPulling;
            }
            else { /** 状态不变 */ }
        }
        else if (self.state == LXTRefreshStateExtraBlockPulling){
            if ( normal2pullingOffsetY > offsetY && offsetY > pulling2extraOffsetY ) {
                // 转为即将刷新状态
                self.state = MJRefreshStatePulling;
            }
            else if ( offsetY > normal2pullingOffsetY ){
                self.state = MJRefreshStateIdle;
            }
            else { /** 状态不变 */ }
        }
    } else {
        if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
            // 开始刷新
            [self beginRefreshing];
        } else if (self.state == LXTRefreshStateExtraBlockPulling) {// 即将执行Block && 手松开
            [self beginExtraBlock];
        } else if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent;
        }
    }
}


#pragma mark 执行extraBlock
- (void)executeExtraBlockCallback{
    if ( self.extraBlock ) {
        self.extraBlock();
    }
}

- (void)beginExtraBlock
{
    [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.state = LXTRefreshStateExtraBlocking;
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    // 下拉刷新
    if ( state == MJRefreshStateIdle ) {
        self.statusLabel.text = @"下拉刷新";
        [self removeAllAnimation];
        [self initializAutolayout];
    }
    // 继续下拉有惊喜
    else if ( state == MJRefreshStatePulling ) {
        self.statusLabel.text = @"继续下拉有惊喜";
        
    }
    // 刷新中
    else if ( state == MJRefreshStateRefreshing ) {
        self.statusLabel.text = @"刷新中";
        [self executeAllAnimation];
    }
    // 松手看惊喜
    else if ( state == LXTRefreshStateExtraBlockPulling ) {
        self.statusLabel.text = @"松手看惊喜";

    }
    // 爬楼中
    else if ( state == LXTRefreshStateExtraBlocking ) {
        self.statusLabel.text = @"爬楼中";
        
    }
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState != MJRefreshStateRefreshing &&
            oldState != LXTRefreshStateExtraBlocking) return;
        
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 恢复inset和offset
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            self.scrollView.mj_insetT += self.insetTDelta;
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
        }];
    }
    else if (state == MJRefreshStateRefreshing) {
        [UIView animateWithDuration:self.refreshFastAnimationDuration animations:^{
            // 增加滚动区域
            CGFloat top = self.scrollViewOriginalInset.top + self.refreshBlockOffsetY;
            NSLog(@"-----------------------------\n%f",top);
            self.scrollView.mj_insetT = top;
            // 设置滚动位置
            self.scrollView.mj_offsetY = - top;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
    else if (state == LXTRefreshStateExtraBlocking){
        [self executeExtraBlockCallback];
        // 增加滚动区域
        CGFloat top = self.scrollViewOriginalInset.top - self.scrollView.contentOffset.y;
        self.scrollView.mj_insetT = top;
        // 设置滚动位置
        self.scrollView.mj_offsetY = - top;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSLog(@"%f",pullingPercent);
    if ( pullingPercent>0  ) {
        self.statusLabel.alpha = pullingPercent>1?1:pullingPercent;
        self.roadLineView.layer.anchorPoint = CGPointMake(0.5, pullingPercent*maxAnchorPointX2);
        if ( pullingPercent<1 ) {
            self.horsemanView.layer.transform = CATransform3DMakeScale(pullingPercent, pullingPercent ,pullingPercent);
        }
    }
    else{
        self.statusLabel.alpha = 0;
    }
}

#pragma mark - 公共方法
- (void)endRefreshing
{
    if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super endRefreshing];
        });
    } else {
        [super endRefreshing];
    }
    [self executeRefreshOverAnimation];
}

- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}

#pragma mark - C方法

CATransform3D LXT_CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D LXT_CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, LXT_CATransform3DMakePerspective(center, disZ));
}

double LXT_radians(float degrees) {
    return ( degrees * M_PI ) / 180.0;
}
@end
