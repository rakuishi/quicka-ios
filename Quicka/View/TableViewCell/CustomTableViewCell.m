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
    
    self.imageView.frame = CGRectMake(15.f, (self.frame.size.height - 29.f) / 2.f, 29.f, 29.f);
    
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
    
    self.imageView.frame = CGRectMake(15.f, (self.frame.size.height - 29.f) / 2.f, 29.f, 29.f);
    
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
    
    self.imageView.frame = CGRectMake(15.f, (self.frame.size.height - 29.f) / 2.f, 29.f, 29.f);
}

@end
