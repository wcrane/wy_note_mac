//
//  HASingleNote.m
//  NeverNote2
//
//  Created by admin on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HASingleNote.h"

@implementation HASingleNote

@synthesize path = _path;

- (id)init
{
    self = [super init];
    if (self) {
        self.path = nil;
    }
    
    return self;
}

- (id)initWithPath:(NSString *)path_
{
    self = [super init];
    if (self) {
        self.path = path_;
    }
    
    return self;
}

- (void)dealloc
{
    self.path = nil;
    
    [super dealloc];
}

- (BOOL)isPathEqual:(NSString *)path_
{
    return [_path isEqualToString:path_];
}

+ (id)getNoteFromPath:(NSString *)path_
{
    return [[[HASingleNote alloc] initWithPath:path_] autorelease];
}

@end
