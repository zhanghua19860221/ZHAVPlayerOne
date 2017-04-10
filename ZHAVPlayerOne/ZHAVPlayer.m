//
//  ZHAVPlayer.m
//  ZHAVPlayerOne
//
//  Created by zhanghua0221 on 17/1/12.
//  Copyright © 2017年 zhanghua0221. All rights reserved.
//

#import "ZHAVPlayer.h"

#define F_WIDTH   self.frame.size.width
#define F_HEIGHT  self.frame.size.height

@implementation ZHAVPlayer

-(instancetype)initWithFrame:(CGRect)frame urlString:(NSString*)url{
    self = [super initWithFrame:frame];
    if (self) {
        self.urlName = url ;
        self.isPlayer = NO ;
        self.isClickScreen = NO;
        self.isFirst = YES ;
        self.isFirstButton = NO ;
        [self creatVideo];
        [self creatUI];
        [self creatFrame];
        self.rect = frame;
    }
    return self;
}
-(void)creatVideo{

    NSURL *url = [NSURL URLWithString:self.urlName];
    self.myPlayerItem = [AVPlayerItem playerItemWithURL:url];
    self.myPlayer = [AVPlayer playerWithPlayerItem:self.myPlayerItem];
    self.myPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.myPlayerLayer.frame = CGRectMake(0,0,F_WIDTH, F_HEIGHT);
    [self.layer addSublayer:self.myPlayerLayer];
    
    //将视频与Layer层 自动适配填充
    self.myPlayerLayer.videoGravity = AVLayerVideoGravityResize;
    
    //以上是基本的播放界面但是没有前进ssss后退
    //观察是否播放  KVO进行观察 playerItem.status属性
    [self.myPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)creatUI{
    
    //创建播放按钮
    self.playButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"Player_Stop@2x.png"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    
    //创建工具条父视图
    self.allBarView = [[UIView alloc]init];
    self.allBarView.backgroundColor = COLORFromRGB(0x2F2F4F);
    self.allBarView.hidden = YES ;
    [self addSubview:self.allBarView];
    
    //创建当前时间Lable
    self.currentTimeLable = [[UILabel alloc]init];
    self.currentTimeLable.textColor = [UIColor whiteColor];
    [self.currentTimeLable setTextAlignment:NSTextAlignmentCenter];
    [self.allBarView addSubview:self.currentTimeLable];
    
    //创建视频总时间Lable
    self.allTimeLable = [[UILabel alloc]init];
    self.allTimeLable.textColor = [UIColor whiteColor];
    [self.allTimeLable setTextAlignment:NSTextAlignmentCenter];
    [self.allBarView addSubview:self.allTimeLable];

    //创建进度条
    self.avSlider = [[UISlider alloc]init];
    [self.avSlider setThumbImage:[UIImage imageNamed:@"MoviePlayer_Slider@2x.png"
                                  ] forState:UIControlStateNormal];
    [self.allBarView addSubview:self.avSlider];
    
    //进度条按下
    [self.avSlider addTarget:self action:@selector(avSliderDown) forControlEvents:UIControlEventTouchDown];
    //进度条抬起
    [self.avSlider addTarget:self action:@selector(avSliderUp) forControlEvents:UIControlEventTouchUpInside];
    
    //创建全屏按钮
    self.fullButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.fullButton setImage:[UIImage imageNamed:@"Player_max@2x.png"] forState:UIControlStateNormal];
    [self.fullButton addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    [self.allBarView addSubview:self.fullButton];
}
//进度条抬起时
-(void)avSliderUp{
    
    self.isSliderDown = NO ;
    //slider的value值为视频的时间
    float seconds =self.avSlider.value;
    //让视频从指定的CMTime对象处播放.
    CMTime startTime = CMTimeMakeWithSeconds(seconds,self.myPlayerItem.currentTime.timescale);
    //让视频从指定处播放
    [self.myPlayer seekToTime:startTime completionHandler:^(BOOL finished) {
        
        if(finished) {
            
            if (self.playButton.selected&&self.isPlayer){
                
                [self.myPlayer play];
            }else{
                
                [self.myPlayer pause];
            }
        }
    }];
    
}
//进度条按下时
-(void)avSliderDown{
    
    self.isSliderDown = YES ;
}
-(void)fullScreenAction{
    
    self.fullButton.selected = !self.fullButton.selected;
    if (self.fullButton.selected) {
    
        self.frame = [UIScreen mainScreen].bounds;
        [self.delegate changeMaxView:self];
        
    }else{
        self.frame = self.rect;
        [self.delegate changeMinView:self];
    }
    [self creatFrame];
}
-(void)creatFrame{
    
    self.myPlayerLayer.frame=CGRectMake(0,0,F_WIDTH,F_HEIGHT);
    self.allBarView.frame=CGRectMake(0, F_HEIGHT-39, F_WIDTH, 39);
    self.playButton.frame = CGRectMake(F_WIDTH/2.0-20, F_HEIGHT/2.0-20,40, 40);
    self.currentTimeLable.frame = CGRectMake(0,0,60,39);
    self.allTimeLable.frame = CGRectMake(F_WIDTH-120,0,60,39);
    self.avSlider.frame= CGRectMake(60,0, F_WIDTH-180,39);
    self.fullButton.frame = CGRectMake(F_WIDTH-50, 0,40, 39);
    
}
-(void)playAction:(UIButton*)btn {
    
    if (self.isPlayer && !self.playButton.selected) {
        [self.myPlayer play];
        
        [self.playButton setImage:[UIImage imageNamed:@"Player_Play@2x.png"] forState:UIControlStateSelected];
        
            self.playButton.alpha  =   0;
            self.allBarView.hidden =  NO;
    }else{
        
        [self.myPlayer pause];
    }
    self.isFirstButton = YES ;
    self.playButton.selected = !self.playButton.selected;
    [self.delegate isCurrentView:self];

//    [self removeFromSuperview];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //取出status的新值
    AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
    switch(status)
    {
        case AVPlayerItemStatusFailed:
            
            NSLog(@"视频item有错误 有误");
            break;
        case AVPlayerItemStatusReadyToPlay:
            
            NSLog(@"准好播放了");
            self.isPlayer = YES;
            self.avSlider.maximumValue=self.myPlayerItem.duration.value/self.myPlayerItem.duration.timescale;
            [self getVideoData];
            break;
        case AVPlayerItemStatusUnknown:
            
            NSLog(@"视频资源出现未知错误");
            break;
        default:
            break;
    }
}
-(void)getVideoData{
    
    __weak AVPlayerItem*tempItem = self.myPlayerItem;
    __weak UISlider*tempSilder = self.avSlider;
    __weak typeof(self)mySelf=self;
    
    //第一个参数是每隔多久，调用一次，在这里设置的是每隔一秒调用一次
    [self.myPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        //当前播放时间
        CGFloat current = self.myPlayerItem.currentTime.value/self.myPlayerItem.currentTime.timescale;
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:current];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"mm:ss"];
        NSString *currentTimeValue = [dateFormatter stringFromDate: detaildate];
        mySelf.currentTimeLable.text=currentTimeValue;

        //总时间长度
        CMTime time1 = tempItem.duration;
        float totalTime = CMTimeGetSeconds(time1);
        NSDate *detaildate1=[NSDate dateWithTimeIntervalSince1970:totalTime];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter1 setDateFormat:@"mm:ss"];
        NSString *allTimeValue = [dateFormatter1 stringFromDate: detaildate1];
        //总时间长度Label赋值
        mySelf.allTimeLable.text=allTimeValue;
        
        //设置滑动进度条
        float sliderValue = current;
        //是按下的话就不执行赋值代码，滚动条停在按下的位置
        if (!mySelf.isSliderDown) {
            
            tempSilder.value = sliderValue;
        }
    }];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    if (self.isFirstButton == YES) {
        
        self.isClickScreen = !self.isClickScreen;
        if (!self.isClickScreen) {
            
            self.playButton.alpha = 1 ;
            self.allBarView.hidden = NO ;
        }else{
            
            self.playButton.alpha = 0 ;
            self.allBarView.hidden = YES ;
        }
        
    }else{
        
        [self.myPlayer play];
        [self.playButton setImage:[UIImage imageNamed:@"Player_Play@2x.png"] forState:UIControlStateSelected];
        self.playButton.alpha  =   0;
        self.isFirstButton = YES ;
        self.isClickScreen = YES ;
        self.playButton.selected = !self.playButton.selected;
        [self.delegate isCurrentView:self];

        
    }
    
}
-(void)dealloc{
    //移除监听（观察者）
    //移除监听（观察者）

    [self.myPlayerItem  removeObserver:self forKeyPath:@"status"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
