//
//  HASingleNote.h
//  NeverNote2
//
//  Created by wcrane on 9/12/12.
//  Copyright (c) 2012 HappyApp小分队. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HASingleNote : NSObject
{
    NSString    *path;
}
@property (nonatomic, retain) NSString *path;

+ (id)getNoteFromPath:(NSString *)path_;

- (BOOL)isPathEqual:(NSString *)path_;
@end
