//
//  DemoViewController.m
//  gcdtest
//
//  Created by greatstar on 2018/3/10.
//  Copyright © 2018年 greatstar. All rights reserved.
//

//ignore selector unknown warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#import "DemoViewController.h"

@interface DemoViewController ()
- (IBAction)runBtnHandler:(id)sender;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark --------队列的三种获取方式----------

//串行队列
-(void)testSerialqueue{
    
    // 串行队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列（若为NULL时，默认是DISPATCH_QUEUE_SERIAL）
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    //主队列其实也是一种特殊的串行队列
    //主队列的获取方法
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
}

//并发队列
-(void)testConcurrentqueue{
    
    //并发队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列（若为NULL时，默认是DISPATCH_QUEUE_SERIAL）
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //系统提供了全局并发队列的直接获取方法:第一个参数表示队列优先级,我们选择默认的好了,第二个参数flags作为保留字段备用,一般都直接填0
    //全局并发队列的获取方法
    dispatch_queue_t mainqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

//主队列
-(void)testMainqueue{
    //主队列其实也是一种特殊的串行队列
    //主队列的获取方法
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
}


#pragma mark ---------任务的两种追加方式----------

//异步执行
-(void)testAsync{
    
    //获取一个队列，这里以并发队列作为例子
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行任务创建方法,这句代码的意思是以异步操作将任务添加到队列(queue)中执行
    dispatch_async(queue, ^{
        // 这里放异步执行任务代码
    });
}

//同步执行
-(void)testSync{
    
    //获取一个队列，这里以并发队列作为例子
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行任务创建方法,这句代码的意思是以同步操作将任务添加到队列(queue)中执行
    dispatch_sync(queue, ^{
        // 这里放同步执行任务代码
    });
}


#pragma mark ---------三种队列+两种执行方式组合起来的7种多线程常用使用姿势----------

//同步执行 and 并发队列
//总结：只会在当前线程中依次执行任务，不会开启新线程，执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)syncAndConcurrentqueue{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);
    
    //下面提供两种并发队列的获取方式，其运行结果无差别，所以归为了一类，你可以自由选择
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 全局并发队列
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 第一个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第二个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第三个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
    
}

//异步执行 and 并发队列
//总结：从log中可以发现,系统另外开启了3个线程，并且任务是同时执行的,并不是按照1>2>3顺序执行。所以异步+并发队列具备开启新线程的能力,且并发队列可开启多个线程，同时执行多个任务。
-(void)asyncAndConcurrentqueue{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);
    
    //下面提供两种并发队列的获取方式，其运行结果无差别，所以归为了一类，你可以自由选择
    
    //dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 第一个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第二个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第三个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
    
}

//同步执行 and 串行队列
//总结：只会在当前线程中依次执行任务，不会开启新线程，执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)syncAndSerialqueue{
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    // 第一个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第二个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第三个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
    
}

//异步执行 and 串行队列
//总结:开启了一条新线程，异步执行具备开启新线程的能力且只开启一个线程，在该线程中执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)asyncAndSerialqueue{
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    // 第一个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第二个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第三个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
    
}

//同步执行 and 主队列
//总结:直接crash。这是因为发生了死锁，在gcd中，禁止在主队列(串行队列)中再以同步操作执行主队列任务。同理，在同一个同步串行队列中，再使用该队列同步执行任务也是会发生死锁。
-(void)syncAndMainqueue{
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);
    
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 第一个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第二个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第三个任务
    dispatch_sync(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
    
    return;
    //下面的例子类似：
    dispatch_queue_t queue1 = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue1, ^{
        
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----11111-----当前线程%@",[NSThread currentThread]);//到这里就死锁了
        
        dispatch_sync(queue1, ^{
            
            [NSThread sleepForTimeInterval:2];
            
            NSLog(@"----22222---当前线程%@",[NSThread currentThread]);
        });
        
        NSLog(@"----333333-----当前线程%@",[NSThread currentThread]);
        
    });
    NSLog(@"----44444-----当前线程%@",[NSThread currentThread]);
    
}

