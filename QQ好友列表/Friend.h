//
//  Friend.h
//  QQ好友列表
//
//  Created by gch on 16/10/14.
//  Copyright © 2016年 gch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 好友数据对象
@interface Friend : NSObject

@property (nonatomic, retain) NSString *image;  // 头像
@property (nonatomic, retain) NSString *name;   // 昵称
@property (nonatomic, retain) NSString *state;  // 说说

@end


