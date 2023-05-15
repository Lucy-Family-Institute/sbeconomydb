library(bea.R)

beaKey 	<- "A568B6DF-9398-4E94-B0F0-82AB06DBA301"

beaSpecs <- list(
  'UserID' = beaKey ,
  'Method' = 'GetData',
  'datasetname' = 'NIPA',
  'TableName' = 'T20305',
  'Frequency' = 'Q',
  'Year' = 'X',
  'ResultFormat' = 'json'
);

beaParamVals('A568B6DF-9398-4E94-B0F0-82AB06DBA301', 'RegionalIncome', 'CA25N')

beaPayload <- beaGet(beaSpecs)

# https://apps.bea.gov/iTable/iTable.cfm?reqid=19&step=2&isuri=1&1921=survey
# https://apps.bea.gov/API/signup/index.cfm
# https://apps.bea.gov/API/bea_web_service_api_user_guide.htm#tabs-2a