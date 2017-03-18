//
//  LB3DBannerView.m
//  LB3DBanner
//
//  Created by 吴龙波 on 2017/2/15.
//  Copyright © 2017年 吴龙波. All rights reserved.
//

#import "LB3DBannerView.h"
#import "LB3DBannerImageView.h"

typedef NS_ENUM(NSInteger, SwipeDirection)
{
    SwipeLeft = 0,
    SwipeRight = 1
};

#define ANIMATIONDURATION 0.25
#define TIMEINTERVAL 2

@interface LB3DBannerView ()
{
    float midZPosition;
    float leftZPosition;
    float rightZPosition;
    float bgZPosition;///背后隐藏卡片的Z
    
    CGRect midRect;
    CGRect leftRect;
    CGRect rightRect;
    CGRect bgRect;///背后隐藏卡片的Frame
    
    CGFloat offsetX;
    CGFloat offsetY;

    BOOL UserOperating;
}

@property(nonatomic,strong)LB3DBannerImageView *midImageView;

@property(nonatomic,strong)LB3DBannerImageView *leftImageView;

@property(nonatomic,strong)LB3DBannerImageView *rightImageView;

@property(nonatomic,strong)LB3DBannerImageView *leftBGImageView;

@property(nonatomic,strong)LB3DBannerImageView *rightBGImageView;

@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,strong)UITapGestureRecognizer *leftTap;

@property(nonatomic,strong)UITapGestureRecognizer *midTap;

@property(nonatomic,strong)UITapGestureRecognizer *rightTap;

@property(nonatomic,strong)UISwipeGestureRecognizer *leftSwipe;

@property(nonatomic,strong)UISwipeGestureRecognizer *rightSwipe;

@property(nonatomic,strong)UIPanGestureRecognizer *midPan;

@property(nonatomic,assign)BOOL carouselStarted;

@property(nonatomic,strong)NSTimer *timer;
@end

@implementation LB3DBannerView

-(instancetype)initWithFrame:(CGRect)frame andImageURLArray:(NSArray *)imageURLArr
{
    if (self = [super initWithFrame:frame])
    {
        midZPosition = 1;
        rightZPosition = -1;
        leftZPosition = -2;
        bgZPosition = -3;
        [self setUpImageViews];
        self.imageURLArr = imageURLArr;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        midZPosition = 1;
        rightZPosition = -1;
        leftZPosition = -2;
        bgZPosition = -3;
        [self setUpImageViews];
    }
    return self;
}

-(void)setUpImageViews
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    offsetX = 32;
    offsetY = 64;
    
    float midWidth = width / 2;
    float midHeight = height;
    float midX = midWidth / 2;
    float midY = 0;
    midRect = CGRectMake(midX, midY, midWidth, midHeight);
    
    float leftWidth = width / 2 - offsetX;
    float leftHeight = height - offsetY;
    float leftX = midWidth / 2 - leftWidth / 2;
    float leftY = offsetY / 2;
    leftRect = CGRectMake(leftX, leftY, leftWidth, leftHeight);
    
    float rightWidth = width / 2 - offsetX;
    float rightHeight = height - offsetY;
    float rightX = midWidth / 2 * 3 - rightWidth / 2;
    float rightY = offsetY / 2;
    rightRect = CGRectMake(rightX, rightY, rightWidth, rightHeight);
    
    float bgWidth = width / 2 - offsetX;
    float bgHeight = height - offsetY;
    float bgX = width / 2 - bgWidth / 2;
    float bgY = offsetY / 2;
    bgRect = CGRectMake(bgX, bgY, bgWidth, bgHeight);
    
    self.midImageView = [[LB3DBannerImageView alloc]init];
    self.midImageView.frame = midRect;
    self.midImageView.userInteractionEnabled = YES;
//    self.midImageView.imageURL = self.imageURLArr[0];
    self.currentIndex = 0;
    
    self.leftImageView = [[LB3DBannerImageView alloc]init];
    self.leftImageView.frame = leftRect;
    self.leftImageView.userInteractionEnabled = YES;
//    self.leftImageView.imageURL = self.imageURLArr[self.imageURLArr.count - 1];
    
    self.rightImageView = [[LB3DBannerImageView alloc]init];
    self.rightImageView.frame = rightRect;
    self.rightImageView.userInteractionEnabled = YES;
