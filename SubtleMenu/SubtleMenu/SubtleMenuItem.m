//
//  SubtleMenuItem.m
//  SubtleMenu
//
//  Created by Tu You on 14-3-22.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "SubtleMenuItem.h"

@implementation SubtleMenuItem

- (instancetype)initWithImage:(UIImage *)itemImage title:(NSString *)title subtitle:(NSString *)subtitle
{
    if (self = [super init])
    {
        self.itemImage = itemImage;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

@end
