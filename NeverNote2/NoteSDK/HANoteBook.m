//
//  HANoteBook.m
//  NeverNote2
//
//  Created by admin on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HANoteBook.h"

@implementation HANoteBook

@synthesize path;
@synthesize name;
@synthesize notes_num;
@synthesize create_time;
@synthesize modify_time;

@synthesize notesArray = _notesArray;

- (id)init
{
    self = [super init];
    if (self) {
        self.path = nil;
        self.name = nil;
        self.create_time = nil;
        self.modify_time = nil;
        self.notesArray = nil;
    }
    return self;
}

+ (id)getNoteBookFromJsonDict:(NSDictionary *)dict
{
    return [[[HANoteBook alloc] initWithJsonDict:dict] autorelease];
}

- (id)initWithJsonDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.path = [dict objectForKey:@"path"];
        self.name = [dict objectForKey:@"name"];
        notes_num = [[dict objectForKey:@"notes_num"] intValue];
        
        long long date = [[dict objectForKey:@"create_time"] longLongValue];
        self.create_time = [NSDate dateWithTimeIntervalSince1970:date];
        
        date = [[dict objectForKey:@"modify_time"] longLongValue];
        self.modify_time = [NSDate dateWithTimeIntervalSince1970:date];
        
        self.notesArray = nil;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.path = [coder decodeObjectForKey:@"path"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.notes_num = [coder decodeIntegerForKey:@"notes_num"];
        self.create_time = [coder decodeObjectForKey:@"create_time"];
        self.modify_time = [coder decodeObjectForKey:@"modify_time"];
        
        self.notesArray = [coder decodeObjectForKey:@"notesArray"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.notes_num forKey:@"notes_num"];
    [aCoder encodeObject:self.create_time forKey:@"create_time"];
    [aCoder encodeObject:self.modify_time forKey:@"modify_time"];
    
    [aCoder encodeObject:self.notesArray forKey:@"notesArray"];
}

- (void)dealloc
{
    self.path = nil;
    self.name = nil;
    self.create_time = nil;
    self.modify_time = nil;
    
    self.notesArray = nil;
    
    [super dealloc];
}

@end
