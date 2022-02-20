$liaisonPath="\\smu.edu\files\ExtLoad$\ad_archive\ECAS\DataFiles\"
$liaisonFilter="ECAPI_Applicatoin*.csv"
gci -Path $liaisonPath -Filter $liaisonFilter | import-csv | sort CAS_ID -unique

(gci -Path "$($liaisonPath)ECAPI_Application_*.csv"|import-csv |Sort-Object CAS_ID -Unique).count

(Get-ChildItem -Path "$($liaisonPath)ECAPI_Beta_Application_*.csv"|Import-Csv |Sort-Object CAS_ID -Unique).count