//
//  CustomActivity.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/15/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserBookmarkManager.h"
#import "QuickaUtil.h"

@interface CustomActivity : NSObject

+ (NSArray *)getApplicationActivities;

@end

@interface CopyActivity : UIActivity

@end

@interface BookmarkActivity: UIActivity

@end

@interface ViewSourceActivity : UIActivity

@end

@interface SafariActivity : UIActivity

@end

@interface ChromeActivity : UIActivity

@end

@interface SleipnirActivity : UIActivity

@end

@interface iCabMobileActivity : UIActivity

@end
