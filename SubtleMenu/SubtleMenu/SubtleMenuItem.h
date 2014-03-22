//
//  SubtleMenuItem.h
//  SubtleMenu
//
//  Created by Tu You on 14-3-22.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubtleMenuItem : NSObject

@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

- (instancetype)initWithImage:(UIImage *)itemImage title:(NSString *)title subtitle:(NSString *)subtitle;

@end
