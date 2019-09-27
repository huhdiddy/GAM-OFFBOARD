#!/bin/bash
# Set the path to the GAM you want to use
GAM=/Users/tommytran/bin/gam/gam
GAMFILEPATH=~/gam-data

# Capture the leavers email address
get_leaver () {
echo -n "Enter email of user to deprovision & press Enter: "
read -r leaver
}

# Capture the leavers first name
get_firstname () {
echo -n "Enter first name of user & press Enter: "
read -r first-name
}


#Move to Archive Org
move_org () {
$GAM update user ${leaver} org Archive
}

#Reset password
reset_pass () {
$GAM update user ${leaver} password random
}

# Remove the user form the google address list (contacts)
remove_gal () {
$GAM update user ${leaver} gal off
}

# Remove the user from all groups they are a member of, saving a list in case
remove_groups () {
$GAM print user ${leaver} groups > ${leaver}_group_membership.csv
$GAM user ${leaver} delete groups
}

# Revoked all App Passwords, 2 Factor, and OAuth tokens
# Wipe Account from All Mobile Devices
deprovision () {
$GAM user ${leaver} deprovision
}

# Set the vacation message
set_ooo () {
$GAM user ${leaver} vacation on subject "Response from Revel Systems" message "Hello and thank you for your message. \n ${first-name} is no longer with Revel Systems. \n For support please visit: \nhttps://support.revelsystems.com/ \n For any sales related inquires please contact info@revelsystems.com" 
}

# Set the sales vacation message
setsales_ooo () {
$GAM user ${leaver} vacation on subject "Response from Revel Systems" message "Hello, \n \nThank You for your email. ${leaver} is no longer with Revel, but we're happy to help you! \n \nA Revel sales representative will contact you in the next 24 hours. If you need immediate support, please contact the Revel Support Center by visiting Https://support.revelsystems.com/ or calling 415-744-1433." 
}

# Remove Signature
remove_signature () {
$GAM user ${leaver} signature "Thank You"
}


PS3='Select your deprovisioning preference: '
options=('Standard Employee' 'Sales Employee' 'Quit')
select opt in "${options[@]}"
do
  case $opt in
    'Standard Employee')
      get_leaver
      get_firstname
      move_org
      reset_pass
      remove_gal
      remove_groups
      deprovision
      set_ooo
      remove_signature


      
      echo "Please log into Admin Console and reset sign in cookies for ${leaver}"

      break
      ;;
    'Sales Employee')
      get_leaver
      get_firstname
      move_org
      reset_pass
      remove_gal
      remove_groups
      deprovision
      setsales_ooo
      remove_signature

      break
      ;;
    'Quit')
      break
      ;;
    *) echo invalid option;;
  esac
done