//    self.rightImageView.imageURL = self.imageURLArr[1];
    
    self.leftBGImageView = [[LB3DBannerImageView alloc]init];
    self.leftBGImageView.frame = bgRect;
    self.leftBGImageView.userInteractionEnabled = YES;
//    self.leftBGImageView.imageURL = self.imageURLArr[self.imageURLArr.count - 2];
    
    self.rightBGImageView = [[LB3DBannerImageView alloc]init];
    self.rightBGImageView.frame = bgRect;
    self.rightBGImageView.userInteractionEnabled = YES;
//    self.rightBGImageView.imageURL = self.imageURLArr[2];

    self.midImageView.alpha = 1;
    self.leftImageView.alpha = 0.7;
    self.rightImageView.alpha = 0.7;
    self.leftBGImageView.alpha = 0;
    self.rightBGImageView.alpha = 0;
    
    self.midImageView.layer.zPosition = midZPosition;
    self.leftImageView.layer.zPosition = leftZPosition;
    self.rightImageView.layer.zPosition = rightZPosition;
    self.leftBGImageView.layer.zPosition = bgZPosition;
    self.rightBGImageView.layer.zPosition = bgZPosition;
    
    [self addSubview:self.midImageView];
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.leftBGImageView];
    [self addSubview:self.rightBGImageView];
    
//    self.midImageView.backgroundColor = [UIColor yellowColor];
//    self.leftImageView.backgroundColor = [UIColor redColor];
//    self.rightImageView.backgroundColor = [UIColor greenColor];
//    self.leftBGImageView.backgroundColor = [UIColor blueColor];
//    self.rightBGImageView.backgroundColor = [UIColor grayColor];
    
    self.midTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMidImageView:)];
    [self.midImageView addGestureRecognizer:self.midTap];
    self.midPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMidImageView:)];
    [self.midImageView addGestureRecognizer:self.midPan];
    self.leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLeftImageView:)];
    [self.leftImageView addGestureRecognizer:self.leftTap];
    self.rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRightImageView:)];
    [self.rightImageView addGestureRecognizer:self.rightTap];
    
    self.leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.midImageView addGestureRecognizer:self.leftSwipe];
    self.rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    [self.midImageView addGestureRecognizer:self.rightSwipe];
    
}

