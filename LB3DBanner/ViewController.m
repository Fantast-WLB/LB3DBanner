//
//  ViewController.m
//  LB3DBanner
//
//  Created by 吴龙波 on 2017/2/15.
//  Copyright © 2017年 吴龙波. All rights reserved.
//

#import "ViewController.h"
#import "LB3DBannerView.h"
@interface ViewController ()<LB3DBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LB3DBannerView *view = [[LB3DBannerView alloc]initWithFrame:CGRectMake(40, 40, 280,400) andImageURLArray:@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487240041469&di=d44bad880daebe63d05956a98515dc64&imgtype=jpg&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D1199672924%2C1879436334%26fm%3D214%26gp%3D0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487240066179&di=107bb41b6b64628a1e61dea3d1d2f717&imgtype=jpg&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D705536584%2C2440543459%26fm%3D214%26gp%3D0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487240041049&di=7bc831ec6a066bdc7c9dfa506c2ddd37&imgtype=0&src=http%3A%2F%2Fm.c.lnkd.licdn.com%2Fmpr%2Fmpr%2Fshrinknp_400_400%2Fp%2F2%2F000%2F006%2F104%2F0cc2646.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487240041049&di=24caeaf54703f2fb7bbdc9981cbafd93&imgtype=0&src=http%3A%2F%2Fimg2-ak.lst.fm%2Fi%2Fu%2Favatar170s%2F5788f607aa164041c086630dd6dcee37.png",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487240132608&di=897274e55b05f3579aa2ef382b44599e&imgtype=jpg&src=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D1680871507%2C1191018650%26fm%3D214%26gp%3D0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487240041049&di=42be2afc7154ca000a6a6813b1e3a095&imgtype=0&src=http%3A%2F%2Fcdn.aixifan.com%2Fdotnet%2Fartemis%2Fu%2Fcms%2Fwww%2F201506%2F09195920qex0.jpg"]];
    
    [self.view addSubview:view];
    view.delegate = self;
    view.isAutoCarousel = YES;
}

-(void)didTapTheMidImageView:(id)object
{
//    NSLog(@"点击中间--代理");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
