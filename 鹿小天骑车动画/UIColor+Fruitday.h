//
//  UIColor+Fruitday.h
//  Fruitday
//
//  Created by Leo on 4/2/14.
//  Copyright (c) 2014 Fruitday. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

@interface UIColor (Fruitday)

+(UIColor *) fruitdayGreen;
+(UIColor *) fruitdayLightGreen;
+(UIColor *) fruitdayOrange;
+(UIColor *) fruitdayTitleGray;
+(UIColor *) fruitdayBackgroundGray;
+(UIColor *) fruitdayLightGray;
+(UIColor *) fruitdayBusyBackground;
+(UIColor *) fruitdayWhiteTransparent;
+(UIColor *) fruitdayGSBackgroundGray;
+(UIColor *) fruitdayGSLineGray;
+(UIColor *) fruitdayTransparentGreen;
+(UIColor *) fruitdayTransparentOrange;
+(UIColor *) fruitdayTransparentGray;
// 背景遮罩层的颜色
+(UIColor *) fruitdayShadeBackground;

/**
 *  按钮被禁用时的灰色
 *
 *  @return UIColor
 */
+ (UIColor *)disabledButtonGray;

/**
 *  登录注册页面分割线颜色
 *
 *  @return UIColor
 */
+ (UIColor *)separatorBrown;

/**
 *  描述文字的灰色字体
 *
 *  @return UIColor
 */
+ (UIColor *)fruitdayDescriptionText;

/**
 *  黑色粗体字颜色
 *
 *  @return UIColor
 */
+ (UIColor *)fruitdayBoldBlackText;

/**
 *  亮灰色颜色
 *
 *  @return UIColor
 */
+ (UIColor *)fruitdayLightGaryText;

/**
 *  灰色颜色
 *
 *  @return UIColor
 */
+ (UIColor *)fruitdayGaryText;

/**
 *  分割线颜色
 *
 *  @return UIColor
 */
+ (UIColor *)fruitdayLine;

/**
 *  淡灰色分割线
 *
 *  @return UIColor
 */
+ (UIColor *)fruitdaLightGaryyLine;

/**
 *  根据商品Tag获取对应的颜色
 *
 *  @param tag Tag
 *
 *  @return UIColor
 */
+ (UIColor *)colorForTag:(NSString *)tag;

/**
 *  根据色值String获取颜色
 *
 *  @param color 色值String 如@"#2B2B2B"或者@"0X2B2B2B"或者@"2B2B2B"
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  根据色值String获取颜色
 *
 *  @param color 色值String 如@"#2B2B2B"或者@"0X2B2B2B"或者@"2B2B2B"
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
