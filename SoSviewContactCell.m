//
//  SoSviewContactCell.m
//  ISoS
//
//  Created by Ujwal Manjunath on 7/30/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "SoSviewContactCell.h"
@interface SoSviewContactCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;



@end
@implementation SoSviewContactCell

-(void)setUserName:(NSString *)userName
{
    _userName = userName;
    self.userNameLabel.text = userName;
}

-(void)setProfilePictureData:(NSData *)profilePictureData
{
    _profilePictureData = profilePictureData   ;
    self.profileImageView.image = [UIImage imageWithData:profilePictureData];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
