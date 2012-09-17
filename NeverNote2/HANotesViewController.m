//
//  HANotesViewController.m
//  NeverNote2
//
//  Created by wcrane on 9/11/12.
//  Copyright (c) 2012 HappyApp小分队. All rights reserved.
//

#import "HANotesViewController.h"

@interface HANotesViewController ()

@end

@implementation HANotesViewController

@synthesize notesView = _notesView;
@synthesize notesArray = _notesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.notesArray = nil;
    
    [super dealloc];
}

@end
