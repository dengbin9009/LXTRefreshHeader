//
//  UIColor+Fruitday.m
//  Fruitday
//
//  Created by Leo on 4/2/14.
//  Copyright (c) 2014 Fruitday. All rights reserved.
//

#import "UIColor+Fruitday.h"

@implementation UIColor (Fruitday)


+(UIColor *) fruitdayGreen {
    return [UIColor colorWithHexString:@"65A032"];
}
//logo grean
//+(UIColor *) fruitdayGreen {
//    return [UIColor colorWithRed:100.0/255.0 green:150.0/255.0 blue:50.0/255.0 alpha:1];
//}
//logo orange
//+(UIColor *) fruitdayOrange {
//    return [UIColor colorWithRed:246.0/255.0 green:171.0/255.0 blue:0/255.0 alpha:1];
//}
//logo light grean
+(UIColor *) fruitdayLightGreen {
    return [UIColor colorWithRed:145.0/255.0 green:175.0/255.0 blue:60.0/255.0 alpha:1];
}
+(UIColor *) fruitdayTitleGray {
    return [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1];
}

+(UIColor *) fruitdayBackgroundGray {
    return [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
}

+(UIColor *) fruitdayLightGray {
    return [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1];
}
+(UIColor *) fruitdayBusyBackground {
    return [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
}
+(UIColor *) fruitdayWhiteTransparent {
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
}

+(UIColor *) fruitdayGSBackgroundGray {
    return [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
}

+(UIColor *) fruitdayGSLineGray {
    return [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1];
}

+(UIColor *) fruitdayTransparentGreen {
    return [UIColor colorWithRed:60.0/255.0 green:140.0/255.0 blue:30.0/255.0 alpha:0.7];
}

+(UIColor *) fruitdayTransparentOrange {
    return [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:0.7];
}

+(UIColor *) fruitdayTransparentGray {
    return [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
}

+(UIColor *) fruitdayShadeBackground {
    return [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
}

+(UIColor *) fruitdayOrange {
    return [self colorWithHexString:@"FF8000"];
}

+ (UIColor *)disabledButtonGray {
    return [self colorWithHexString:@"BFBFBF"];
}

+ (UIColor *)separatorBrown {
    return [self colorWithHexString:@"887754"];
}

+ (UIColor *)fruitdayDescriptionText {
    return [self colorWithHexString:@"555555"];
}

+ (UIColor *)fruitdayBoldBlackText {
    return [self colorWithHexString:@"2B2B2B"];
}

+ (UIColor *)fruitdayLightGaryText {
    return [self colorWithHexString:@"C4C4C4"];
}

+ (UIColor *)fruitdayGaryText {
    return [self colorWithHexString:@"AAAAAA"];
}

+ (UIColor *)fruitdayLine {
    return [self colorWithHexString:@"D8D8D8"];
}

+ (UIColor *)fruitdaLightGaryyLine {
    return [self colorWithHexString:@"E8E8E8"];
}

+ (UIColor *)colorForTag:(NSString *)tag{
    if ( [tag isEqualToString:@"包邮"] ) {
        return [UIColor colorWithHexString:@"46BABB"];
    }
    else if ( [tag isEqualToString:@"新品"] || [tag isEqualToString:@"优选"] || [tag isEqualToString:@"预售"] ){
        return [UIColor colorWithHexString:@"65A032"];
    }
    else if ( [tag isEqualToString:@"会员专享"] ){
        return [UIColor colorWithHexString:@"9074C4"];
    }
    else{
        return [UIColor colorWithHexString:@"FF5353"];
    }
}



+ (UIColor *)colorWithHexString:(NSString *)color{
    return [self colorWithHexString:color alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
@end
