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
#define kInitCellTag (101)
#define kDefaultArrowWidth  (12)
#define kDefaultArrowHeight (10)
#define kMaxArrowDisappearOffset  (25)

static NSString *const kPoppingAnimationKey = @"popping";
static NSString *const kDismissAnimationKey = @"dismiss";
static NSString *const kShrinkAnimationKey = @"shrink";

static CABasicAnimation *popping_animation()
{
    CABasicAnimation *poppingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    poppingAnimation.fromValue = @(0.01);
    poppingAnimation.toValue = @(1.0);
    poppingAnimation.duration = 0.5;
    poppingAnimation.fillMode = kCAFillModeForwards;
    poppingAnimation.removedOnCompletion = NO;
    poppingAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :1.4 :0.6 :1.0];
    return poppingAnimation;
}

static CABasicAnimation *dismiss_animation()
{
    CABasicAnimation *dismissAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    dismissAnimation.toValue = @(0.0f);
    dismissAnimation.fillMode = kCAFillModeForwards;
    dismissAnimation.removedOnCompletion = NO;
    dismissAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return dismissAnimation;
}

static CAKeyframeAnimation *shrink_animation()
{
    CAKeyframeAnimation *shrinkAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    shrinkAnimation.keyTimes = @[@(0.0f), @(0.75f), @(1.0f)];
    shrinkAnimation.values = @[@(1.0), @(0.85), @(0.92)];
    shrinkAnimation.duration = 0.25;
    shrinkAnimation.fillMode = kCAFillModeForwards;
    shrinkAnimation.removedOnCompletion = NO;
    return shrinkAnimation;
}

@interface SubtleContentViewCell : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, assign) BOOL hasSeparator;

@end

@implementation SubtleContentViewCell

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle
{
    if (self = [super initWithFrame:kDefaultContentViewCellRect])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.frame = CGRectMake(15, (44 - image.size.height) / 2, image.size.width, image.size.height);
        [self addSubview:self.imageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.frame = CGRectMake(15 + CGRectGetWidth(self.imageView.frame) + 5, 5, 200, 18);
        self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        
        self.subtitleLabel = [UILabel new];
        self.subtitleLabel.frame = CGRectMake(15 + CGRectGetWidth(self.imageView.frame) + 5, 22, 280, 14);
        self.subtitleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.font = [UIFont systemFontOfSize:12];
        self.subtitleLabel.text = subtitle;
        [self addSubview:self.subtitleLabel];
        
        if (!subtitle)
        {
            self.titleLabel.center = CGPointMake(self.titleLabel.center.x, 22);
        }
    }
    return self;
}

- (void)setHasSeparator:(BOOL)hasSeparator
{
    _hasSeparator = hasSeparator;
    if (_hasSeparator)
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(15, 43, 290, 1 / [UIScreen mainScreen].scale)];
        separator.backgroundColor = [UIColor colorWithWhite:0.89 alpha:1];
        [self addSubview:separator];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CAKeyframeAnimation *shrinkAnimation = shrink_animation();
    [self.titleLabel.layer addAnimation:shrinkAnimation forKey:kShrinkAnimationKey];
    [self.subtitleLabel.layer addAnimation:shrinkAnimation forKey:kShrinkAnimationKey];
    [self.imageView.layer addAnimation:shrinkAnimation forKey:kShrinkAnimationKey];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    void (^animations)() = ^() {
        self.titleLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.subtitleLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    };
    
    [UIView animateWithDuration:0.1 animations:animations];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    void (^animations)() = ^() {
        self.titleLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.subtitleLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    };
    
    [UIView animateWithDuration:0.1 animations:animations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    void (^animations)() = ^() {
        self.titleLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.subtitleLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    };
    
    [UIView animateWithDuration:0.1 animations:animations];
}

@end

@interface SubtleContentView : UIView

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *otherMenuItems;

@end

@implementation SubtleContentView

- (instancetype)initWithMenuItems:(NSArray *)menuItems otherMenuItems:(NSArray *)otherMenuItems
{
    if (self = [super init])
    {
        self.menuItems = menuItems;
        self.otherMenuItems = otherMenuItems;
        
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.frame = CGRectMake(0, 0, 320, self.menuItems.count * 44 + 15);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 5.0f;
//    self.layer.shadowOpacity = 0.5;
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
        
        cell.hasSeparator = !(i == self.menuItems.count - 1);
    }
}

@end


@interface SubtleArrowView : UIView

@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@property (nonatomic, assign) SubtleMenuPopDirection popDirection;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImage *arrowImage;

@end

@implementation SubtleArrowView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:self.arrowImage];
        self.arrowImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.arrowImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.arrowImageView];
    }
    return self;
}

