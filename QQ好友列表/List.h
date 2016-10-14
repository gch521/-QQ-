//
//  List.h
//  QQ好友列表
//
//  Created by gch on 16/10/14.
//  Copyright © 2016年 gch. All rights reserved.
//

#import <Foundation/Foundation.h>

// 整个qq列表
@interface List : NSObject

@property (nonatomic, retain) NSString *title;          // 列表名称
@property (nonatomic, retain) NSMutableArray *groups;   // 列表内分组

@end
