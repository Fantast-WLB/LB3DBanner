//
//  LB3DBannerView.h
//  LB3DBanner
//
//  Created by 吴龙波 on 2017/2/15.
//  Copyright © 2017年 吴龙波. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LB3DBannerViewDelegate <NSObject>

-(void)didTapTheMidImageView:(id)object;

@end

@interface LB3DBannerView : UIView

@property(nonatomic,weak)id<LB3DBannerViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame andImageURLArray:(NSArray *)imageURLArr;

@end
