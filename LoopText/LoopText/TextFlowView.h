//
//  TextFlowView.h
//  mylooptext
//
//  Created by zhangju on 16/6/15.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFlowView : UILabel {
    
    //定时器
    NSTimer *_timer;
    
    
    //是否需要滚动
    BOOL _needFlow;
    
    
    //当前第一个控件的索引
    NSInteger _startIndex;
    
    //定时器每次执行偏移后，累计的偏移量之和
    CGFloat _XOffset;
    
    //文本显示一行，需要的框架大小
    CGSize _textSize;
}

- (id)initWithFrame:(CGRect)frame Text:(NSString *)text;
@end
