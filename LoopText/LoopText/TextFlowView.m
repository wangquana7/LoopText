//
//  TextFlowView.m
//  mylooptext
//
//  Created by zhangju on 16/6/15.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "TextFlowView.h"
static const CGFloat SPACE_WIDTH = 50.0;
static const NSTimeInterval LOOP_PERIOD = 0.02;

@interface TextFlowView ()

@property (nonatomic, copy) dispatch_source_t loopTimer;//!<滚动事件定时器
@property (nonatomic, assign, getter=isNeedFlow) BOOL needFlow;
//@property (nonatomic, assign) NSUInteger startIndex;
@property (nonatomic, assign) CGFloat x_offset;//!<定时器每次执行偏移后，累计的偏移量之和
@property (nonatomic, assign) CGSize textSize;//!<文本显示一行，需要的框架大小
@end

@implementation TextFlowView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//改变一个TRect的起始点位置，但是其终止店点的位置不变，因此会导致整个框架大小的变化
- (CGRect)moveNewPoint:(CGPoint)point rect:(CGRect)rect
{
    CGSize tmpSize;
    tmpSize.height = rect.size.height + (rect.origin.y - point.y);
    tmpSize.width = rect.size.width + (rect.origin.x - point.x);
    return CGRectMake(point.x, point.y, tmpSize.width, tmpSize.height);
}
//开启定时器
- (void)startRun
{
    NSTimeInterval period = LOOP_PERIOD; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _loopTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_loopTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_loopTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self timerAction];
        });
    });
    
    dispatch_resume(_loopTimer);
}

//关闭定时器
- (void)cancelRun
{
    if(_loopTimer){
        dispatch_source_cancel(_loopTimer);
        _loopTimer = nil;
    }
}

//定时器执行的操作
- (void)timerAction
{
    static CGFloat offsetOnce = -1;
    _x_offset += offsetOnce;
    if (_x_offset +  _textSize.width <= 0)
    {
        _x_offset += _textSize.width;
        _x_offset += SPACE_WIDTH;
    }
    [self setNeedsDisplay];
}

//计算在给定字体下，文本仅显示一行需要的框架大小
- (CGSize)computeTextSize:(NSString *)text
{
    if (text == nil) 
    {
        return CGSizeMake(0, 0);
    }
    CGSize boundSize = CGSizeMake(10000, 100);
    CGSize stringSize = [self.text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil ].size;
    return stringSize;
}


- (instancetype)initWithFrame:(CGRect)frame Text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.text = text ;
        self.frame = frame;
        //默认的字体大小
        self.font = [UIFont systemFontOfSize:16.0F];
        self.backgroundColor = [UIColor grayColor];
        self.lineBreakMode = NSLineBreakByCharWrapping;
        //初始化标签
        //判断是否需要滚动效果
        _textSize = [self computeTextSize:text];
        //需要滚动效果
        if (_textSize.width > frame.size.width) 
        {
            _needFlow = YES;
            [self startRun];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRun) name:UIApplicationWillEnterForegroundNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRun) name:UIApplicationDidEnterBackgroundNotification object:nil];
        }
        
    }
    return self;
}
- (void)drawTextInRect:(CGRect)rect{
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    // Drawing code
    CGFloat startYOffset = 0;// (rect.size.height - _textSize.height)/2 ;
    CGPoint origin = rect.origin;
    if (_needFlow == YES)
    {
        rect = [self moveNewPoint:CGPointMake(_x_offset, startYOffset) rect:rect];
        while (rect.origin.x <= rect.size.width+rect.origin.x)
        {
            [super drawTextInRect:rect];
            rect = [self moveNewPoint:CGPointMake(rect.origin.x+_textSize.width+SPACE_WIDTH, rect.origin.y) rect:rect];
        }
    }
    else
    {
        //在控件的中间绘制文本
        origin.x = (rect.size.width - _textSize.width)/2;
        origin.y = (rect.size.height - _textSize.height)/2;
        rect.origin = origin;
        [super drawTextInRect:rect];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.



@end
