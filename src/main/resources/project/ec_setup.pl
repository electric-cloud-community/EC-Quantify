my %runQuantify = (
    label       => "Quantify - Run Quantify",
    procedure   => "runQuantify",
    description => "Runs Quantify",
    category    => "Code Analysis"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/Quantify - runQuantify");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Quantify - Run Quantify");

@::createStepPickerSteps = (\%runQuantify);
