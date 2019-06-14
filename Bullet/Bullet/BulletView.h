







#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//弹幕的状态
typedef NS_ENUM(NSInteger,BulletMoveStatus){
    BulletMoveStatusStart,      //即将进入屏幕
    BulletMoveStatusEnter,      //已经进入屏幕
    BulletMoveStatusEnd         //全部滚出屏幕
};


typedef void(^MoveStatusBlock)(BulletMoveStatus status);

@interface BulletView : UIView

/** 弹道 */
@property (nonatomic, assign) NSInteger trajectory;
/** 弹幕状态回调 */
@property (nonatomic, copy) MoveStatusBlock moveStatus;

-(instancetype)initWithBulletText:(NSString *)text;
    
//开始动画
-(void)startAnimation;
    
//结束动画
-(void)stopAnimation;
    
@end

NS_ASSUME_NONNULL_END
