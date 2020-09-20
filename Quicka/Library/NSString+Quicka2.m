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
    NSString *genDelims = @":/?#[]@";
    NSString *subDelims = @"!$&'()*+,;=";
    NSString *reservedCharacters = [NSString stringWithFormat:@"%@%@", genDelims, subDelims];
    NSMutableCharacterSet * allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [allowedCharacterSet removeCharactersInString:reservedCharacters];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
}

- (NSString *)UTF8DecodedString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, CFSTR("")));
}

- (NSString *)transitYahooURLString
{
    NSArray *list = [self componentsSeparatedByString:@" "];
    if (list.count != 2) list = [self componentsSeparatedByString:@"　"];
    if (list.count != 2) return nil;
    
    NSString *url = [NSString stringWithFormat:@"https://transit.yahoo.co.jp/search/result?from=%@&to=%@", list[0], list[1]];
    return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
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