//其它线程中(同步执行 and 主队列）
//总结：可以执行任务，所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）,在主线程中执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)othersyncAndMainqueue{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    // 第一个任务
    dispatch_async(queue, ^{
        
        NSLog(@"----执行任务---%@",[NSThread currentThread]);
        
        //获取主队列
        dispatch_queue_t queue = dispatch_get_main_queue();
        
        // 第一个任务
        dispatch_sync(queue, ^{
            
            //这里线程暂停2秒,模拟一般的任务的耗时操作
            [NSThread sleepForTimeInterval:2];
            
            NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
        });
    });
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
    
}


//异步执行 and 主队列
//总结：所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）,在主线程中执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)asyncAndMainqueue{
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);
    
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 第一个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第二个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
    });
    
    // 第三个任务
    dispatch_async(queue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
    
}

#pragma mark ---------GCD其它常用API----------

//各种队列的获取方法
-(void)getQueue{
    
    //主队列的获取方法:主队列是串行队列，主队列中的任务都将在主线程中执行
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
    
    //串行队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列（若为NULL时，默认是DISPATCH_QUEUE_SERIAL）
    dispatch_queue_t seriaQueue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    //并发队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列（若为NULL时，默认是DISPATCH_QUEUE_SERIAL）
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //全局并发队列的获取方法:第一个参数表示队列优先级,我们选择默认的好了,第二个参数flags作为保留字段备用,一般都直接填0
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

//自定义队列的创建方法
-(void)queue_create{
    //串行队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列（若为NULL时，默认是DISPATCH_QUEUE_SERIAL）
    dispatch_queue_t seriaQueue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    //并发队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列（若为NULL时，默认是DISPATCH_QUEUE_SERIAL）
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_CONCURRENT);
}

//使用dispatch_set_target_queue更改Dispatch Queue的执行优先级
-(void)testTargetQueue1{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    //串行队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列（若为NULL时，默认是DISPATCH_QUEUE_SERIAL）
    dispatch_queue_t seriaQueue = dispatch_queue_create("com.test.testQueue", NULL);
    
    //指定一个任务
    dispatch_async(seriaQueue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
    });
    
    //全局并发队列的获取方法:第一个参数表示队列优先级,我们选择默认的好了,第二个参数flags作为保留字段备用,一般都直接填0
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //指定一个任务
    dispatch_async(globalQueue, ^{
        
        //这里线程暂停2秒,模拟一般的任务的耗时操作
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
    });
    
    
    //第一个参数为要设置优先级的queue,第二个参数是参照物，即将第一个queue的优先级和第二个queue的优先级设置一样。
    //第一个参数如果是系统提供的【主队列】或【全局队列】,则不知道会出现什么情况，因此最好不要设置第一参数为系统提供的队列
    dispatch_set_target_queue(seriaQueue,globalQueue);
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);

}

//dispatch_set_target_queue除了能用来设置队列的优先级之外，还能够创建队列的层次体系，当我们想让不同队列中的任务同步的执行时，我们可以创建一个串行队列，然后将这些队列的target指向新创建的队列即可。
- (void)testTargetQueue2 {
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    dispatch_queue_t targetQueue = dispatch_queue_create("com.test.target_queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue1 = dispatch_queue_create("com.test.queue1", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue2 = dispatch_queue_create("com.test.queue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_set_target_queue(queue1, targetQueue);
    
    dispatch_set_target_queue(queue2, targetQueue);
    
    //指定一个异步任务
    dispatch_async(queue1, ^{
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
    });
    
    //指定一个异步任务
    dispatch_async(queue2, ^{
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
    });
    
    //指定一个异步任务
    dispatch_async(queue2, ^{
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2];
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);

}

//延时执行,需要注意的是：dispatch_after函数并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中。严格来说，这个时间并不是绝对准确的，但想要大致延迟执行任务，dispatch_after函数是很有效的。
-(void)dispatch_after{
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2秒后异步追加任务代码到主队列等待执行
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);

}

