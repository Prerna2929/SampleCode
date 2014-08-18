//
//  NotificationVC.h
//  RatingVoting
//
//  Created by c85 on 21/06/14.
//  Copyright (c) 2014 Narola. All rights reserved.
//

#import "BaseVC.h"

typedef enum {
    BattleType,
    NotBattle
} NotificationCategory;

//typedef enum {
//    UserFollowNotification,
//    UserUnFollowNotification,
//    BattleInvitationNotification,
//    BattleAcceptedNotification,
//    BattleRejectedNotification
//}NotificationType;


@interface NotificationVC : BaseVC
{
    NotificationCategory selectedSegment;
    IBOutlet UITableView *tblNotification;
}
@end
