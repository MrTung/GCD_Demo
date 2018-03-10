//
//  DemoViewController.m
//  gcdtest
//
//  Created by greatstar on 2018/3/10.
//  Copyright © 2018年 greatstar. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self othersyncAndMainqueue];
}

#pragma mark --------队列的三种获取方式----------

//串行队列
-(void)testSerialqueue{
    
    // 串行队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    //主队列其实也是一种特殊的串行队列
    //主队列的获取方法
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
}

//并发队列
-(void)testConcurrentqueue{
    
    //并发队列的创建方法:第一个参数表示队列的唯一标识,第二个参数用来识别是串行队列还是并发队列
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
    
    NSLog(@"----当前线程---%@",[NSThread currentThread]);
    
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
    
}

//异步执行 and 并发队列
//总结：从log中可以发现,系统另外开启了3个线程，并且任务是同时执行的,并不是按照1>2>3顺序执行。所以异步+并发队列具备开启新线程的能力,且并发队列可开启多个线程，同时执行多个任务。
-(void)asyncAndConcurrentqueue{
    
    NSLog(@"----当前线程---%@",[NSThread currentThread]);
    
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
}

//同步执行 and 串行队列
//总结：只会在当前线程中依次执行任务，不会开启新线程，执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)syncAndSerialqueue{
    NSLog(@"----当前线程---%@",[NSThread currentThread]);
    
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
}

//异步执行 and 串行队列
//总结:开启了一条新线程，异步执行具备开启新线程的能力且只开启一个线程，在该线程中执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)asyncAndSerialqueue{
    NSLog(@"----当前线程---%@",[NSThread currentThread]);
    
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
}

//同步执行 and 主队列
//总结:直接crash。这是因为发生了死锁，在gcd中，禁止在主队列(串行队列)中再以同步操作执行主队列任务。同理，在同一个同步串行队列中，再使用该队列同步执行任务也是会发生死锁。
-(void)syncAndMainqueue{
    NSLog(@"----当前线程---%@",[NSThread currentThread]);

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
    
    
    //下面的例子类似：
//    dispatch_queue_t queue1 = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_sync(queue1, ^{
//
//        [NSThread sleepForTimeInterval:2];
//
//        NSLog(@"----11111-----当前线程%@",[NSThread currentThread]);//到这里就死锁了
//
//        dispatch_sync(queue1, ^{
//
//            [NSThread sleepForTimeInterval:2];
//
//            NSLog(@"----22222---当前线程%@",[NSThread currentThread]);
//        });
//
//        NSLog(@"----333333-----当前线程%@",[NSThread currentThread]);
//
//    });
//    NSLog(@"----44444-----当前线程%@",[NSThread currentThread]);

}

//其它线程中(同步执行 and 主队列）
//总结：可以执行任务，所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）,在主线程中执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)othersyncAndMainqueue{
    
    NSLog(@"----当前线程---%@",[NSThread currentThread]);

    dispatch_queue_t queue = dispatch_queue_create("com.test.testQueue", DISPATCH_QUEUE_SERIAL);
    
    // 第一个任务
    dispatch_async(queue, ^{
        
        NSLog(@"----执行syncAndMainqueue任务---%@",[NSThread currentThread]);

        [self syncAndMainqueue];
    });
    
}
  

//异步执行 and 主队列
//总结：所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）,在主线程中执行完一个任务，再执行下一个任务,按照1>2>3顺序执行，遵循FIFO原则。
-(void)asyncAndMainqueue{
    NSLog(@"----当前线程---%@",[NSThread currentThread]);
    
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
}





@end
