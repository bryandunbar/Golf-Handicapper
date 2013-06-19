//
//  GHScoreListViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/18/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHScoreListViewController.h"
#import "GHScoreCell.h"
#import "GHScore.h"
#import "GHCourse.h"
#import "GHHandicapCalculator.h"

@interface GHScoreListViewController () {
    NSMutableArray *_scores;
    GHHandicapCalculator *calculator;
}

@property (nonatomic,readonly) NSDateFormatter *dateFormatter;
@end

@implementation GHScoreListViewController
@synthesize dateFormatter=_dateFormatter;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Scores";
    calculator = [[GHHandicapCalculator alloc] init];
}
-(void)setPlayer:(GHPlayer *)player {
    if (_player != player) {
        _player = player;
        _scores = [NSMutableArray arrayWithArray:[[_player.scores allObjects] sortedArrayUsingDescriptors:[GHScore defaultSortDescriptors]]];
    }
}
-(NSDateFormatter*)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        //[_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    return _dateFormatter;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _scores = [NSMutableArray arrayWithArray:[[_player.scores allObjects] sortedArrayUsingDescriptors:[GHScore defaultSortDescriptors]]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GHScoreCell";
    GHScoreCell *cell = (GHScoreCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    GHScore *score = _scores[indexPath.row];
    
    cell.dateLabel.text = [self.dateFormatter stringFromDate:score.date];
    cell.courseLabel.text = [score.course description];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%d", [score.value intValue]];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        GHScore *score = _scores[indexPath.row];
        [self deleteScore:score];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)deleteScore:(GHScore*)score {
    [score delete];
    [_scores removeObject:score];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

@end
