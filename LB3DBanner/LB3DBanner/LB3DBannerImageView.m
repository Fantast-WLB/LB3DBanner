//
//  LB3DBannerImageView.m
//  LB3DBanner
//
//  Created by 吴龙波 on 2017/2/16.
//  Copyright © 2017年 吴龙波. All rights reserved.
//

#import "LB3DBannerImageView.h"
#import <UIImageView+WebCache.h>

@interface LB3DBannerImageView ()

@property(nonatomic,strong)CALayer *imageLayer;

@end

@implementation LB3DBannerImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 15;
        self.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00].CGColor;
        self.layer.borderWidth = 0.1f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    
    [self sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}

-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    self.image = [UIImage imageNamed:imageName];
}

-(void)setImage:(UIImage *)image
{
    if (self.imageLayer)
    {
        [self.imageLayer removeFromSuperlayer];
        self.imageLayer = nil;
    }
    self.imageLayer = [CALayer layer];
    self.imageLayer.frame = self.bounds;
    self.imageLayer.cornerRadius = 20.0;
    self.imageLayer.contents = (id)image.CGImage;
    self.imageLayer.masksToBounds=YES;
    [self.layer addSublayer:self.imageLayer];
}

-(void)setFrame:(CGRect)frame
{
    self.imageLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    [super setFrame:frame];
}
@end