//只执行一次,通常在创建单例时使用，多线程环境下也能保证线程安全
-(void)dispatch_once_1{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"----只执行一次的任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);

}

//快速遍历方法，可以替代for循环的函数。dispatch_apply按照指定的次数将指定的任务追加到指定的队列中，并等待全部队列执行结束。
//会创建新的线程，并发执行
-(void)dispatch_apply{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(100, globalQueue, ^(size_t index) {
        NSLog(@"执行第%zd次的任务---%@",index, [NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);

}

//队列组:当我们遇到需要异步下载3张图片，都下载完之后再拼接成一个整图的时候，就需要用到gcd队列组。
-(void)dispatch_group{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 第一个任务
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 第二个任务
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 第三个任务
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行最后的汇总任务---当前线程%@",[NSThread currentThread]);
    });
    
    //若想执行完上面的任务再走下面这行代码可以加上下面这句代码
    
    // 等待上面的任务全部完成后，往下继续执行（会阻塞当前线程）
    //    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
}

//dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1
//dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。
//当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
-(void)dispatch_group_1{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 第一个任务
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 第二个任务
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 第三个任务
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [NSThread sleepForTimeInterval:2];
        NSLog(@"----执行最后的汇总任务---当前线程%@",[NSThread currentThread]);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);

}

//信号量
//总结:信号量设置的是2，在当前场景下，同一时间内执行的线程就不会超过2，先执行2个线程，等执行完一个，下一个会开始执行。
-(void)dispatch_semaphore{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(queue, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"----开始执行第一个任务---当前线程%@",[NSThread currentThread]);
        
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----结束执行第一个任务---当前线程%@",[NSThread currentThread]);
        
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务2
    dispatch_async(queue, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"----开始执行第二个任务---当前线程%@",[NSThread currentThread]);
        
        [NSThread sleepForTimeInterval:1];
        
        NSLog(@"----结束执行第二个任务---当前线程%@",[NSThread currentThread]);
        
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务3
    dispatch_async(queue, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"----开始执行第三个任务---当前线程%@",[NSThread currentThread]);
        
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----结束执行第三个任务---当前线程%@",[NSThread currentThread]);
        
        dispatch_semaphore_signal(semaphore);
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);

}


//在读取较大的文件时,如果将文件分成合适的大小并使用 Global Dispatch Queue 并列读取的话,应该会比一般的读取速度快不少。 在 GCD 当中能实现这一功能的就是 Dispatch I/O 和 Dispatch Data。
-(void)dispatch_IO{
    
    //一般情况下可以这样异步去读取数据
    //    dispatch_async(queue, ^{ /* 读取  0     ～ 8080  字节*/ });
    //    dispatch_async(queue, ^{ /* 读取  8081  ～ 16383 字节*/ });
    //    dispatch_async(queue, ^{ /* 读取  16384 ～ 24575 字节*/ });
    //    dispatch_async(queue, ^{ /* 读取  24576 ～ 32767 字节*/ });
    //    dispatch_async(queue, ^{ /* 读取  32768 ～ 40959 字节*/ });
    //    dispatch_async(queue, ^{ /* 读取  40960 ～ 49191 字节*/ });
    //    dispatch_async(queue, ^{ /* 读取  49192 ～ 57343 字节*/ });
    //    dispatch_async(queue, ^{ /* 读取  57344 ～ 65535 字节*/ });
    
    
    //下面是GCD提供的更加便捷的操作姿势
    
    int fd = 0, fdpair[2];
    dispatch_queue_t pipe_q;
    dispatch_io_t pipe_channel;
    dispatch_semaphore_t sem;
    /* ..... 此处省略若干代码.....*/
    
    // 创建串行队列
    pipe_q = dispatch_queue_create("PipeQ", NULL);
    // 创建 Dispatch I／O
    
    pipe_channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, pipe_q, ^(int err){
        close(fd);
    });
    
    // 该函数设定一次读取的大小（分割大小）
    dispatch_io_set_low_water(pipe_channel, SIZE_MAX);
    
    dispatch_io_read(pipe_channel, 0, SIZE_MAX, pipe_q, ^(bool done, dispatch_data_t pipedata, int err){
        if (err == 0) // err等于0 说明读取无误
        {
            // 读取完“单个文件块”的大小
            size_t len = dispatch_data_get_size(pipedata);
            if (len > 0)
            {
                //                // 定义一个字节数组bytes
                //                const charchar *bytes = NULL;
                //                charchar *encoded;
                //
                //                dispatch_data_t md = dispatch_data_create_map(pipedata, (const voidvoid **)&bytes, &len);
                //                encoded = asl_core_encode_buffer(bytes, len);
                //                asl_set((aslmsg)merged_msg, ASL_KEY_AUX_DATA, encoded);
                //                free(encoded);
                //                _asl_send_message(NULL, merged_msg, -1, NULL);
                //                asl_msg_release(merged_msg);
                //                dispatch_release(md);
            }
        }
        if (done)
        {
            dispatch_semaphore_signal(sem);
        }
    });
}


