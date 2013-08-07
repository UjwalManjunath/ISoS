//
//  SoSContactDetailsVC.m
//  ISoS
//
//  Created by Ujwal Manjunath on 7/30/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "SoSContactDetailsVC.h"
#import "SoSCustomContactDetailCell.h"



#define  NO_OF_CUSTOM_CELLS 1

@interface SoSContactDetailsVC ()

@property (nonatomic,strong) NSString *firstname;

@property (nonatomic,strong) NSString *lastname;

@property (nonatomic,strong) NSMutableDictionary *phoneNumbers; // contains label and numbers

@property (nonatomic,strong) NSMutableDictionary *emailAddresses; // contains label and emailaddress

@property (nonatomic,strong) NSData *imageData;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *titleForHeaders;  //stores header text for each section

@property(nonatomic, getter = isPhonenumberSelected) BOOL phonenumberSelected;

@property(nonatomic, getter = isEmailAddressSelected) BOOL EmailAddressSelected;

@property(nonatomic, getter = isKeyboardShown) BOOL keyboardShown;

@end

@implementation SoSContactDetailsVC{
    UITextField *customtextfield;
    int counter[2];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.phonenumberSelected = NO;
    self.EmailAddressSelected = NO;
    self.keyboardShown = NO;
    counter[0] = 1;
    counter[1] = 1;
    
    [self UpdateUI];
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma GetterMethods


-(NSArray *)titleForHeaders{
    if(!_titleForHeaders)
        _titleForHeaders = @[@"Select a Phonenumber",@"Select an EmailAddress"];
    return _titleForHeaders;
}

-(NSMutableDictionary *)phoneNumbers
{
    if(!_phoneNumbers) _phoneNumbers = [[NSMutableDictionary alloc]init];
    return  _phoneNumbers;
}

-(NSMutableDictionary *)emailAddresses
{
    if(!_emailAddresses) _emailAddresses = [[NSMutableDictionary alloc]init];
    return  _emailAddresses;
}

#pragma setterMethod

-(void)setProfileImage:(UIImageView *)profileImage
{
    _profileImage = profileImage;
    CALayer * l = [profileImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
}

-(void)setImageData:(NSData *)imageData
{
   _imageData = imageData ;
    if(imageData == nil){
       NSString *filePath = [[NSBundle mainBundle] pathForResource:@"defaultProfileImage" ofType:@"png"];
        _imageData = [NSData dataWithContentsOfFile:filePath];
    }
     
}

#pragma UItableView methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.titleForHeaders count];;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return [[@[self.phoneNumbers,self.emailAddresses] objectAtIndex:section]count ] + NO_OF_CUSTOM_CELLS ;

    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
      NSArray *dictionaries = @[self.phoneNumbers,self.emailAddresses];
    
    if(indexPath.row < [[dictionaries objectAtIndex:indexPath.section]count]  ) {
    
    static NSString *cellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
    cell.textLabel.text = [[dictionaries[indexPath.section] allKeys]objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[dictionaries[indexPath.section] allValues]objectAtIndex:indexPath.row];
        return  cell;
    }
    else{
        
       static NSString *CCDCellIdentifier = @"CCDCell";
        SoSCustomContactDetailCell  *cell=  (SoSCustomContactDetailCell *)[tableView dequeueReusableCellWithIdentifier:CCDCellIdentifier ];

        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"customContactDetailCell" owner:self options:nil]objectAtIndex:0];
        }
        
         
        cell.titleLabelText = @"custom";
        cell.detailText.text = @"";
        cell.detailTextFieldPlaceHolder =   [@[@"(123) 456-7890",@"user@example.com"]objectAtIndex:indexPath.section];
        cell.detailText.keyboardType = (indexPath.section) ?  UIKeyboardTypeEmailAddress: UIKeyboardTypePhonePad;
        cell.detailText.returnKeyType = UIReturnKeyDone;
        cell.detailText.delegate = self;
        cell.detailText.tag = indexPath.section;
        
        [cell.detailText addTarget:self action:@selector(returnKeyPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.detailText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        return cell;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
{
    return [self.titleForHeaders objectAtIndex:section];;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryCheckmark;
   
    if(indexPath.section ==0)
    {
        self.phonenumberSelected = YES;
    }
    else if(indexPath.section == 1)
    {
        self.EmailAddressSelected = YES;
    }
    [self deSelectOtherCellsInTableView:tableView Except:indexPath];
   
}

///
/// deselects other cells in the particlur section
///
-(void)deSelectOtherCellsInTableView:(UITableView *)tableView Except:(NSIndexPath *)indexPath{
    for(UITableViewCell *cell in [tableView visibleCells]){
        NSIndexPath *index = [tableView indexPathForCell:cell];
        if(index.section == indexPath.section && index.row != indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}


#pragma Extract Method

-(void) extractContactInformation:(ABRecordRef)person{
    
    self.firstname = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    
    self.lastname = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if(ABMultiValueGetCount(phoneNumbers)>0){
        for(CFIndex i= 0; i< ABMultiValueGetCount(phoneNumbers); i++){
            NSString *phoneNumber = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            NSString *phoneLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phoneNumbers, i));
            [self.phoneNumbers setValue:phoneNumber forKey:phoneLabel];
        }
    }
    else {
        self.phoneNumbers = nil;
    }
    
    ABMultiValueRef emailAddresses = ABRecordCopyValue(person, kABPersonEmailProperty);
    if(ABMultiValueGetCount(emailAddresses)>0){
        for(CFIndex j=0; j< ABMultiValueGetCount(emailAddresses); j++){
            NSString *emailAddress = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(emailAddresses, j));
            NSString *emailAddressLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emailAddresses, j));
            [self.emailAddresses setValue:emailAddress forKey:emailAddressLabel];
        }
    }
    else{
        self.emailAddresses = nil;
    }
    
    self.imageData = (__bridge NSData *)ABPersonCopyImageData(person);
    
}

