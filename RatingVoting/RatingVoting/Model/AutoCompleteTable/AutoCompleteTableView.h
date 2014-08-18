//
//  AutoCompleteTableView.h
//  RatingVoting
//
//  Created by c32 on 04/07/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate;

@interface AutoCompleteTableView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tblSuggestionList;
@property (nonatomic, strong) NSMutableArray *suggestionList;

-(void) setAutoCompleteList : (id) filteredArray ;

@property (assign) id <PassValueDelegate> _delegate;

- (void) showSuggestiontableWithList : (NSMutableArray *) list ;
- (void) hideSuggestionList;
@end
