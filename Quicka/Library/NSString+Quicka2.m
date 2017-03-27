//
//  NSString+Quicka2.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 1/23/14.
//  Copyright (c) 2014 OCHIISHI Koichiro. All rights reserved.
//

#import "NSString+Quicka2.h"

@implementation NSString (Quicka2)

- (NSString *)UTF8EncodedString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

- (NSString *)UTF8DecodedString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
}

- (NSString *)transitYahooURLString
{
    NSArray *list = [self componentsSeparatedByString:@" "];
    if (list.count != 2) {
        return nil;
    }
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    [formatter setDateFormat:@"yyyyMM"];
    NSString *ym = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"dd"];
    NSString *d = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"H"];
    NSString *hh = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"mm"];
    NSString *mm = [formatter stringFromDate:date];
    NSString *m1 = [mm substringWithRange:NSMakeRange(0,1)];
    NSString *m2 = [mm substringWithRange:NSMakeRange(1,1)];
    
    NSString *url = [NSString stringWithFormat:@"http://transit.loco.yahoo.co.jp/search/result"
                     "?from=%@&to=%@&ym=%@&d=%@&hh=%@&m1=%@&m2=%@&ei=utf-8", list[0], list[1], ym, d, hh, m1, m2];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)convertedString
{
    if ([self hasSuffix:@"☻"] == NO || self.length < 2) {
        return self;
    }
    
    NSString *string = [self substringWithRange:NSMakeRange(self.length - 2, 1)];
    NSArray *convert = @[@[@"あ", @"ぁ"], @[@"い", @"ぃ"], @[@"う", @"ぅ", @"ゔ"], @[@"え", @"ぇ"], @[@"お", @"ぉ"],
                         @[@"か", @"が"], @[@"き", @"ぎ"], @[@"く", @"ぐ"], @[@"け", @"げ"], @[@"こ", @"ご"],
                         @[@"さ", @"ざ"], @[@"し", @"じ"], @[@"す", @"ず"], @[@"せ", @"ぜ"], @[@"そ", @"ぞ"],
                         @[@"た", @"だ"], @[@"ち", @"ぢ"], @[@"つ", @"っ", @"づ"], @[@"て", @"で"], @[@"と", @"ど"],
                         @[@"は", @"ば", @"ぱ"], @[@"ひ", @"び", @"ぴ"], @[@"ふ", @"ぶ", @"ぷ"], @[@"へ", @"べ", @"ぺ"], @[@"ほ", @"ぼ", @"ぽ"],
                         @[@"や", @"ゃ"], @[@"ゆ", @"ゅ"], @[@"よ", @"ょ"]];
    
    for (NSArray *h in convert) {
        for (int i = 0; i < h.count; i++) {
            if ([string isEqualToString:h[i]]) {
                return [self stringByReplacingOccurrencesOfString:[self substringWithRange:NSMakeRange(self.length - 2, 2)]
                                                       withString:h[(++i < h.count) ? i : 0]];
            }
        }
    }
    
    return [self substringWithRange:NSMakeRange(0, self.length - 1)];
}

@end
