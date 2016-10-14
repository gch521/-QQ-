//
//  Group.h
//  QQ好友列表
//
//  Created by gch on 16/10/14.
//  Copyright © 2016年 gch. All rights reserved.
//

#import <Foundation/Foundation.h>



// 分组对象
@interface Group : NSObject

@property (nonatomic, assign) BOOL isDelop;             // 是否展开
@property (nonatomic, retain) NSString *title;          // 分组名称
@property (nonatomic, retain) NSString *detail;         // 在线状态
@property (nonatomic, retain) NSMutableArray *friends;  // 好友列表

@end



