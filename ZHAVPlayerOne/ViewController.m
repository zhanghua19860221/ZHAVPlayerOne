//
//  ViewController.m
//  ZHAVPlayerOne
//
//  Created by zhanghua0221 on 17/1/12.
//  Copyright © 2017年 zhanghua0221. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController
{
    ZHAVPlayer *videoView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)createView{
    
    for (int x=0; x<2 ; x++ ) {
        
        videoView = [[ZHAVPlayer alloc]initWithFrame:CGRectMake(x*SC_WIDTH/2.0, 200, SC_WIDTH/2.0, 249) urlString:@"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4"];
        videoView.tag = 300+x;
        videoView.delegate = self;
        [self.view addSubview:videoView];
        
    }
}
-(void)changeMaxView:(UIView*)SF{
    [self.view bringSubviewToFront:SF];
    
    self.navigationController.navigationBarHidden = YES;
}
-(void)changeMinView:(UIView*)SF{
    
    self.navigationController.navigationBarHidden = NO;
}
-(void)isCurrentView:(UIView*)SF{
    
    if (self.currentPlayerView == nil) {
        self.currentPlayerView = (ZHAVPlayer*)SF;
        
    }else if(self.currentPlayerView.tag == SF.tag){
        
        NSLog(@"%ld",(long)self.currentPlayerView.tag);
        
    }else{
        
        [self.currentPlayerView.myPlayer pause];
        self.currentPlayerView.playButton.selected = NO;
        self.currentPlayerView.playButton.alpha = 1 ;
        self.currentPlayerView = (ZHAVPlayer*)SF;
        return;
    }
    
}

//-(void)playAction{

//    FirstViewController *root = [[FirstViewController alloc]init];
//    [self.navigationController  pushViewController:root animated:YES];

//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [videoView.myPlayer pause];
}
@end
