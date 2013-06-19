//
//  GHPrintFormmater.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/18/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHPrintFormmater.h"
#import "GHPlayer.h"

@implementation GHPrintFormmater

-(NSString*)printableHtmlForData:(NSArray *)data league:(GHLeague*)league andCourse:(GHCourse *)course {

    NSMutableString *html = [NSMutableString stringWithString:@"<html><body>"];
    
    if (course) {
        [html appendFormat:@"<div style='font-size:20; font-weight:bold'>Trend Listing for %@</br>%@</div>", league.name, [course description]];
    } else {
        [html appendFormat:@"<div style='font-size:20; font-weight:bold'>Index Listing for %@</div>", league.name];
    }
    
    [html appendString:@"<hr/>"];
    [html appendString:@"<table style='width:100%'>"];
    
    for (NSDictionary *dict in data) {
        GHPlayer *player = dict[@"player"];

        NSString *handicap = nil;
        if (course) { // Showing trends
            int trend = [dict[@"trend"] intValue];
            if (trend == NSNotFound)
                handicap = @"NH";
            else
                handicap = [NSString stringWithFormat:@"%d", trend];
        } else {
            double index = [dict[@"index"] doubleValue];
            if (index == NSNotFound)
                handicap = @"NH";
            else
                handicap = [NSString stringWithFormat:@"%2.1f", index];
        }
        
        [html appendFormat:@"<tr><td><h3>%@</h3></td><td style='text-align:right'><h3>%@</h3></td></tr>", [player description], handicap];
    }
        
    [html appendString:@"</table>"];
    [html appendString:@"</body></html>"];
    
    return [NSString stringWithString:html];

    
}
@end
