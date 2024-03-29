//
//  MainViewController.m
//  AVRUIKit-SplashView
//
//  Created by Andrea Gelati on 15/01/12.
//  Copyright (c) 2012 Push Popcorn. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (id)init {
    self = [super init];
    if (self) {
        [[self view] setBackgroundColor:[UIColor redColor]];

        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0,0,120,30)];
        [[self view] addSubview:b];
        [b setTitle:@"ciao" forState:UIControlStateNormal];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
