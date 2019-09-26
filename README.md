# Set-StrongAuth
Set Azure MFA StrongAuthenticationMethod default to SMS

Script takes a CSV file input of UPN and sets the default StrongAuthenticationMethod to OneWaySMS

There are a couple of lines (24-26) which are commented out because I use to run on individual accounts in VSCode 
if I have a failure. Its poor because I assume that $PrePopulate is still populated but ive been too lazy to write it properly



