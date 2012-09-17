//
//  HANoteBook.h
//  NeverNote2
//
//  Created by admin on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HANoteBook : NSObject <NSCoding>
{
    NSString    *path;
    NSString    *name;
    NSInteger   notes_num;
    NSDate      *create_time;    //秒
    NSDate      *modify_time;    //秒
    
    NSMutableArray  *notesArray;
}
@property (nonatomic, retain) NSString  *path;
@property (nonatomic, retain) NSString  *name;
@property (nonatomic, assign) NSInteger notes_num;
@property (nonatomic, retain) NSDate    *create_time;
@property (nonatomic, retain) NSDate    *modify_time;

@property (nonatomic, retain) NSMutableArray *notesArray;

- (id)initWithJsonDict:(NSDictionary *)dict;
+ (id)getNoteBookFromJsonDict:(NSDictionary *)dict;
@end
