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

///从xid、storyboard创建需要手动给图片
@property(nonatomic,strong)NSArray *imageURLArr;
///在线或离线图片
@property(nonatomic,assign)BOOL isOffline;
///代码创建
-(instancetype)initWithFrame:(CGRect)frame andImageURLArray:(NSArray *)imageURLArr;

/********* 轮播 *********/
@property(nonatomic,assign)BOOL isAutoCarousel;
-(void)starCarousel;
-(void)stopCarousel;

@end
