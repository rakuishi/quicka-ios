//
//  NSString+Quicka2.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 1/23/14.
//  Copyright (c) 2014 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Quicka2)

- (NSString *)UTF8EncodedString;
- (NSString *)UTF8DecodedString;
- (NSString *)transitYahooURLString;
- (NSString *)convertedString;

@end
