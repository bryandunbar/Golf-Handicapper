//
//  GHPostScoresViewController.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/16/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHPostScoresViewController.h"
#import "GHLeague.h"
#import "GHPlayer.h"
#import "GHPlayerScoreCell.h"
#import "UQDateField2.h"
#import "BDPickerField.h"

@interface GHPostScoresViewController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *_leagues;
    NSArray *_players;
    NSMutableArray *_scores;
}

@property (nonatomic,strong) NSDate *selectedDate;
@property (nonatomic,strong) GHLeague *selectedLeague;

-(void)getLeaguesWithBlock:(void (^)(NSArray *leagues))block;
-(void)getPlayersWithBlock:(void (^)(NSArray *players))block;

@end

@implementation GHPostScoresViewController


-(void)setSelectedLeague:(GHLeague *)selectedLeague {
    
    if (_selectedLeague != selectedLeague) {
        _selectedLeague = selectedLeague;
        
        // Grab the players for the new league
        [self getPlayersWithBlock:^(NSArray *players) {
            _players = players;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedDate = [NSDate date];
    
    [self getLeaguesWithBlock:^(NSArray *leagues) {
        _leagues = leagues;
        _players = nil;
        _scores = [NSMutableDictionary dictionary];
        
        if (leagues.count > 0)
            [self setSelectedLeague:leagues[0]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (_players.count > 0)
        return 2;
    else
        return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2; // Leauge and Date
    } else {
        return _players.count;
    }
    
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"League & Date";
    } else {
        return @"Players";
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) { // League Cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHPostScoreLeagueCell"];
            
            BDPickerField *pickerField = (BDPickerField*)[cell viewWithTag:1000];
            pickerField.picker.delegate = self;
            pickerField.picker.dataSource = self;
            pickerField.text = self.selectedLeague.name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else { // Date Cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHPostScoreDateCell"];
            
            UQDateField2 *dateField =  (UQDateField2*)[cell viewWithTag:1001];
            dateField.dateMode = UIDatePickerModeDate;
            dateField.dateFormat = @"MM/dd/yyyy";
            [dateField setSelectedDate:self.selectedDate];

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
    } else {
        
        // Players...
        GHPlayerScoreCell *cell = (GHPlayerScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"GHPlayerScoreCell"];
        GHPlayer *player = [_players objectAtIndex:indexPath.row];
        cell.playerName.text = [NSString stringWithFormat:@"%@, %@", player.lastName, player.firstName];
        cell.score.text = [player.score stringValue];
        cell.score.tag = 1002 + indexPath.row;
        cell.score.delegate = self;
        
        return cell;
    }
    

    
}

#pragma mark -
#pragma mark - Get Data
-(void)getLeaguesWithBlock:(void (^)(NSArray *))block  {
    
    NSManagedObjectContext *context = [GHLeague mainQueueContext];
    [context performBlock:^{
       
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [GHLeague entityWithContext:context];
        fetchRequest.sortDescriptors = [GHLeague defaultSortDescriptors];
        
        NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
        block(array);
    }];
}

-(void)getPlayersWithBlock:(void (^)(NSArray *))block {
    
    NSArray *arr = [[self.selectedLeague.players allObjects] sortedArrayUsingDescriptors:[GHPlayer defaultSortDescriptors]];
    block(arr);
}


#pragma mark - UIPickerViewDelegate and Datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_leagues count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[_leagues objectAtIndex:row] name];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedLeague = [_leagues objectAtIndex:row];

    //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

@end
