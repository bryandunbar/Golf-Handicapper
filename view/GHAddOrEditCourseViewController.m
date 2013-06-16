//
//  GHAddOrEditCourseViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHAddOrEditCourseViewController.h"

@interface GHAddOrEditCourseViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *abbreviation;
@property (weak, nonatomic) IBOutlet UITextField *tees;
@property (weak, nonatomic) IBOutlet UITextField *rating;
@property (weak, nonatomic) IBOutlet UITextField *slope;

@end

@implementation GHAddOrEditCourseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.course) {
        self.navigationItem.leftBarButtonItem = nil; // Pushed, use default back
        [self configureView];
    }
    
}

-(void)configureView {
    
    self.name.text = self.course.name;
    self.abbreviation.text = self.course.abbreviation;
    self.rating.text = [NSString stringWithFormat:@"%f", self.course.rating];

    self.slope.text = [NSString stringWithFormat:@"%d", self.course.slope];
    self.tees.text = self.course.tees;
    
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
    
    if (!self.course) {
        self.course = [[GHCourse alloc] init];
    }
    
    self.course.name = self.name.text;
    self.course.abbreviation = self.abbreviation.text;
    self.course.rating =  [self.rating.text doubleValue];
    self.course.slope = [self.slope.text intValue];
    self.course.tees = self.tees.text;
    
    [self.course save];
    
    
    if ([self.navigationController viewControllers][0] == self)
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.name) {
        
        NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSMutableString * firstCharacters = [NSMutableString string];
        NSArray * words = [newValue componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for (NSString * word in words) {
            if ([word length] > 0) {
                NSString * firstLetter = [word substringToIndex:1];
                [firstCharacters appendString:[firstLetter uppercaseString]];
            }
        }
        self.abbreviation.text = [firstCharacters description];
    }
    
    return YES;
}

@end
