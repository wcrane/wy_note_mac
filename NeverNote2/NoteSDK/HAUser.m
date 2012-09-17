//
//  HAUser.m
//  NeverNote2
//
//  Created by admin on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HAUser.h"

@implementation HAUser

@synthesize register_time;
@synthesize used_size;
@synthesize last_login_time;
@synthesize total_size;
@synthesize last_modify_time;
@synthesize default_notebook;
@synthesize user;

- (id)initWithJsonDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        long long date = [[dict objectForKey:@"register_time"] longLongValue];
        self.register_time = [NSDate dateWithTimeIntervalSince1970:date];
        
        self.used_size = [[dict objectForKey:@"used_size"] longLongValue];
        
        date = [[dict objectForKey:@"last_login_time"] longLongValue];
        self.last_login_time = [NSDate dateWithTimeIntervalSince1970:date];
        
        self.total_size = [[dict objectForKey:@"total_size"] longLongValue];
        
        date = [[dict objectForKey:@"last_modify_time"] longLongValue];
        self.last_modify_time = [NSDate dateWithTimeIntervalSince1970:date];
        
        self.default_notebook = [dict objectForKey:@"default_notebook"];
        self.user = [dict objectForKey:@"user"];
    }
    
    return self;
}

+ (id)getUserFromJsonDict:(NSDictionary *)dict
{
    return [[[HAUser alloc] initWithJsonDict:dict] autorelease];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.register_time = [coder decodeObjectForKey:@"register_time"];
        self.used_size = [coder decodeInt64ForKey:@"used_size"];
        self.last_login_time = [coder decodeObjectForKey:@"last_login_time"];
        self.total_size = [coder decodeInt64ForKey:@"total_size"];
        self.last_modify_time = [coder decodeObjectForKey:@"last_modify_time"];
        self.default_notebook = [coder decodeObjectForKey:@"default_notebook"];
        self.user = [coder decodeObjectForKey:@"user"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.register_time forKey:@"register_time"];
    [aCoder encodeInt64:self.used_size forKey:@"used_size"];
    [aCoder encodeObject:self.last_login_time forKey:@"last_login_time"];
    [aCoder encodeInt64:self.total_size forKey:@"total_size"];
    [aCoder encodeObject:self.last_modify_time forKey:@"last_modify_time"];
    [aCoder encodeObject:self.default_notebook forKey:@"default_notebook"];
    [aCoder encodeObject:self.user forKey:@"user"];
}

- (void)dealloc
{
    self.register_time = nil;
    self.last_login_time = nil;
    self.last_modify_time = nil;
    self.default_notebook = nil;
    self.user = nil;
    
    [super dealloc];
}

@end
