//
//  WebService-Prefix.h
//
//  Created by parth patel on 14/09/13.
//  Copyright (c) All rights reserved.
//

#define DEFAULT_TIMEOUT 300.0f

/**** Obj access ***/

/**
 *	Server Config
 */
//#if TARGET_IPHONE_SIMULATOR
//#define ServerPath                       "http://192.168.1.202/ratevoteapp/"
//#elif TARGET_OS_IPHONE
//#define ServerPath                       "http://narolademo.no-ip.org/ratevoteapp/"
//#endif

//#if TARGET_IPHONE_SIMULATOR
//#define ServerPath                       "http://192.168.1.202/ratevoteapp/"
//#elif TARGET_OS_IPHONE
#define ServerPath                       "http://107.170.93.130/api/"
#define Image_URL_Thumb             "http://107.170.93.130/api/timthumb.php?src="
//#endif



/**
 *	Defult Image path location
 */

#define URLDefultImageURL(XX) XX.length>0?[NSURL URLWithString:[NSString stringWithFormat:@"%s/Images/%@", ServerPath, XX]]:0

/**************************     UserMaster     **********************************/

/**
 *	Other Webserivce URls and Parameters Macros
 */

#define getService  "GetService.php?Service"

/**
 *	Login Registration
 */

#define URLLogin            [NSString stringWithFormat:@"%slogin.php",ServerPath]
#define URLRegistration     [NSString stringWithFormat:@"%sregistration.php",ServerPath]

/**
 *	Global Search
 */
#define URLGlobalSearch     [NSString stringWithFormat:@"%sglobalSearch.php",ServerPath]


/**
 *	Achivements
 */
#define URLGetAllAchivements [NSString stringWithFormat:@"%sgetAchievementsByUser.php",ServerPath]


/**
 *	Favourite Post
 */
#define URLGetFavouritePost [NSString stringWithFormat:@"%sgetFavouritePostsByUser.php",ServerPath]

/**
 *	Post
 */
#define URLGetMyPost [NSString stringWithFormat:@"%sgetPostsByUser.php",ServerPath]

/**
 *	All Post
 */
#define URLGetAllPosts [NSString stringWithFormat:@"%sgetPosts.php",ServerPath]
/**
 *	Create Post
 */
#define URLCreatePost [NSString stringWithFormat:@"%screatePost1.php",ServerPath]

/**
 *	Create hash tag
 */
#define URLCreateHashTag [NSString stringWithFormat:@"%screateHashtag.php",ServerPath]

/**
 *	Get All hash tag
 */
#define URLGetAllHashTag [NSString stringWithFormat:@"%sgetAllHashtag.php",ServerPath]

/**
 *	Get All Followers
 */
#define URLGetAllFollowers [NSString stringWithFormat:@"%sgetAllFollowersByUser.php",ServerPath]

/**
 *	Get User Details
 */
#define URLProfileDetailByUser [NSString stringWithFormat:@"%sgetProfile.php",ServerPath]

/**
 *	Get Comments For Post
 */
#define URLGetCommentForPost [NSString stringWithFormat:@"%sgetAllComment.php",ServerPath]

/**
 *	Add Comment To Post
 */
#define URLAddCommentToPost [NSString stringWithFormat:@"%saddComment.php",ServerPath]

/**
 *	Like Comment
 */
#define URLLikeComment [NSString stringWithFormat:@"%slikeComment.php",ServerPath]

/**
 *	Remove DisLike Comment
 */
#define URLRemoveDisLikeComment [NSString stringWithFormat:@"%sremoveCommentLike.php",ServerPath]

/**
 *	Remove Like Comment
 */
#define URLRemoveLikeComment [NSString stringWithFormat:@"%sremoveCommentLike.php",ServerPath]

/**
 * Vote Post
 */
#define URLVotePost [NSString stringWithFormat:@"%svotePost.php",ServerPath]

/*
* Get All Names
*/
#define URLGetAllNames [NSString stringWithFormat:@"%sgetAllNames.php",ServerPath]

/*
 * Mark favorite Post
 */
#define URLMarkFavoritePost [NSString stringWithFormat:@"%smarkFavouritePost.php",ServerPath]

/*
 * Follow User
 */
#define URLFollowUnFollowuser [NSString stringWithFormat:@"%sfollowUser.php",ServerPath]


/*
 * New Posts
 */
#define URLGetNewPosts [NSString stringWithFormat:@"%sgetMySharedPosts.php",ServerPath]


/*
 * Following Posts
 */
#define URLGetFollowingPosts [NSString stringWithFormat:@"%sgetPostsToWhomUserFollowing.php",ServerPath]


/*
 * get Notification
 */
#define URLGetAllNotification [NSString stringWithFormat:@"%sgetAllNotificationsByUser.php",ServerPath]


/*
 * Update Profile
 */
#define URLUpdateProfile [NSString stringWithFormat:@"%supdateProfile.php",ServerPath]


/*
 * Share Post
 */
#define URLSharePost [NSString stringWithFormat:@"%ssharePost.php",ServerPath]




/*
 * Create Battle
 */
#define URLCrateBattle [NSString stringWithFormat:@"%screateBattle.php",ServerPath]


/*
 * Battle invitation
 */
#define URLInviteForBattle [NSString stringWithFormat:@"%sinviteForBattle.php",ServerPath]


/*
 * Accept / Reject Battle invitation
 */
#define URLAcceptRejectBattle [NSString stringWithFormat:@"%sacceptRejectBattle.php",ServerPath]


/*
 * Get battle By User
 */
#define URLGetBattleByUser [NSString stringWithFormat:@"%sgetBattleByUser1.php",ServerPath]



#define paraImageURL_Thumb(Imagename)\
[NSString stringWithFormat:@"%s/%@&h=200&w=200&zc=1", Image_URL_Thumb, Imagename]

#define paraImageURL_Big(Imagename)\
[NSString stringWithFormat:@"%s/%@&h=600&w=600&zc=1", Image_URL_Thumb, Imagename]

