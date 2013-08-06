//
//  SoSContactsVC.m
//  ISoS
//
//  Created by Ujwal Manjunath on 7/30/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "SoSContactsVC.h"
#import "SoSaddContactCell.h"
#import "SoSContactDetailsVC.h"

#define NO_OF_STATIC_CELLS 1
@interface SoSContactsVC ()

@property (nonatomic,strong) NSMutableDictionary *contacts; //stores all contacts

@property (nonatomic,strong) NSArray *titleForHeaders;  //stores header text for each section

@property (nonatomic,strong) NSArray *titleForFooters;  //stores footer text for each section

@property ABRecordRef person;

@end

@implementation SoSContactsVC

#pragma Getter Methods


-(NSArray *)titleForFooters{
    if(!_titleForFooters)
        _titleForFooters = @[@"You can add upto 5 family members",@"You can add upto 5 friends"];
    
    return _titleForFooters;
}

-(NSArray *)titleForHeaders{
    if(!_titleForHeaders)
        _titleForHeaders = @[@"Family",@"Friends"];
    return _titleForHeaders;
}

-(NSMutableDictionary *)contacts
{
    if(!_contacts){
       
        _contacts = [[NSMutableDictionary alloc]initWithDictionary:@{@"Family": [NSNull null] ,@"Friends":[NSNull null] }];
        
    }
    return _contacts;
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Tableview Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return NO_OF_STATIC_CELLS + [self getCount:[self.contacts valueForKey:[[self.contacts allKeys]objectAtIndex:section] ]];
}

-(NSUInteger) getCount:(id)array
{
   if(array == [NSNull null])
       return 0;
    else
        return [array count];
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"addContact";
    SoSaddContactCell *cell= (SoSaddContactCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
   // if (cell == nil) {
       // cell = [[SoSaddContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SoSaddContactCell" owner:self options:nil]objectAtIndex:0];
 //   }
 
 
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Default is 1 if not implemented
    return [[self.contacts allKeys]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.titleForHeaders objectAtIndex:section];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    return [self.titleForFooters objectAtIndex:section];
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showPicker:indexPath.section];
    //
}


#pragma AddressBookUI delegate methods
// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{}];
    
}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{}];
    
    [self setPerson:person];
    
    [self performSegueWithIdentifier:@"addContact" sender: self];
    return NO;
}

// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)showPicker:(NSUInteger)section{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate= self;
    [self presentViewController:picker animated:YES completion:^{}];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[self class]]){
        if([segue.identifier isEqualToString:@"addContact"]){
            if([segue.destinationViewController respondsToSelector:@selector(extractContactInformation:)])
                [segue.destinationViewController performSelector:@selector(extractContactInformation:) withObject:self.person];
        }
    }
}

#pragma Unwind Segue Method

-(IBAction)unwindingMehtod:(UIStoryboardSegue *)segue{
    
    SoSContactDetailsVC *contactDetials = [[SoSContactDetailsVC alloc ]init];
    
    
    
    NSLog(@"back in parent view");
}

@end
