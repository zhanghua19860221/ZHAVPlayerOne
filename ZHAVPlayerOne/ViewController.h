//
//  ViewController.h
//  ZHAVPlayerOne
//
//  Created by zhanghua0221 on 17/1/12.
//  Copyright © 2017年 zhanghua0221. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAVPlayer.h"
@interface ViewController : UIViewController<ZHAVPlayerDelegate>

@property(strong ,nonatomic)ZHAVPlayer *currentPlayerView;//记录当前View

@end