//隔断方法：当前面的写入操作全部完成之后，再执行后面的读取任务。当然也可以用Dispatch Group和dispatch_set_target_queue,只是比较而言，dispatch_barrier_async会更加顺滑
-(void)dispatch_barrier_async{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 第一个写入任务
        [NSThread sleepForTimeInterval:3];
        
        NSLog(@"----执行第一个写入任务---当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_async(queue, ^{
        // 第二个写入任务
        [NSThread sleepForTimeInterval:1];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
        
    });
    
    dispatch_barrier_async(queue, ^{
        // 等待处理
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----等待前面的任务完成---当前线程%@",[NSThread currentThread]);
        
    });
    
    dispatch_async(queue, ^{
        // 第一个读取任务
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第一个读取任务---当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_async(queue, ^{
        // 第二个读取任务
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"----执行第二个读取任务---当前线程%@",[NSThread currentThread]);
        
    });
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);

}

//场景：当追加大量处理到Dispatch Queue时，在追加处理的过程中，有时希望不执行已追加的处理。例如演算结果被Block截获时，一些处理会对这个演算结果造成影响。在这种情况下，只要挂起Dispatch Queue即可。当可以执行时再恢复。
//总结:dispatch_suspend，dispatch_resume提供了“挂起、恢复”队列的功能，简单来说，就是可以暂停、恢复队列上的任务。但是这里的“挂起”，并不能保证可以立即停止队列上正在运行的任务，也就是如果挂起之前已经有队列中的任务在进行中，那么该任务依然会被执行完毕
-(void)dispatch_suspend{
    
    NSLog(@"----start-----当前线程---%@",[NSThread currentThread]);

    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 执行第一个任务
        [NSThread sleepForTimeInterval:5];
        
        NSLog(@"----执行第一个任务---当前线程%@",[NSThread currentThread]);
        
    });
    
    dispatch_async(queue, ^{
        // 执行第二个任务
        [NSThread sleepForTimeInterval:5];
        
        NSLog(@"----执行第二个任务---当前线程%@",[NSThread currentThread]);
        
    });
    
    dispatch_async(queue, ^{
        // 执行第三个任务
        [NSThread sleepForTimeInterval:5];
        
        NSLog(@"----执行第三个任务---当前线程%@",[NSThread currentThread]);
    });
    
    //此时发现意外情况，挂起队列
    NSLog(@"suspend");
    dispatch_suspend(queue);
    
    //挂起10秒之后，恢复正常
    [NSThread sleepForTimeInterval:10];
    
    //恢复队列
    NSLog(@"resume");
    dispatch_resume(queue);
    
    NSLog(@"----end-----当前线程---%@",[NSThread currentThread]);
    
}

- (IBAction)runBtnHandler:(id)sender {
    SEL selector = NSSelectorFromString(self.selectorStr);
    if([self respondsToSelector:selector]){
        SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:nil]);
    }
}
@end
