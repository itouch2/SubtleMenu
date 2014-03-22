//
//  SubtleMenu.h
//  SubtleMenu
//
//  Created by Tu You on 14-3-22.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubtleMenuItem.h"

typedef NS_ENUM(NSInteger, SubtleMenuPopDirection) {
    SubtleMenuPopDirectionTop,           // menu pops out from bottom to top
    SubtleMenuPopDirectionBottom         // menu pops out from top to bottom
};

@protocol SubtleMenuDelegate <NSObject>

- (void)didSelectMenuAtRow:(NSInteger)row atSubmenu:(BOOL)submenu;

@end

@interface SubtleMenu : UIView

@property (nonatomic, assign) BOOL showAccesssory;
@property (nonatomic, assign) SubtleMenuPopDirection popDirection;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) SubtleMenuItem *others;
@property (nonatomic, strong) NSArray *submenusItems;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGPoint startPoint;

@end
