//
//  GHAddOrEditPlayerViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHAddOrEditPlayerViewController.h"

@interface GHAddOrEditPlayerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;


@end

@implementation GHAddOrEditPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.player) {
        self.navigationItem.leftBarButtonItem = self.navigationItem.rightBarButtonItem = nil; // Pushed, use default back
        self.title = @"Edit Player";
        [self configureView];
    }
    
    [self.firstName becomeFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.player) {
        self.player.firstName = self.firstName.text;
        self.player.lastName = self.lastName.text;
        [self.player save];   
    }
}

-(void)configureView {
    self.firstName.text = self.player.firstName;
    self.lastName.text = self.player.lastName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTapped:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveTapped:(id)sender {
    
    [self hideKeyboard];
    
    if (!self.player) {
        self.player = [[GHPlayer alloc] init];
    }
    
    if ([self.navigationController viewControllers][0] == self)
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

@end
