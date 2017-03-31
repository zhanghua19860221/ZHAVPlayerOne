//
//  ZHAVPlayer.h
//  ZHAVPlayerOne
//
//  Created by zhanghua0221 on 17/1/12.
//  Copyright © 2017年 zhanghua0221. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZHAVPlayerDelegate <NSObject>

-(void)changeMaxView:(UIView*)self;
-(void)changeMinView:(UIView*)self;
-(void)isCurrentView:(UIView*)self;
@end

@interface ZHAVPlayer : UIView

@property (strong, nonatomic) NSString *urlName;//视频地址
@property (strong, nonatomic) AVPlayer *myPlayer;//播放器
@property (strong, nonatomic) AVPlayerItem *myPlayerItem;//播放单元
@property (strong, nonatomic) AVPlayerLayer *myPlayerLayer;//播放界面（layer）
@property (strong, nonatomic) UIButton *playButton;//控制视频播放按钮
@property (strong, nonatomic) UIButton *fullButton;//视频全屏播放按钮
@property (strong, nonatomic) UILabel *currentTimeLable;//视频当前播放时间
@property (strong, nonatomic) UILabel *allTimeLable;//视频总时长
@property (strong, nonatomic) UISlider *avSlider; //进度条
@property (strong, nonatomic) UIView *allBarView; //进度条 当前时间 总时间 全屏按钮父视图
@property (assign, nonatomic) CGRect rect;//记录窗口矩形大小

@property (assign, nonatomic) BOOL  isPlayer;// 视频是否播放
@property (assign, nonatomic) BOOL  isClickScreen;//是否点击屏幕
@property (assign, nonatomic) BOOL  isFirst ;//判断是否是第一次点击播放按钮
@property (assign, nonatomic) BOOL  isFirstButton;//判断是否是第一次点击播放按钮
@property (assign, nonatomic) BOOL  isSliderDown;//判断进度条是否按下

@property (strong ,nonatomic) id<ZHAVPlayerDelegate>delegate ;

-(instancetype)initWithFrame:(CGRect)frame urlString:(NSString*)url;
@end
