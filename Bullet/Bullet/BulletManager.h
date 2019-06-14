







#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BulletView;

typedef void(^BulletViewBlock)(BulletView *view);

@interface BulletManager : NSObject

/** 创建弹幕view回调 */
@property (nonatomic, copy) BulletViewBlock bulletViewBlock;
/** 弹幕的数据源 */
@property (nonatomic, strong) NSArray *dataSource;

/**
 初始化方法
 @param superView 弹幕要添加在哪个view上
 @param dataSource 弹幕数据源
 @return BulletManager
 */
+(instancetype)bulletManagerInView:(UIView *)superView dataSource:(NSArray *)dataSource;
-(instancetype)initWithSuperView:(UIView *)superView dataSource:(NSArray *)dataSource;

//开启弹幕
-(void)start;

//停止弹幕
-(void)stop;
    
    
@end

NS_ASSUME_NONNULL_END
