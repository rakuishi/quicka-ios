//
//  CustomTableViewCell.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/29/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation DefaultIconCell

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.imageView.frame = CGRectMake(15.f, (44.f - 29.f) / 2.f, 29.f, 29.f);
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.imageView.frame) + 10.f;
    frame.size.width = frame.size.width + 10.f;
    self.textLabel.frame = frame;
}

@end

@implementation DefaultSubtitleIconCell

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.imageView.frame = CGRectMake(15.f, (44.f - 29.f) / 2.f, 29.f, 29.f);
    // self.imageView.image = [QuickaUtil maskImage:self.imageView.image];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.imageView.frame) + 10.f;
    frame.size.width = frame.size.width + 10.f;
    self.textLabel.frame = frame;
    
    frame = self.detailTextLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.imageView.frame) + 10.f;
    frame.size.width = frame.size.width + 10.f;
    self.detailTextLabel.frame = frame;
}

@end

@implementation DefaultCenterCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(15.f, 7.f, 29.f, 29.f);
}

@end

@implementation BookmarkCell

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.f, (44.f - 20.f) / 2.f, 20.f, 20.f);
    self.imageView.tintColor = [UIColor colorWithRed:0xBD/255.f green:0xBE/255.f blue:0xC2/255.f alpha:1.f];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.imageView.frame) + 8.f;
    frame.size.width = frame.size.width + 8.f;
    self.textLabel.frame = frame;
    
    frame = self.detailTextLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.imageView.frame) + 8.f;
    frame.size.width = frame.size.width + 8.f;
    self.detailTextLabel.frame = frame;
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
