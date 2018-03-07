//
//  AppDelegate.h
//  gcdtest
//
//  Created by greatstar on 2018/3/7.
//  Copyright © 2018年 greatstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

