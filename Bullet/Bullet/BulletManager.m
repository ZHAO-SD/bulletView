






#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager()


/** 保存使用中的弹幕内容 */
@property (nonatomic, strong) NSMutableArray *bulletComments;
    
/** 保存弹幕view的数组 */
@property (nonatomic, strong) NSMutableArray *bulletViews;
    
/** 记录动画状态 */
@property (nonatomic, assign) BOOL stopAnimation;

@end

@implementation BulletManager
    
-(instancetype)initWithSuperView:(UIView *)superView dataSource:(NSArray *)dataSource{
    if (self = [super init]) {
        self.stopAnimation = YES;
        self.dataSource = dataSource;
        __weak typeof(self) weakSelf = self;
        self.bulletViewBlock = ^(BulletView * _Nonnull view) {
            [weakSelf addBulletView:view superView:superView];
        };
    }
    return self;
}

+(instancetype)bulletManagerInView:(UIView *)superView dataSource:(NSArray *)dataSource{
    return [[BulletManager alloc] initWithSuperView:superView dataSource:dataSource];
}

#pragma mark - 私有方法 添加弹幕
-(void)addBulletView:(BulletView *)bulletView superView:(UIView *)superView{
    
    CGFloat width = superView.bounds.size.width;
    bulletView.frame = CGRectMake(width, bulletView.trajectory*40, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [superView addSubview:bulletView];
    [bulletView startAnimation];
}


#pragma mark - 开启弹幕
-(void)start{
    
    if (!self.stopAnimation) {
        return;
    }
    self.stopAnimation = NO;
    
    //清空数组
    [self.bulletComments removeAllObjects];
    //添加弹幕
    [self.bulletComments addObjectsFromArray:self.dataSource];
    
    //初始化弹幕
    [self initBulletComment];
}

#pragma mark - 关闭弹幕
-(void)stop{
    if (self.stopAnimation) {
        return;
    }
    self.stopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

//初始化弹幕
-(void)initBulletComment{
    //初始化弹道数组
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2),@(3)]];
    for (NSInteger i = 0; i < trajectorys.count; i++) {
        
        if (self.bulletComments.count > 0) {
            //通过随机数获取到弹道
            NSInteger index = arc4random() % trajectorys.count;
            NSInteger trajectory = [[trajectorys objectAtIndex:index] integerValue];
            
            //从弹幕数组中逐一取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            //取出后移除
            [self.bulletComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
        
    }
}
    
//创建弹幕view
-(void)createBulletView:(NSString *)comment trajectory:(NSInteger)trajectory{
    if (self.stopAnimation) {
        return;
    }
    
    
    BulletView *view = [[BulletView alloc] initWithBulletText:comment];
    view.trajectory = trajectory;
    //添加到数组
    [self.bulletViews addObject:view];
    
    __weak typeof (view) weakView = view;
    __weak typeof (self) weakSelf = self;
    view.moveStatus = ^(BulletMoveStatus status) {
        
        if (self.stopAnimation) {
            return ;
        }
        
        switch (status) {
            case BulletMoveStatusStart:{
                //弹幕开始进入屏幕,将view加入数组
                [weakSelf.bulletViews addObject:weakView];
                
                break;
            }
            case BulletMoveStatusEnter:{
                //弹幕完全进入屏幕,判断是否还有其他内容,如果有则在该弹幕弹道中创建弹幕
                NSString *commnet = [weakSelf nextComment];
                if (commnet) {
                    [weakSelf createBulletView:commnet trajectory:trajectory];
                }
                break;
            }
            case BulletMoveStatusEnd:{
                //弹幕飞出屏幕
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                if (weakSelf.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕了,开始循环滚动
                    weakSelf.stopAnimation = YES;
                    [weakSelf start];
                }
                break;
            }
            
            default:
            break;
        }
        
    };
    
    if (self.bulletViewBlock) {
        self.bulletViewBlock(view);
    }
}

//取下一条弹幕
-(NSString *)nextComment{
    if (self.bulletComments.count == 0) {
        return nil;
    }
    
    NSString *commnet = [self.bulletComments firstObject];
    if (commnet) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return commnet;
    
}
    

-(NSMutableArray *)bulletComments{
    if (_bulletComments == nil) {
        _bulletComments = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _bulletComments;
}
-(NSMutableArray *)bulletViews{
    if (_bulletViews == nil) {
        _bulletViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _bulletViews;
}
    
@end