#pragma mark - 手势
-(void)panMidImageView:(UIPanGestureRecognizer *)pan
{
    [self stopCarousel];
    
    CGPoint location = [pan translationInView:self];
    
//    NSLog(@"x:%f -- y:%f",location.x,location.y);
    
    CGFloat xDistanceRatio = location.x < 0 ? fabs(location.x) / (midRect.origin.x - leftRect.origin.x) : fabs(location.x) / (rightRect.origin.x - midRect.origin.x);
    if (xDistanceRatio < 1)
    {
        CGRect temp = midRect;
        temp.origin.x += location.x;
        temp.origin.y += offsetY / 2 * xDistanceRatio;
        temp.size.width -= offsetX * xDistanceRatio;
        temp.size.height -= offsetY * xDistanceRatio;
        self.midImageView.frame = temp;
        
        if (location.x < 0)
        {
            self.midImageView.layer.zPosition = midZPosition - 2 * xDistanceRatio;
            self.leftImageView.layer.zPosition = leftZPosition - 2 * xDistanceRatio;
            self.rightImageView.layer.zPosition = rightZPosition + 2 * xDistanceRatio;
            self.rightBGImageView.layer.zPosition = bgZPosition + 2 * xDistanceRatio;
            
            self.leftImageView.alpha = 1 - xDistanceRatio;
            self.midImageView.alpha = 1 - 0.3 * xDistanceRatio;
            self.rightImageView.alpha = 0.7 + 0.3 * xDistanceRatio;
            self.rightBGImageView.alpha = 0.7 * xDistanceRatio;
            
            CGRect tempLeft = leftRect;
            tempLeft.origin.x += (bgRect.origin.x - leftRect.origin.x) * xDistanceRatio;
            self.leftImageView.frame = tempLeft;
            
            CGRect tempRight = rightRect;
            tempRight.origin.x -= (rightRect.origin.x - midRect.origin.x) * xDistanceRatio;
            tempRight.origin.y -= offsetY / 2 * xDistanceRatio;
            tempRight.size.width += offsetX * xDistanceRatio;
            tempRight.size.height += offsetY * xDistanceRatio;
            self.rightImageView.frame = tempRight;
            
            CGRect tempBG = bgRect;
            tempBG.origin.x += (rightRect.origin.x - bgRect.origin.x) * xDistanceRatio;
            self.rightBGImageView.frame = tempBG;
        }

        if (location.x > 0)
        {
            self.midImageView.layer.zPosition = midZPosition - 2 * xDistanceRatio;
            self.rightImageView.layer.zPosition = rightZPosition - 2 * xDistanceRatio;
            self.leftImageView.layer.zPosition = leftZPosition + 2 * xDistanceRatio;
            self.leftBGImageView.layer.zPosition = bgZPosition + 2 * xDistanceRatio;
            
            self.rightImageView.alpha = 1 - xDistanceRatio;
            self.midImageView.alpha = 1 - 0.3 * xDistanceRatio;
            self.leftImageView.alpha = 0.7 + 0.3 * xDistanceRatio;
            self.leftBGImageView.alpha = 0.7 * xDistanceRatio;
            
            CGRect temRight = rightRect;
            temRight.origin.x += (bgRect.origin.x - rightRect.origin.x) * xDistanceRatio;
            self.rightImageView.frame = temRight;
            
            CGRect tempLeft = leftRect;
            tempLeft.origin.x += (midRect.origin.x - leftRect.origin.x) * xDistanceRatio;
            tempLeft.origin.y -= offsetY / 2 * xDistanceRatio;
            tempLeft.size.width += offsetX * xDistanceRatio;
            tempLeft.size.height += offsetY * xDistanceRatio;
            self.leftImageView.frame = tempLeft;
            
            CGRect tempBG = bgRect;
            tempBG.origin.x += (leftRect.origin.x - bgRect.origin.x) * xDistanceRatio;
            self.leftBGImageView.frame = tempBG;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded)
    {
        if (location.x < (leftRect.origin.x - midRect.origin.x) / 2)
        {
            [self swipeLeft:nil];
        }
        else if (location.x > (rightRect.origin.x - midRect.origin.x) / 2)
        {
            [self swipeRight:nil];
        }
        else
        {
            __weak typeof(self)weakSelf = self;
            [UIView animateWithDuration:ANIMATIONDURATION animations:^{
                weakSelf.midImageView.frame = midRect;
                weakSelf.leftImageView.frame = leftRect;
                weakSelf.leftBGImageView.frame = bgRect;
                weakSelf.rightImageView.frame = rightRect;
                weakSelf.rightBGImageView.frame = bgRect;
                
                weakSelf.midImageView.alpha = 1;
                weakSelf.leftImageView.alpha = 0.7;
                weakSelf.rightImageView.alpha = 0.7;
                weakSelf.leftBGImageView.alpha = 0;
                weakSelf.rightBGImageView.alpha = 0;
                
                weakSelf.midImageView.layer.zPosition = midZPosition;
                weakSelf.leftImageView.layer.zPosition = leftZPosition;
                weakSelf.leftBGImageView.layer.zPosition = bgZPosition;
                weakSelf.rightImageView.layer.zPosition = rightZPosition;
                weakSelf.rightBGImageView.layer.zPosition = bgZPosition;
            }completion:^(BOOL finished) {
                [weakSelf startCarousel];
            }];
        }
    }
}


-(void)tapMidImageView:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击中间跳转到%zd",self.currentIndex);
    LB3DBannerImageView *view = (LB3DBannerImageView *)tap.view;
//    NSLog(@"%@",view.imageURL);
    
    if ([self.delegate respondsToSelector:@selector(didTapTheMidImageView:)])
    {
        [self.delegate didTapTheMidImageView:self];
    }
}

-(void)tapLeftImageView:(UITapGestureRecognizer *)tap
{
    NSLog(@"左边点击");
    UserOperating = YES;
    [self scrollToDirection:SwipeRight];
}

-(void)tapRightImageView:(UITapGestureRecognizer *)tap
{
    NSLog(@"右边点击");
    UserOperating = YES;
    [self scrollToDirection:SwipeLeft];
}

