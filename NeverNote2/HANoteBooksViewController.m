//
//  HANoteBooksViewController.m
//  NeverNote2
//
//  Created by admin on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HANoteBooksViewController.h"
#import "HAAppDelegate.h"

#import "HANoteBook.h"

#import "config.h"

@interface HANoteBooksViewController ()

@end

@implementation HANoteBooksViewController

@synthesize noteBooksView = _noteBooksView;
@synthesize noteBooksArray = _noteBooksArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.noteBooksArray = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadNoteBooks:) name:kLoadNoteBooksAllNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    self.noteBooksArray = nil;
    
    [super dealloc];
}

- (void)refreshData
{
    
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.noteBooksArray count] + 1;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 44.0f;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row == 0) {
        return @"所有笔记";
    }
    
    HANoteBook *notebook = [_noteBooksArray objectAtIndex:row-1];
    
    return notebook.name;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    DLog(@"%@", object);
    
    if (row == 0) {
        return;
    }
    
    HANoteBook *notebook = [_noteBooksArray objectAtIndex:row-1];
    notebook.name = object;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
    DLog(@"Click");
}

- (void) tableViewSelectionDidChange: (NSNotification *) notification
{
    int row = [_noteBooksView selectedRow];
    
    if (row == -1) {
        //do stuff for the no-rows-selected case
    } 
    else if (row == 0) {
        
    }
    else {
        DLog(@"selected: %d", row);
        HANoteBook *notebook = [_noteBooksArray objectAtIndex:row-1];
        HAAppDelegate *appDelegate = [NSApp delegate];
        [appDelegate showNoteBook:notebook];
    }
}

- (void)didLoadNoteBooks:(NSNotification *)notification
{
    NSArray *notebooks = [[notification userInfo] objectForKey:@"userInfo"];
    DLog(@"%@", notebooks);
    
    self.noteBooksArray = nil;
    self.noteBooksArray = [NSMutableArray arrayWithArray:notebooks];
    
    [_noteBooksView reloadData];
}
@end
