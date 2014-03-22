//
//  SubtleMenu.m
//  SubtleMenu
//
//  Created by Tu You on 14-3-22.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "SubtleMenu.h"

#define kDefaultContentViewCellRect CGRectMake(0, 0, 320.0f, 44.0f)
#define kDefaultMenuWidth (300.0f)
#define kDefaultArrowWidth  (20.0f)
#define kInitCellTag (101)

static NSString *const kPoppingAnimationKey = @"popping";
static NSString *const kDismissAnimationKey = @"dismiss";
static NSString *const kTappedAnimationKey = @"tapped";

static CABasicAnimation *popping_animation()
{
    CABasicAnimation *poppingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    poppingAnimation.fromValue = @(0.01);
    poppingAnimation.toValue = @(1.0);
    poppingAnimation.duration = 0.5;
    poppingAnimation.fillMode = kCAFillModeForwards;
    poppingAnimation.removedOnCompletion = NO;
    poppingAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :1.6 :0.6 :1.0];
    return poppingAnimation;
}

static CABasicAnimation *dismiss_animation()
{
    CABasicAnimation *dismissAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    dismissAnimation.fromValue = @(1.0f);
    dismissAnimation.toValue = @(0.0f);
    dismissAnimation.fillMode = kCAFillModeForwards;
    dismissAnimation.removedOnCompletion = NO;
    dismissAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return dismissAnimation;
}

static CAKeyframeAnimation *tapped_animation()
{
    CAKeyframeAnimation *tappedAnimation = [CAKeyframeAnimation animationWithKeyPath:kTappedAnimationKey];
    tappedAnimation.keyTimes = @[@(0.0f), @(0.8f), @(1.0f)];
    tappedAnimation.values = @[@(1.0), @(0.5), @(0.8)];
    tappedAnimation.duration = 0.25;
    return tappedAnimation;
}

@interface SubtleContentViewCell : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation SubtleContentViewCell

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle
{
    if (self = [super initWithFrame:kDefaultContentViewCellRect])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [self addSubview:self.imageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.frame = CGRectMake(0, 0, 200, 15);
        self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        
        self.subtitleLabel = [UILabel new];
        self.subtitleLabel.frame = CGRectMake(0, 25, 200, 14);
        self.subtitleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.text = subtitle;
        [self addSubview:self.subtitleLabel];
    }
    return self;
}

@end

@interface SubtleContentView : UIView

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation SubtleContentView

- (instancetype)initWithMenuItems:(NSArray *)menuItems
{
    if (self = [super init])
    {
        self.menuItems = menuItems;
    }
    return self;
}

- (void)setMenuItems:(NSArray *)menuItems
{
    if (_menuItems != menuItems)
    {
        _menuItems = menuItems;
        [self reloadData];
    }
}

- (void)reloadData
{
    for (UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }
    
    for (int i = 0; i < self.menuItems.count; i++)
    {
        SubtleMenuItem *item = self.menuItems[i];
        SubtleContentViewCell *cell = [[SubtleContentViewCell alloc] initWithImage:item.itemImage
                                                                             title:item.title
                                                                          subtitle:item.subtitle];
        CGRect frame = cell.frame;
        frame.origin.y = i * 44;
        cell.frame = frame;
        
        cell.tag = kInitCellTag + i;
        [self addSubview:cell];
    }
}

@end

@interface SubtleMenu ()

@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@property (nonatomic, strong) SubtleContentView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SubtleMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [[UIScreen mainScreen] bounds];
        
        [self commonInit];
    }
    return self;
}

- (CAShapeLayer *)arrowLayer
{
    if (!_arrowLayer)
    {
        _arrowLayer = [CAShapeLayer layer];
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        if (self.popDirection == SubtleMenuPopDirectionTop)
        {
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, 0);
        }
        else
        {
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, 0);
        }
        
        _arrowLayer.path = path;
        _arrowLayer.fillColor = [UIColor whiteColor].CGColor;
        _arrowLayer.strokeColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
        _arrowLayer.lineWidth = 1.0f;
    }
    return _arrowLayer;
}

- (void)commonInit
{
    self.contentView = [[SubtleContentView alloc] initWithMenuItems:self.menuItems];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.borderColor = [UIColor colorWithWhite:0.2 alpha:1.0].CGColor;
    self.contentView.clipsToBounds = YES;
    [self addSubview:self.contentView];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.contentView addGestureRecognizer:self.tapGesture];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self.contentView addGestureRecognizer:self.panGesture];
    
    self.layer.anchorPoint = CGPointMake(self.startPoint.x / 320, self.popDirection == SubtleMenuPopDirectionTop ? 1 : 0);
}

- (void)popping
{
    CABasicAnimation *poppingAnimation = popping_animation();
    [self.contentView.layer addAnimation:poppingAnimation forKey:kPoppingAnimationKey];
}

- (void)dismiss
{
    CABasicAnimation *dismissAnimation = dismiss_animation();
    [self.contentView.layer addAnimation:dismissAnimation forKey:kDismissAnimationKey];
}

- (void)tapped:(UITapGestureRecognizer *)gestureRecognizer
{
    // tap an item animating
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    NSUInteger index = location.y / 44;
    
    UIView *cell = [self.contentView viewWithTag:(kInitCellTag + index)];
    CAKeyframeAnimation *tappedAnimation = tapped_animation();
    [cell.layer addAnimation:tappedAnimation forKey:kTappedAnimationKey];
}

- (void)panned:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        CGPoint translationFixed = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
        
        // to pan or to shrink
        BOOL panned = YES;
        if (self.popDirection == SubtleMenuPopDirectionTop)
        {
            panned = (translationFixed.y > 0);
        }
        else
        {
            panned = (translationFixed.y < 0);
        }
        
        if (panned)
        {
            // pan the subtle menu content view
            CGRect frame = self.contentView.frame;
            frame.origin.y += translation.y;
            self.contentView.frame = frame;
            
            // TODO: animate the arrow
        }
        else
        {
            // shrink the subtle menu content view
            self.contentView.transform = CGAffineTransformMakeScale(1 / fabs(translationFixed.y),
                                                                    1 / fabs(translationFixed.y));
        }
        
        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
    }
}

@end