-(void)swipeLeft:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"左滑");
    UserOperating = YES;
    [self scrollToDirection:SwipeLeft];
}

-(void)swipeRight:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"右滑");
    UserOperating = YES;
    [self scrollToDirection:SwipeRight];
}

#pragma mark - 动画与数据切换
-(void)scrollToDirection:(SwipeDirection)swipeDirection
{
    switch (swipeDirection)
    {
        case SwipeRight:
        {
            self.currentIndex -= 1;
            if (self.currentIndex == -1)
            {
                self.currentIndex = self.imageURLArr.count - 1;
            }
            if (self.currentIndex - 2 == -1)
            {
                self.rightBGImageView.imageURL = self.imageURLArr[self.imageURLArr.count - 1];
            }
            else if (self.currentIndex - 2 == -2)
            {
                self.rightBGImageView.imageURL = self.imageURLArr[self.imageURLArr.count - 2];
            }
            else
            {
                self.rightBGImageView.imageURL = self.imageURLArr[self.currentIndex - 2];
            }
            __weak typeof(self)weakSelf = self;
            [UIView animateWithDuration:ANIMATIONDURATION animations:^{
                [weakSelf moveTowardRight:weakSelf];
            } completion:^(BOOL finished) {
                UserOperating = NO;
                
                ///拖动手势结束后重置
                if (weakSelf.timer == nil)
                {
                    [weakSelf startCarousel];
                }
            }];
        }
            break;
            
        case SwipeLeft:
        {
            self.currentIndex += 1;
            if (self.currentIndex == self.imageURLArr.count)
            {
                self.currentIndex = 0;
            }
            if (self.currentIndex + 2 == self.imageURLArr.count + 1)
            {
                self.rightBGImageView.imageURL = self.imageURLArr[0];
            }
            else if (self.currentIndex + 2 == self.imageURLArr.count + 2)
            {
                self.rightBGImageView.imageURL = self.imageURLArr[1];
            }
            else
            {
                self.rightBGImageView.imageURL = self.imageURLArr[self.currentIndex + 1];
            }
//            NSLog(@"%zd",self.currentIndex);
//            NSLog(@"%@",self.rightBGImageView.imageURL);
            __weak typeof(self)weakSelf = self;
            [UIView animateWithDuration:ANIMATIONDURATION animations:^{
                [weakSelf moveTowardLeft:weakSelf];
            } completion:^(BOOL finished) {
                UserOperating = NO;
                
                ///拖动手势结束后重置
                if (weakSelf.timer == nil)
                {
                    [weakSelf startCarousel];
                }
            }];
            break;
        }
        default:
            break;
    }
}

-(void)moveTowardLeft:(LB3DBannerView *)view
{
    view.leftImageView.frame = bgRect;
    view.midImageView.frame = leftRect;
    view.rightImageView.frame = midRect;
    view.rightBGImageView.frame = rightRect;
    
    view.rightImageView.layer.zPosition = midZPosition;
    view.leftImageView.layer.zPosition = bgZPosition;
    view.rightBGImageView.layer.zPosition = rightZPosition;
    view.midImageView.layer.zPosition = leftZPosition;
    
    [view.midImageView removeGestureRecognizer:view.midTap];
    [view.midImageView removeGestureRecognizer:view.midPan];
    [view.midImageView removeGestureRecognizer:view.leftSwipe];
    [view.midImageView removeGestureRecognizer:view.rightSwipe];
    [view.rightImageView removeGestureRecognizer:view.rightTap];
    [view.leftImageView removeGestureRecognizer:view.leftTap];
    
    LB3DBannerImageView *temp = view.leftImageView;
    view.leftImageView = view.midImageView;
    view.midImageView = view.rightImageView;
    view.rightImageView = view.rightBGImageView;
    view.rightBGImageView = view.leftBGImageView;
    view.leftBGImageView = temp;
    
    view.leftImageView.alpha = 0.7;
    view.midImageView.alpha = 1;
    view.rightImageView.alpha = 0.7;
    view.leftBGImageView.alpha = 0;
    view.rightBGImageView.alpha = 0;
    
    [view.midImageView addGestureRecognizer:view.rightSwipe];
    [view.midImageView addGestureRecognizer:view.midPan];
    [view.rightImageView addGestureRecognizer:view.rightTap];
    [view.leftImageView addGestureRecognizer:view.leftTap];
    [view.midImageView addGestureRecognizer:view.midTap];
    [view.midImageView addGestureRecognizer:view.leftSwipe];
}

