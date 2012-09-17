//
//  HANoteBookManager.m
//  NeverNote2
//
//  Created by wcrane on 9/11/12.
//  Copyright (c) 2012 HappyApp小分队. All rights reserved.
//

#import "HANoteBookManager.h"

static HANoteBookManager *sharedInstance = nil;

@implementation HANoteBookManager

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc
{
    
    
    [super dealloc];
}

- (HANoteBookManager *)sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[HANoteBookManager alloc] init];
    }
    
    return sharedInstance;
}

@end
