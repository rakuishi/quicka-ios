//
//  CustomTableViewCell.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/29/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "QuickaUtil.h"

@interface DefaultIconCell : UITableViewCell

@end

@interface DefaultSubtitleIconCell : UITableViewCell

@end

@interface DefaultCenterCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end
