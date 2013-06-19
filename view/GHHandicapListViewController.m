//
//  GHHandicapListViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/17/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHHandicapListViewController.h"
#import "GHHandicapCalculator.h"
#import "GHPrintFormmater.h"
@interface GHHandicapListViewController () <UIWebViewDelegate> {
    NSMutableArray *data;
    GHHandicapCalculator *calculator;
    UIWebView *printWebView;
}

@property (nonatomic,strong) UIBarButtonItem *printButton;
@end

@implementation GHHandicapListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    calculator = [[GHHandicapCalculator alloc] init];
    
    // Load the table
    [self getDataWithBlock:^{
        [self createPrintWebView];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Get Data
-(void)getDataWithBlock:(void (^)(void))block  {
    
        // Build the data
        NSArray *players = [self.league.players allObjects];
        data = [NSMutableArray arrayWithCapacity:players.count];
    
        int count = 0;
        for (GHPlayer *player in players) {
            
            NSSet *scores = self.useScoresFromSelectedLeagueOnly ?
                [player.scores filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"league == %@", self.league]] : player.scores;
            
            double index = [calculator handicapIndexForScores:[scores allObjects]];
            int trend = [calculator courseHandicapForHandicap:index forCourse:self.course];
            
            NSDictionary *dict = @{@"player":player, @"index":@(index), @"trend":@(trend)};
            
            // Stuff into the dataset and update the table
            [self.tableView beginUpdates];
            [data addObject:dict];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:count inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            count++;
            
        }
        block();
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return data.count;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.course)
        return [self.course description];
    else
        return @"Handicap Index";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GHHandicapListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = data[indexPath.row];
    GHPlayer *player = dict[@"player"];
    cell.textLabel.text = [player description];
    
    if (self.course) { // Showing trends
        int trend = [dict[@"trend"] intValue];
        if (trend == NSNotFound)
            cell.detailTextLabel.text = @"NH";
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", trend];
    } else {
        double index = [dict[@"index"] doubleValue];
        if (index == NSNotFound)
            cell.detailTextLabel.text = @"NH";
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%2.1f", index];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Printing
-(void)createPrintWebView {
    
    printWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    printWebView.delegate = self;
    
    GHPrintFormmater *pf = [[GHPrintFormmater alloc] init];
    NSString *html = [pf printableHtmlForData:data league:self.league andCourse:self.course];
    [printWebView loadHTMLString:html baseURL:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // Set up print button...
    if ([UIPrintInteractionController isPrintingAvailable]) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Print" style:UIBarButtonItemStyleBordered target:self action:@selector(printWebView:)];
        [self.navigationItem setRightBarButtonItem:barButton animated:NO];
        self.printButton = barButton;
    }
}

-(void)printWebView:(id)sender {
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Handicap Listing";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    UIViewPrintFormatter *formatter = [printWebView viewPrintFormatter];
    pc.printFormatter = formatter;
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain,
                 error.code);
        }
    };
    
    [pc presentAnimated:YES completionHandler:completionHandler];
    
}


@end
