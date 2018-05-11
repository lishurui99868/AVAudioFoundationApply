//
//  NSObject+Extension.m
//  音视频
//
//  Created by YY on 2018/5/10.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

- (void)dictChangeModelWithDict:(NSDictionary *)dict {
    Class class = [self class];
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(class, &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        // 获取模型的每一个属性，是带有_的属性
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 截取字符串
        key = [key substringFromIndex:1];
        if (dict[key] == nil) {
            continue;
        }
        
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        id value = dict[key];
        // 判断属性的类型  带“@” 表示为是OC类型，不带“@” 则为基本数据类型
        if ([type hasPrefix:@"@"]) {
            type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
            // 判断是否以 NS 开头  不是的为自定义类，最想拿到的模型
            if (! [type hasPrefix:@"NS"]) {
                Class class = NSClassFromString(type);
                NSObject *obj = [[class alloc] init];
                // 再次调用这个方法  把value值传入  obj为新的对象
                // 交换方法的时候，这个地方必须得改
                [obj dictChangeModelWithDict:value];
                value = obj;
            }
        }
        [self setValue:value forKey:key];
    }
}

+ (NSArray *)objcWithFileName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray  *dataArr  = [NSMutableArray  arrayWithCapacity:array.count];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict  = array[i];
        NSObject *objc  = [[self alloc]init];
        [objc  dictChangeModelWithDict:dict];
        [dataArr addObject:objc];
    }
    return dataArr;
}

@end
