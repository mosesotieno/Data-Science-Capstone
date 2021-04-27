#---- Header ----

#---- Name: 00_directory_creation.R

#---- Purpose : Create the required directories for the project

#---- Author: Moses Otieno

#---- Date : 27 Apr 2020

#---- Body ----

if(!dir.exists("data")){dir.create("data")}  # data directory

if(!dir.exists("reports")){dir.create("reports")} # reports

if(!dir.exists("scripts")){dir.create("scripts")} # scripts

#---- End ----

