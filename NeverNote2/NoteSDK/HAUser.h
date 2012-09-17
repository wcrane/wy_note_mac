//
//  HAUser.h
//  NeverNote2
//
//  Created by wcrane on 9/11/12.
//  Copyright (c) 2012 HappyApp小分队. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAUser : NSObject <NSCoding>
{
    NSDate      *register_time;
    long long   used_size;
    NSDate      *last_login_time;
    long long   total_size;
    NSDate      *last_modify_time;
    NSString    *default_notebook;
    NSString    *user;
}
@property (nonatomic, retain) NSDate    *register_time;
@property (nonatomic, assign) long long used_size;
@property (nonatomic, retain) NSDate    *last_login_time;
@property (nonatomic, assign) long long total_size;
@property (nonatomic, retain) NSDate    *last_modify_time;
@property (nonatomic, retain) NSString  *default_notebook;
@property (nonatomic, retain) NSString  *user;

- (id)initWithJsonDict:(NSDictionary *)dict;
+ (id)getUserFromJsonDict:(NSDictionary *)dict;
@end