- (UIImage *)arrowImage
{
    if (!_arrowImage)
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)), NO, [UIScreen mainScreen].scale);
        
        [[UIColor whiteColor] setFill];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        if (self.popDirection == SubtleMenuPopDirectionTop)
        {
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
            [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
            [path closePath];
        }
        else
        {
            [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame) / 2, 0)];
            [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
            [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [path closePath];
        }
        [path fill];
        
        _arrowImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _arrowImage;
}

@end

@interface SubtleMenu ()

@property (nonatomic, strong) SubtleContentView *contentView;
@property (nonatomic, strong) SubtleArrowView *arrowView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *bgTapGesture;

@end

@implementation SubtleMenu

- (instancetype)initWithMenuItems:(NSArray *)menuItems submenuItems:(NSArray *)submenuItems
{
    if (self = [super init])
    {
        self.menuItems = menuItems;
        self.submenuItems = submenuItems;
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.58 alpha:0.8];
    
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.arrowView];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self.contentView addGestureRecognizer:self.panGesture];
    
    self.bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapped:)];
    [self addGestureRecognizer:self.bgTapGesture];
}

- (SubtleContentView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[SubtleContentView alloc] initWithMenuItems:self.menuItems
                                                     otherMenuItems:self.submenuItems];
    }
    return _contentView;
}

- (SubtleArrowView *)arrowView
{
    if (!_arrowView)
    {
        _arrowView = [[SubtleArrowView alloc] initWithFrame:CGRectMake(0, 0, kDefaultArrowWidth, kDefaultArrowHeight)];
        _arrowView.popDirection = self.popDirection;
    }
    return _arrowView;
}

- (void)showInView:(UIView *)view at:(CGPoint)startPoint
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint convertedPoint = [window convertPoint:startPoint fromView:view];
    convertedPoint.y -= 2;
    self.startPoint = convertedPoint;
    
    [window addSubview:self];
    
    self.contentView.layer.anchorPoint = CGPointMake(self.startPoint.x / 320, self.popDirection == SubtleMenuPopDirectionTop ? 1 : 0);
    self.contentView.frame = CGRectMake(0, self.startPoint.y - kDefaultArrowHeight - 44 * self.menuItems.count, 320, 44 * self.menuItems.count);

    CGPoint converted = [self.contentView convertPoint:CGPointMake(self.startPoint.x - kDefaultArrowWidth / 2, self.startPoint.y - kDefaultArrowHeight) fromView:self];
    
    self.arrowView.frame = CGRectMake(converted.x, converted.y, kDefaultArrowWidth, kDefaultArrowHeight);
    
    [self popping];
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
    
    void (^animations)() = ^(){
        self.alpha = 0.0f;
    };
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        [self removeFromSuperview];
    };
    [UIView animateWithDuration:0.2 animations:animations completion:completion];
}

- (void)bgTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self dismiss];
}

- (void)panned:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = CGPointZero, translationFixed = CGPointZero;
    BOOL dismiss = NO;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        translationFixed = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
        
        // to pan or to shrink
        BOOL panned = YES;
        if (self.popDirection == SubtleMenuPopDirectionTop)
        {
            panned = (translationFixed.y < 0);
            dismiss = panned ? translationFixed.y < -kMaxArrowDisappearOffset : NO;
        }
        else
        {
            panned = (translationFixed.y > 0);
            dismiss = panned ? translationFixed.y > kMaxArrowDisappearOffset : NO;
        }
        
        if (panned)
        {
            CGFloat distance = translation.y;
            
            // pan the subtle menu content view
            CGRect frame = self.contentView.frame;
            frame.origin.y += distance;
            self.contentView.frame = frame;
            
            // TODO: animate the arrow
            frame = self.arrowView.frame;
            frame.size.height += fabs(distance);
            static BOOL finished = YES;
            if (frame.size.height > 35)
            {
                finished = NO;
                [UIView animateWithDuration:0.15 animations:^{
                    CGRect frame = self.arrowView.frame;
                    frame.size.height = 0;
                    self.arrowView.frame = frame;
                } completion:^(BOOL finished) {
                    finished = finished;
                }];
            }
            else
            {
                if (finished)
                {
                     self.arrowView.frame = frame;
                }
            }
        }
        else
        {
            // shrink the subtle menu content view
            double factor = 1 - (fabs(translationFixed.y) / self.contentView.frame.size.height) * 0.7;
            self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            dismiss = (factor < 0.40);
        }
        
        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (dismiss)
        {
            // dimiss the menu
            [self dismiss];
        }
        else
        {
            // restore to the initial state
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }
    }
     self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
}

@end