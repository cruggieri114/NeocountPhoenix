<#
         _/|       |\_
        /  |       |  \
       |    \     /    |
       |  \ /     \ /  |
       | \  |     |  / |
       | \ _\_/^\_/_ / |
       |    --\//--    |               Script to Backup BitLocker Keys into InTune
        \_  \     /  _/				Written by Chris Ruggieri
          \__  |  __/					 
             \ _ /						
            _/   \_   
           / _/|\_ \  
            /  |  \   
   
Directions:

Run script from machine needing to migrate or from your software deployment tool
#>

try{
$BLV = Get-BitLockerVolume -MountPoint $env:SystemDrive
        $KeyProtectorID=""
        foreach($keyProtector in $BLV.KeyProtector){
            if($keyProtector.KeyProtectorType -eq "RecoveryPassword"){
                $KeyProtectorID=$keyProtector.KeyProtectorId
                break;
            }
        }

       $result = BackupToAAD-BitLockerKeyProtector -MountPoint "$($env:SystemDrive)" -KeyProtectorId $KeyProtectorID -whatif
return $true
}
catch{
     return $false
}