#pragma UI Update Method
-(void)UpdateUI
{
    self.firstNameLabel.text = self.firstname;
    self.lastNameLabel.text = self.lastname;
    self.profileImage.image = [UIImage imageWithData:self.imageData];
    
}

#pragma uitextfield delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField   {
    customtextfield = textField;
}

-(void)textFieldChanged:(UITextField *)textField{
    if(textField.tag == 0){ // phonenumber field only
        if([[self formatNumber:textField.text] length] ==10){
            [self returnKeyPressed:textField];
            [textField resignFirstResponder];
        }
    }
}

-(void)returnKeyPressed:(UITextField *)textField
{
    if(!(textField.text == nil)){
        NSLog(@"%d",textField.tag);
        [[ @[self.phoneNumbers,self.emailAddresses] objectAtIndex:textField.tag] setValue:textField.text forKey:[NSString stringWithFormat:@"custom %d",counter[textField.tag]]];
        counter[textField.tag]++;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:textField.tag] withRowAnimation:UITableViewRowAnimationBottom | UITableViewRowAnimationFade];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"DID END EDITING");
   
    
             // UITableViewCell *cell = (UITableViewCell *)[[textField superview]superview ];
    //cell.accessoryType= UITableViewCellAccessoryCheckmark;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if( textField.tag == 0){ //formatting for only phonenumber field
        int length = [[self formatNumber:[textField text]] length];
        
        if (length == 10) {
            if(range.length == 0) {
                return NO;
            }
        }
        
        if (length == 3) {
            NSString *num = [self formatNumber:[textField text]];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if (range.length > 0) {
                [textField setText:[NSString stringWithFormat:@"%@",[num substringToIndex:3]]];
            }
        }
        else if (length == 6) {
            NSString *num = [self formatNumber:[textField text]];
            [textField setText:[NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]]];
            if (range.length > 0) {
                [textField setText:[NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]]];
            }
        }
    }
    
    return YES;
}

- (NSString*)formatNumber:(NSString*)mobileNumber {
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    
    
    if (length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    
    
    return mobileNumber;
}

#define kKeyboardAnimationDuration 0.3

#pragma NSNotification selector methods

- (void)keyboardWillShow:(NSNotification *)sender
{
    if (self.keyboardShown) {
        return;
    }
    
    NSDictionary* userInfo = [sender userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the tableview
    CGRect viewFrame = self.tableView.frame;
  
    viewFrame.size.height -= (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
   
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [self.tableView setFrame:viewFrame];
    [UIView commitAnimations];
    
    self.keyboardShown = YES;
    [self moveTextFieldUp];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    
    NSDictionary* userInfo = [sender userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the tableview
    CGRect viewFrame = self.tableView.frame;
    
    viewFrame.size.height += (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
   
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [self.tableView setFrame:viewFrame];
    [UIView commitAnimations];
    
    self.keyboardShown= NO;
    
}

///
/// move the tableview scroll to the top
///
-(void)moveTextFieldUp
{
    UITableViewCell *cell = (UITableViewCell *)[[customtextfield superview]superview];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionBottom  animated:YES];
}


#pragma  Segue Methods

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if(!self.isPhonenumberSelected || !self.isEmailAddressSelected){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Before You save" message:@"Please select an emailaddress and a phonenumber" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    else
        return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"saveContact"]) // prepare for unwind segue
    {
        NSLog(@"prepare for segue called");
        self.contact = @{@"FirstName": self.firstname , @"LastName": self.lastname , @"PhoneNumbers": self.phoneNumbers , @"EmailAddresses": self.emailAddresses, @"Imagedata": self.imageData};
        
    }
}



@end
