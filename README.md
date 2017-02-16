# LB3DBanner
A 3D BannerView support tap and swipe gesture.

# Usage
Here is how you can use it:

    ///yourImageArray can be array of URLs or imagenames
    LB3DBannerView *view = [[LB3DBannerView alloc]initWithFrame:CGRectMake(40, 40, 280,400) andImageURLArray:yourImageArray];
    [self.view addSubview:view];
    view.delegate = self;
    //view.isAutoCarousel = YES;
    //view.isOffline = YES;

# LB3DBannerViewDelegate
        
        -(void)didTapTheMidImageView:(id)object
        {
            NSLog(@"点击中间--代理");
        }

        
# AutoCarousel

        ///default is NO
        @property(nonatomic,assign)BOOL isAutoCarousel;
        -(void)starCarousel;
        -(void)stopCarousel;
        
        
# Effect Picture
![image](https://github.com/Fantast-WLB/LB3DBanner/blob/master/LB3DBanner/ezgif.com-video-to-gif.gif)

