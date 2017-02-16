//
//  LB3DBannerImageView.h
//  LB3DBanner
//
//  Created by 吴龙波 on 2017/2/16.
//  Copyright © 2017年 吴龙波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LB3DBannerImageView : UIImageView
///如果要加载本地图片则直接传图片名
@property(nonatomic,copy)NSString *imageURL;
///如果要加载本地图片更改此属性
@property(nonatomic,assign)BOOL isOffline;

@end
