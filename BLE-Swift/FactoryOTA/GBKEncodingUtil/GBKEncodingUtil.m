//
//  GBKEncodingUtil.m
//  BLE-Swift
//
//  Created by Kevin Chen on 2020/1/10.
//  Copyright © 2020 ss. All rights reserved.
//

#import "GBKEncodingUtil.h"

@implementation GBKEncodingUtil

+ (NSString *)GBKTransCoding:(NSString *)str {
    //校验

    if (![str isKindOfClass:[NSString class]]) return @"";

    if (!str.length) return @"";

    //GBK编码

    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
    //    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    //
    //
    //    //NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:str];
    //
    //    //return   [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    //
    ////return   [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];

    return [str stringByAddingPercentEscapesUsingEncoding:enc];
}

@end
