//
//  SuggestView.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/29/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuggestViewDelegate <NSObject>

- (void)selectedSuggestedWord:(NSString *)suggestedWord;

@end

@interface SuggestView : UIView

@property (nonatomic, weak) id <SuggestViewDelegate> delegate;

- (id)init;
- (void)moveOriginYFromKeyboardRect:(CGRect)frame;
- (void)setQuery:(NSString *)query;

@end