-(void)moveTowardRight:(LB3DBannerView *)view
{
    view.midImageView.frame = rightRect;
    view.rightImageView.frame = bgRect;
    view.leftBGImageView.frame = leftRect;
    view.leftImageView.frame = midRect;
    
    view.rightImageView.layer.zPosition = bgZPosition;
    view.rightBGImageView.layer.zPosition = rightZPosition;
    view.leftImageView.layer.zPosition = midZPosition;
    view.midImageView.layer.zPosition = leftZPosition;
    
    [view.midImageView removeGestureRecognizer:view.midTap];
    [view.midImageView removeGestureRecognizer:view.midPan];
    [view.midImageView removeGestureRecognizer:view.leftSwipe];
    [view.midImageView removeGestureRecognizer:view.rightSwipe];
    [view.rightImageView removeGestureRecognizer:view.rightTap];
    [view.leftImageView removeGestureRecognizer:view.leftTap];
    
    LB3DBannerImageView *temp = view.leftImageView;
    view.leftImageView = view.leftBGImageView;
    view.leftBGImageView = view.rightBGImageView;
    view.rightBGImageView = view.rightImageView;
    view.rightImageView = view.midImageView;
    view.midImageView = temp;
    
    view.leftImageView.alpha = 0.7;
    view.midImageView.alpha = 1;
    view.rightImageView.alpha = 0.7;
    view.leftBGImageView.alpha = 0;
    view.rightBGImageView.alpha = 0;
    
    [view.midImageView addGestureRecognizer:view.rightSwipe];
    [view.midImageView addGestureRecognizer:view.midPan];
    [view.rightImageView addGestureRecognizer:view.rightTap];
    [view.leftImageView addGestureRecognizer:view.leftTap];
    [view.midImageView addGestureRecognizer:view.midTap];
    [view.midImageView addGestureRecognizer:view.leftSwipe];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 解决点击中间视图响应侧视图的BUG
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self.midImageView pointInside:[self.midImageView convertPoint:point fromView:self] withEvent:event])
    {
        return self.midImageView;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - 轮播
-(void)startCarousel
{
    [self stopCarousel];
    self.carouselStarted = YES;
    if (self.imageURLArr)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopCarousel
{
    self.carouselStarted = NO;
    [self.timer invalidate];
    self.timer = nil;
}

-(void)automaticScroll
{
    if (UserOperating)
    {
        return;
    }
    [self scrollToDirection:SwipeLeft];
}

#pragma mark - setter
-(void)setImageURLArr:(NSArray *)imageURLArr
{
    if (imageURLArr == nil)
    {
        return;
    }
    _imageURLArr = imageURLArr.copy;
    
    if (self.imageURLArr.count > 0) {
        self.midImageView.imageURL = self.imageURLArr[0];
    }
    if (self.imageURLArr.count > 1) {
        self.leftImageView.imageURL = self.imageURLArr[self.imageURLArr.count - 1];
        self.rightImageView.imageURL = self.imageURLArr[1];
    }
    if (self.imageURLArr.count > 2) {
        self.leftBGImageView.imageURL = self.imageURLArr[self.imageURLArr.count - 2];
        self.rightBGImageView.imageURL = self.imageURLArr[2];
    }
    
    if (self.isAutoCarousel)
    {
        [self startCarousel];
    }
}

-(void)setIsAutoCarousel:(BOOL)isAutoCarousel
{
    _isAutoCarousel = isAutoCarousel;
    
    if (self.imageURLArr == nil)
    {
        return;
    }
    
    if (isAutoCarousel)
    {
        [self startCarousel];
    }
    else
    {
        [self stopCarousel];
    }
}

-(void)setIsOffline:(BOOL)isOffline
{
    _isOffline = isOffline;
    
    self.midImageView.isOffline = isOffline;
    self.leftImageView.isOffline = isOffline;
    self.rightImageView.isOffline = isOffline;
    self.leftBGImageView.isOffline = isOffline;
    self.rightBGImageView.isOffline = isOffline;
}
@end
