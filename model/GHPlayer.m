//
//  GHPlayer.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHPlayer.h"
#import "GHLeague.h"


@implementation GHPlayer

@dynamic firstName;
@dynamic handicapIndex;
@dynamic lastName;
@dynamic leagues;


+ (NSString *)entityName {
    return @"Player";
}
+ (NSArray *)defaultSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
}

@end
