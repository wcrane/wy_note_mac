//
//  HANoteBooksViewController.h
//  NeverNote2
//
//  Created by wcrane on 9/11/12.
//  Copyright (c) 2012 HappyApp小分队. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HANoteBooksViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, assign) IBOutlet NSTableView *noteBooksView;

@property (nonatomic, retain) NSMutableArray *noteBooksArray;

- (void)refreshData;
@end
