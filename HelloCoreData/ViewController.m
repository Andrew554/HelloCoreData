//
//  ViewController.m
//  HelloCoreData
//
//  Created by Andrew554 on 16/8/26.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>  
#import "AppDelegate.h"
#import "Person.h"

@interface ViewController () {
    // 成员变量
    AppDelegate *app;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = [UIApplication sharedApplication].delegate;

}

// 增加
- (IBAction)coreDataAdd:(id)sender {
    
    // 创建操作实体类
    Person *person  = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:app.managedObjectContext];
    
    u_int32_t ID = arc4random_uniform(10);
    person.name = [NSString stringWithFormat:@"小屁孩%zd", ID];
    person.sex = (ID%2 == 0) ? @"男" : @"女";
    person.age = [NSString stringWithFormat:@"%d", arc4random_uniform(100)];
    
    NSError *error;
    
    // 保存结果
    [app.managedObjectContext save:&error];
    
    if(error) {
        NSLog(@"%@---%@---%@, 添加失败!!!", person.name, person.sex, person.age);
    }else {
        NSLog(@"%@---%@---%@, 添加成功!!!", person.name, person.sex, person.age);
    }
}

// 删除
- (IBAction)coreDataDelete:(id)sender {
    
    // 读取这个类
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Person class]) inManagedObjectContext:app.managedObjectContext];
    // 建立请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置请求类
    [request setEntity:entity];
    // 设置检索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sex = %@", @"男"];
    [request setPredicate:predicate];
    
    // 遍历所有的Person, 获取所有满足条件的Person信息, 存储在数组里面
    NSArray *personArr = [app.managedObjectContext executeFetchRequest:request error:nil];
    
    if(personArr.count > 0) {
        for (Person *person in personArr) {
            // 删除
            [app.managedObjectContext deleteObject:person];
        }
        
        // 保存结果
        [app.managedObjectContext save:nil];
        NSLog(@"删除完成!");
    }else {
        NSLog(@"没有检索到数据");
    }
}

// 修改
- (IBAction)coreDataUpdate:(id)sender {
    //读取这个类
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:app.managedObjectContext];
    //建立请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //建立请求的是哪一个类
    [request setEntity:entity];
    //设置检索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name != %@",@"小屁孩2"];
    [request setPredicate:predicate];
    //遍历所有的Person，获取所有的Person信息，存储在数组里面
    NSArray *array = [app.managedObjectContext executeFetchRequest:request error:nil];
    if (array.count > 0) {
        for (Person *person in array) {
            if ([person.sex isEqualToString:@"男"]) {
                person.name = @"hello男";
            }
        }
        //保存结果
        [app.managedObjectContext save:nil];
        NSLog(@"修改完成");
    }else{
        NSLog(@"没有检索到数据");
    }
}

// 查看
- (IBAction)coreDataSelect:(id)sender {
    // 读取这个类, 根据key查找
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Person class]) inManagedObjectContext:app.managedObjectContext];
    // 建立请求
    NSFetchRequest *request =  [[NSFetchRequest alloc] init];
    // 建立请求的是哪一个类
    [request setEntity:entity];
    //设置检索条件
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sex = %@",@"男"];
//    [request setPredicate:predicate];
    // 遍历所有的Person类, 获取所有的Person信息, 存储在数组中
    NSArray *personArray = [app.managedObjectContext executeFetchRequest:request error:nil];
    
    for (Person *person in personArray) {
        NSLog(@"%@---%@---%@", person.name, person.sex, person.age);
    }
}
@end
