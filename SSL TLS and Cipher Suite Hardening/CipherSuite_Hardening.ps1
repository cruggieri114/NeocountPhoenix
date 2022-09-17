#
#         _/|       |\_
#        /  |       |  \
#       |    \     /    |
#       |  \ /     \ /  |
#       | \  |     |  / |
#       | \ _\_/^\_/_ / |
#       |    --\//--    |                         Script to Harden SSL/TLS settings and remove weak, deprecated Cipher Suites for Windows
#        \_  \     /  _/                                Written by Chris Ruggieri
#          \__  |  __/                                   
#             \ _ /
#            _/   \_   
#           / _/|\_ \  
#            /  |  \   
#   
#Directions:
#
#Usage = Run as Administrator (or execute as a SYSTEM job using a configuration/software manager like BigFix, SCCM, Tanium, etc.) CipherSuite_Hardening.ps1 


function disable-ssl2-through-tls-1-1 {
	#Will remove the SSLv2.0, SSLv3.0, TLSv1.0, and TLSv1.1 Registry keys
    $SChannelRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
	Remove-Item –Name "SSL 2.0" –Path $SChannelRegPath
	Remove-Item –Name "SSL 3.0" –Path $SChannelRegPath
	Remove-Item –Name "TLS 1.0" –Path $SChannelRegPath
	Remove-Item –Name "TLS 1.1" –Path $SChannelRegPath
}
function enable-tls-1-2 {
	#Creates or rewrites TLSv1.2 settings to Enabled
    New-Item ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server’ -Force
    New-Item ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client’ -Force
    New-ItemProperty -Path ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server’ -Name ‘Enabled’ -Value ‘0xffffffff’ –PropertyType DWORD
    New-ItemProperty -Path ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server’ -Name ‘DisabledByDefault’ -Value 0 –PropertyType DWORD
    New-ItemProperty -Path ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client’ -Name ‘Enabled’ -Value 1 –PropertyType DWORD
    New-ItemProperty -Path ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client’ -Name ‘DisabledByDefault’ -Value 0 –PropertyType DWORD
    Write-Host "Enabling TLSv1.2"
}
function enable-tls-1-3 {
	#Creates or rewrites TLSv1.3 settings to Enabled
    New-Item ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server’ -Force
    New-Item ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client’ -Force
    New-ItemProperty -Path ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server’ -Name ‘Enabled’ -Value ‘0xffffffff’ –PropertyType DWORD
    New-ItemProperty -Path ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server’ -Name ‘DisabledByDefault’ -Value 0 –PropertyType DWORD
    New-ItemProperty -Path ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client’ -Name ‘Enabled’ -Value 1 –PropertyType DWORD
    New-ItemProperty -Path ‘HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client’ -Name ‘DisabledByDefault’ -Value 0 –PropertyType DWORD
    Write-Host "Enabling TLSv1.3 "
}
function disable-cbc-and-weak-cipher-suites{
	#Removes weak and deprecated  TLS Cipher Suites
	Disable-TlsCipherSuite -Name "TLS_DHE_RSA_WITH_AES_256_CBC_SHA"
	Disable-TlsCipherSuite -Name "TLS_DHE_RSA_WITH_AES_128_CBC_SHA"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_256_GCM_SHA384"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_128_GCM_SHA256"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_256_CBC_SHA256"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_128_CBC_SHA256"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_256_CBC_SHA"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_AES_128_CBC_SHA"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_3DES_EDE_CBC_SHA"
	Disable-TlsCipherSuite -Name "TLS_DHE_DSS_WITH_AES_256_CBC_SHA256"
	Disable-TlsCipherSuite -Name "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256"
	Disable-TlsCipherSuite -Name "TLS_DHE_DSS_WITH_AES_256_CBC_SHA"
	Disable-TlsCipherSuite -Name "TLS_DHE_DSS_WITH_AES_128_CBC_SHA"
	Disable-TlsCipherSuite -Name "TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_RC4_128_SHA"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_RC4_128_MD5"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_NULL_SHA256"
	Disable-TlsCipherSuite -Name "TLS_RSA_WITH_NULL_SHA"
	Disable-TlsCipherSuite -Name "TLS_PSK_WITH_AES_256_GCM_SHA384"
	Disable-TlsCipherSuite -Name "TLS_PSK_WITH_AES_128_GCM_SHA256"
	Disable-TlsCipherSuite -Name "TLS_PSK_WITH_AES_256_CBC_SHA384"
	Disable-TlsCipherSuite -Name "TLS_PSK_WITH_AES_128_CBC_SHA256"
	Disable-TlsCipherSuite -Name "TLS_PSK_WITH_NULL_SHA384"
	Disable-TlsCipherSuite -Name "TLS_PSK_WITH_NULL_SHA256"
}

# A Reboot WILL BE REQUIRED UPON COMPLETION; However, it can be scheduled at any time. The changes just won't take effect until the reboot.
reg export HKLM\  exportedHKLM.reg
disable-ssl2-through-tls-1-1
enable-tls-1-2
enable-tls-1-3