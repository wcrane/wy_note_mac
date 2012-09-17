//
//  HANotesViewController.h
//  NeverNote2
//
//  Created by wcrane on 9/11/12.
//  Copyright (c) 2012 HappyApp小分队. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HANotesViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, assign) IBOutlet NSTableView *notesView;

@property (nonatomic, retain) NSMutableArray *notesArray;

@end
