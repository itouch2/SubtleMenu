//
//  ViewController.m
//  SubtleMenu
//
//  Created by Tu You on 14-3-22.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "ViewController.h"
#import "SubtleMenu.h"

@interface ViewController () <SubtleMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bottomMenuClicked:(id)sender
{
    SubtleMenuItem *item0 = [[SubtleMenuItem alloc] initWithImage:[UIImage imageNamed:@"ActionSheetIconReshare"] title:@"Reshare Post" subtitle:@"Instantly share this post with Public"];
    SubtleMenuItem *item1 = [[SubtleMenuItem alloc] initWithImage:[UIImage imageNamed:@"ActionSheetIconCompose"] title:@"Share in New Post" subtitle:nil];
    SubtleMenuItem *item2 = [[SubtleMenuItem alloc] initWithImage:[UIImage imageNamed:@"ActionSheetIconMessage"] title:@"Facebook Message" subtitle:nil];
    SubtleMenuItem *item3 = [[SubtleMenuItem alloc] initWithImage:[UIImage imageNamed:@"ActionSheetIconTextMessage"] title:@"Text Message" subtitle:nil];
    SubtleMenuItem *item4 = [[SubtleMenuItem alloc] initWithImage:[UIImage imageNamed:@"ActionSheetIconEmail"] title:@"Email" subtitle:nil];
    SubtleMenuItem *item5 = [[SubtleMenuItem alloc] initWithImage:[UIImage imageNamed:@"ActionSheetIconSavePhoto"] title:@"Save to Pocket" subtitle:nil];
//    SubtleMenuItem *otherItem = [[SubtleMenuItem alloc] initWithImage:[UIImage imageNamed:@""] title:@"Others..." subtitle:@""];
    
    NSArray *menuItems = @[item0, item1, item2, item3, item4, item5];
    SubtleMenu *menu = [[SubtleMenu alloc] initWithMenuItems:menuItems submenuItems:nil];
    menu.popDirection = SubtleMenuPopDirectionTop;
    [menu showInView:self.view at:((UIControl *)sender).center];
    
}

- (IBAction)topMenuClicked:(id)sender
{
    
}

#pragma mark SubtleMenu Delegate

- (void)didSelectMenuAtRow:(NSInteger)row atSubmenu:(BOOL)submenu
{
    
}

@end
