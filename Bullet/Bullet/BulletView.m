







#import "BulletView.h"

#define KMargin 10
#define KBulletHeight 30
#define KDuration 4.0f //弹幕的滚动时间
#define KScreenW [UIScreen mainScreen].bounds.size.width

@interface BulletView()

/** 弹幕头像 */
@property (nonatomic, strong) UIImageView *headImgView;
/** 弹幕内容 */
@property (nonatomic, strong) UILabel *bulletLabel;

@end

@implementation BulletView
    
-(instancetype)initWithBulletText:(NSString *)text{
    if (self = [super init]) {
        
        self.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.5];
        
        //计算弹幕的实际宽度
        CGFloat textWidth = [text sizeWithAttributes:@{NSFontAttributeName:self.bulletLabel.font}].width;
        
        self.bounds = CGRectMake(0, 0, textWidth + KMargin*2 + self.headImgView.bounds.size.width, KBulletHeight);
        //切圆角
        self.layer.cornerRadius = KBulletHeight*0.5;
        self.layer.masksToBounds = YES;
        
        //添加头像
        [self addSubview:self.headImgView];
        //添加弹幕内容
        [self addSubview:_bulletLabel];
        
        self.bulletLabel.text = text;
        self.bulletLabel.frame = CGRectMake(CGRectGetMaxY(self.headImgView.frame)+KMargin, 0, textWidth, self.bounds.size.height);
    }
    return self;
}

//开始动画
-(void)startAnimation{
    
    //弹幕要走的距离
    CGFloat wholeWidth = KScreenW + CGRectGetWidth(self.bounds);
    
    //弹幕开始
    if (self.moveStatus) {
        self.moveStatus(BulletMoveStatusStart);
    }
    
    //弹幕的速度
    CGFloat speed = wholeWidth / KDuration;
    //弹幕的进入时间
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    
    //进入屏幕
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:KDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        //弹幕结束回调
        if (self.moveStatus) {
            self.moveStatus(BulletMoveStatusEnd);
        }
    }];
    
    
}
    
//结束动画
-(void)stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

//进入屏幕状态
-(void)enterScreen{
    if (self.moveStatus) {
        self.moveStatus(BulletMoveStatusEnter);
    }
}
    
-(UILabel *)bulletLabel{
    if (_bulletLabel == nil) {
        _bulletLabel = [[UILabel alloc] init];
        _bulletLabel.font = [UIFont systemFontOfSize:14];
        _bulletLabel.textColor = [UIColor whiteColor];
        _bulletLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bulletLabel;
}

-(UIImageView *)headImgView{
    if (_headImgView == nil) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.frame = CGRectMake(0, 0, KBulletHeight, KBulletHeight);
        _headImgView.layer.cornerRadius = KBulletHeight*0.5;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.backgroundColor = [UIColor redColor];
    }
    return _headImgView;
}

@end
