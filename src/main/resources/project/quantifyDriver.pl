    # -------------------------------------------------------------------------
	# Package
	#    commandLineTemplate.pl
	#
	# Dependencies
	#    None
	#
	# Purpose
	#    Template for Single Command-line Plug-ins
	#
	# Template Version
	#    1.0
	#
	# Date
	#    11/05/2010
	#
	# Engineer
	#    Alonso Blanco
	#
	# Copyright (c) 2010 Electric Cloud, Inc.
	# All rights reserved
	# -------------------------------------------------------------------------

    # -------------------------------------------------------------------------
	# Includes
	# -------------------------------------------------------------------------
    use ElectricCommander;
    use warnings;
    use strict; 
    $|=1;


    # -------------------------------------------------------------------------
	# Constants
	# -------------------------------------------------------------------------
    use constant RESULT_TYPE_TEXT => 'text';
    use constant RESULT_TYPE_DATAFILE => 'qfy';
    use constant RESULT_TYPE_DEFAULT => 'default';

    ########################################################################
	# trim - deletes blank spaces before and after the entered value in 
	# the argument
	#
	# Arguments:
	#   -untrimmedString: string that will be trimmed
	#
	# Returns:
	#   trimmed string
	#
	########################################################################  
	sub trim($) {
	  my ($untrimmedString) = @_;
	  my $string = $untrimmedString;
	  $string =~ s/^\s+//;
	  $string =~ s/\s+$//;
	  return $string;
	}
    
    # -------------------------------------------------------------------------
	# Variables
	# -------------------------------------------------------------------------
    $::gQuantifyPath = trim(q($[quantifypath]));
    $::gTarget = trim(q($[target]));
    $::gGranularity = trim("$[granularity]");
    $::gIncludedClasses = trim("$[includedclasses]");
    $::gExcludedClasses = trim("$[excludedclasses]");
    $::gRun = trim("$[run]");
    $::gReplace = trim("$[replace]");
    $::gDotNetApp = trim("$[net]");
    $::gResultFile = trim("$[resultfile]");
    $::gResultFileName = trim("$[resultname]");
    $::gAdditionalCommands = q($[additionalcommands]);
    $::gWorkingDir = trim("$[workingdir]");
    
    #more global variables to be added here
    
    # -------------------------------------------------------------------------
	# Main functions
	# -------------------------------------------------------------------------

    ########################################################################
    # main - contains the whole process to be done by the plugin, it builds 
    #        the command line, sets the properties and the working directory
    #
    # Arguments:
    #   -none
    #
    # Returns:
    #   -nothing
    #
    ########################################################################
    sub main() {
        
        # create args array
        my @args = ();
        
        #properties' map
        my %props;
        
        #executable to use
        my $executable = 'Quantify';
        
        if($::gQuantifyPath && $::gQuantifyPath ne '') {
            $executable = $::gQuantifyPath;
        }
        
        #insert program to invoke
        push(@args, '"'.$executable.'"');
        
        if($::gAdditionalCommands  && $::gAdditionalCommands  ne '') {
            foreach my $command (split(' +', $::gAdditionalCommands)) {
                push(@args, $command);
            }
        }

        if($::gRun && $::gRun ne '') {
            push(@args, '-Run=yes');
        }else{
            push(@args, '-Run=no');
        }
        
        if($::gReplace && $::gReplace ne '') {
            push(@args, '-Replace=yes');
        }else{
            push(@args, '-Replace=no');
        }    
        
        if($::gGranularity && $::gGranularity ne ''){
           push(@args, '-CollectionGranularity=' . $::gGranularity);
        }
        
        if($::gIncludedClasses && $::gIncludedClasses ne ''){
           push(@args, '-QuantifyClassesIncludeMust=' . $::gIncludedClasses);
        }
        
        if($::gExcludedClasses && $::gExcludedClasses ne ''){
           push(@args, '-QuantifyClassesExcludeMust=' . $::gExcludedClasses);
        }        
        
        if($::gDotNetApp && $::gDotNetApp ne '') {
            push(@args, '-net');
        }    
        
        if($::gTarget && $::gTarget ne ''){
         
            push(@args, '"' . $::gTarget . '"')
         
        }
        
        if($::gResultFile && $::gResultFile ne ''){
            
            #evaluates the selected platform
            if($::gResultFile eq RESULT_TYPE_TEXT){
            
                my $defaultTextFileName = $::gResultFileName;
                
                if($defaultTextFileName && $defaultTextFileName ne ''){
                   
                   push(@args, '-SaveTextData ' . $defaultTextFileName);
                   
                }else{
                 
                   push(@args, '-SaveTextData');
                 
                }

            
            }elsif($::gResultFile eq RESULT_TYPE_DATAFILE){
             
                push(@args, '-SaveData reportData.qfy');
                
            }
            
        }
        
        #generate the command to execute in console
        $props{'commandLine'} = createCommandLine(\@args);
        $props{'workingdir'} = $::gWorkingDir;
        
        setProperties(\%props);
        
    }

    ########################################################################
    # createCommandLine - creates the command line for the invocation
    # of the program to be executed.
    #
    # Arguments:
    #   -arr: array containing the command name and the arguments entered by 
    #         the user in the UI
    #
    # Returns:
    #   -the command line to be executed by the plugin
    #
    ########################################################################
    sub createCommandLine($) {

        my ($arr) = @_;

        my $commandName = @$arr[0];

        my $command = $commandName;

        shift(@$arr);

        foreach my $elem (@$arr) {
            $command .= " $elem";
        }

        return $command;
        
    }

    ########################################################################
    # setProperties - set a group of properties into the Electric Commander
    #
    # Arguments:
    #   -propHash: hash containing the ID and the value of the properties 
    #              to be written into the Electric Commander
    #
    # Returns:
    #   -nothing
    #
    ########################################################################
    sub setProperties($) {

        my ($propHash) = @_;

        # get an EC object
        my $ec = new ElectricCommander();
        $ec->abortOnError(0);

        foreach my $key (keys % $propHash) {
            my $val = $propHash->{$key};
            $ec->setProperty("/myCall/$key", $val);
        }
    }

    main();

