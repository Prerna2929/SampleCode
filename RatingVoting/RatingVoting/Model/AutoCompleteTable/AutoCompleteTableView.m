//
//  AutoCompleteTableView.m
//  RatingVoting
//
//  Created by c32 on 04/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "AutoCompleteTableView.h"
#import "PassValueDelegate.h"
#import "HashTagDetail.h"

static NSString *identifier = @"CustomMenuCell";

@implementation AutoCompleteTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setAutoCompleteList : (id) filteredArray {
    _suggestionList = [[NSMutableArray alloc] init];
    [_suggestionList addObjectsFromArray:filteredArray];
    
    [UIView transitionWithView:_tblSuggestionList
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_tblSuggestionList reloadData];
                    } completion:NULL];
}

-(void)registerView {
    [_tblSuggestionList registerNib:[UINib nibWithNibName:@"AutoCompleteTableView" bundle:nil] forCellReuseIdentifier:identifier];
}

#pragma mark - TableView delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_suggestionList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
    if ([[_suggestionList objectAtIndex:indexPath.row] isKindOfClass:[UserDetail class]]) {
        cell.textLabel.text = ((UserDetail *)[_suggestionList objectAtIndex:indexPath.row]).username;
    }
    else {
        cell.textLabel.text = [_suggestionList objectAtIndex:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * _selectedText;
    if ([[_suggestionList objectAtIndex:indexPath.row] isKindOfClass:[UserDetail class]]) {
        _selectedText =((UserDetail *) [_suggestionList objectAtIndex:[indexPath row]]).username;
        [__delegate passValue:_selectedText wilthAssociateID:((UserDetail *) [_suggestionList objectAtIndex:[indexPath row]]).userId];
    }
    else {
        _selectedText = [_suggestionList objectAtIndex:[indexPath row]];
        [__delegate passValue:_selectedText wilthAssociateID:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void) showSuggestiontableWithList : (NSMutableArray *) list
{

}

- (void) hideSuggestionList
{

}

- (void)updateData
{
	[_suggestionList removeAllObjects];
    [CacheData getcachedataArrayFor_:keyHashTagCache myMethod:^(BOOL finished, NSMutableArray *retrivedList)
                                           {
                                               if(finished){
                                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                       
                                                       [_suggestionList addObjectsFromArray:retrivedList];
                                                       
                                                       [self.tblSuggestionList reloadData];
                                                   }];
                                               }
                                           }];
}

@end