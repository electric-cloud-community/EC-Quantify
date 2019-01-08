push(@::gMatchers,
    #invalid license
    {
        id =>        "cs-invalid-license",
        pattern =>          q{FLEXlm Error -2, (.*)},
        action =>           q{&addSimpleError("cs-invalid-license", $1);updateSummary();},
    },
    #connection to license server
    {
        id =>        "cs-connection-error",
        pattern =>          q{FLEXlm Error -15, (.*)},
        action =>           q{&addSimpleError("cs-connection-error", $1);updateSummary();},
    },
    #invalid command option
    {
        id =>        "cs-invalid-command",
        pattern =>          q{Unrecognized options (.*)},
        action =>           q{&addSimpleError("cs-invalid-command","Option $1 is not recognized"); updateSummary();},
    },
    #invalid file
    {
        id =>        "cs-invalid-file",
        pattern =>          q{Unable to find file (.*)},
        action =>           q{&addSimpleError("cs-invalid-file", "Unable to find file: $1");updateSummary();},
    },
    #Licensed number of users already reached
    {
        id =>       "cs-number-users",
        pattern =>          q{FLEXlm Error -4, (.*)},
        action =>           q{&addSimpleError("cs-number-users",$1);updateSummary();},
    },
    #License server does not support this feature.
    {
        id =>       "cs-unsupported-feature",
        pattern =>          q{FLEXlm Error -18, (.*)},
        action =>           q{&addSimpleError("cs-unsupported-feature",$1);updateSummary();},
    },
    
);

sub addSimpleError {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
    }
}

sub updateSummary() {
 
    my $summary = (defined $::gProperties{"cs-invalid-license"}) ? $::gProperties{"cs-invalid-license"} . "\n" : "";
    $summary   .= (defined $::gProperties{"cs-connection-error"}) ? $::gProperties{"cs-connection-error"} . "\n" : "";
    $summary   .= (defined $::gProperties{"cs-invalid-command"}) ? $::gProperties{"cs-invalid-command"} . "\n" : "";
    $summary   .= (defined $::gProperties{"cs-invalid-file"}) ? $::gProperties{"cs-invalid-file"} . "\n" : "";
    $summary   .= (defined $::gProperties{"cs-number-users"}) ? $::gProperties{"cs-number-users"} . "\n" : "";
    $summary   .= (defined $::gProperties{"cs-unsupported-feature"}) ? $::gProperties{"cs-unsupported-feature"} . "\n" : "";
    setProperty ("summary", $summary);
}