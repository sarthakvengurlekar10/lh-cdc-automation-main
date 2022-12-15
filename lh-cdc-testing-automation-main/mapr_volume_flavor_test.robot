*** Settings ***
Documentation     Example using the space separated format.
Library           OperatingSystem
Library           String
Library           ./Cluster.py
Library           ./VolumeFlavor.py
Library           ./Volume.py
Library           ./VolumeAttachment.py
Resource          parameters_mapr.resource

*** Variables ***
${array_id}             219de939-bbbc-4971-ace5-744cff33531e

*** Test Cases ***
Print test message
  [Documentation]  example test case
  Log  ${MESSAGE}
  Check Directory  ${CURDIR}


Login
  [Tags]  robot:exclude

  ${result}  ${output}  Login Portal  ${PORTAL}  ${USER}  ${PASSWORD}  ${MEMBERSHIP}  ${ROLE}
  Log  ${result}
  Log  ${output}
  Should Be True  ${result}


List Arrays
  ${array_ids}  List Arrays
  Log  ${array_ids}


List Hosters
  ${output}  List Hosters
  Log  ${output}

  ${hoster_id}  Get First Hoster Id  ${output}
  Log  ${hoster_id}
  Should Not Be Equal  ${hoster_id}  ""

  Set Global Variable  ${hoster_id}


List Racks
  ${output}  List Racks
  Log  ${output}

  ${rack_id}  Get First Rack Id  ${output}
  Log  ${rack_id}
  Should Not Be Equal  ${rack_id}  ""

  Set Global Variable  ${rack_id}


List Pods
  ${output}  List Pods
  Log  ${output}

  ${pod_id}  Get Pod Id By Name  ${POD_NAME}  ${output}
  Log  ${pod_id}
  Should Not Be Equal  ${pod_id}  ""
  ${location}  Get Pod Location  ${pod_id}
  Log  ${location}

  Set Global Variable  ${pod_id}
  Set Global Variable  ${location}


Create Array
  ${array_id}    Evaluate    str(uuid.uuid4())    modules=uuid
  ${acs}  Get Array Acs   ${CLUSTER_USER}  ${CLUSTER_PASS}  ${STORAGE_REST_HOST}  ${STORAGE_ID}  ${CDC_REST_URI}  ${ARRAY_TYPE}
  Create Array Yaml  ${PORTAL_ID}  ${hoster_id}  ${rack_id}  ${pod_id}  ${acs}  ${array_id}  ${STORAGE_ID}  ${ARRAY_YAML}
  Set Global Variable  ${array_id}
  ${result}  ${output}  Create Array  ${ARRAY_YAML}
  Should Be True  ${result}


Find Capacity Pool With Retry
  Wait Until Keyword Succeeds    5x    10 sec  Find Capacity Pool


Create Volume Flavor Basic
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=${EMPTY}  replication_type=${EMPTY}  label_value=${EMPTY}  ec_enable=${EMPTY}  container_allocation=${EMPTY}  ec_label=${EMPTY}
  Test Volume Flavor Cleanup

Create Volume Flavor Replication
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=${EMPTY}  ec_enable=${EMPTY}  container_allocation=${EMPTY}  ec_label=${EMPTY}
  Test Volume Flavor Cleanup


Create Volume Flavor HT Hdd 
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=hdd  ec_enable=${EMPTY}  container_allocation=${EMPTY}  ec_label=${EMPTY}
  Test Volume Flavor Cleanup


Create Volume Flavor HT CAF48
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=${EMPTY}  container_allocation=48
  Test Volume Flavor Cleanup


Create Volume Flavor HT EC
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=${EMPTY}  ec_enable=true
  Test Volume Flavor Cleanup


Create Volume Flavor HT Hdd EC Hdd
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=hdd  ec_enable=true  ec_label=hdd
  Test Volume Flavor Cleanup


Create Volume Flavor HT Hdd EC Hdd CAF24
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=hdd  ec_enable=true  container_allocation=24  ec_label=hdd  
  Test Volume Flavor Cleanup


Create Volume Flavor HT Hdd EC Hdd CAF48
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=hdd  ec_enable=true  container_allocation=48  ec_label=hdd   
  Test Volume Flavor Cleanup


Create Volume Flavor HT Hdd EC Nvme CAF48
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=hdd  ec_enable=true  container_allocation=48  ec_label=nvme
  Test Volume Flavor Cleanup


Create Volume Flavor HT Nvme
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=nvme
  Test Volume Flavor Cleanup


Create Volume Flavor HT Nvme CAF48
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=nvme  container_allocation=48
  Test Volume Flavor Cleanup


Create Volume Flavor HT Nvme EC
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=nvme  ec_enable=true
  Test Volume Flavor Cleanup


Create Volume Flavor HT Nvme EC Nvme
 Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=nvme  ec_enable=true  ec_label=nvme
 Test Volume Flavor Cleanup


Create Volume Flavor HT Nvme EC Nvme CAF24
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=nvme  ec_enable=true  container_allocation=24  ec_label=nvme 
  Test Volume Flavor Cleanup


Create Volume Flavor HT Nvme EC Nvme CAF48
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=nvme  ec_enable=true  container_allocation=48  ec_label=nvme  
  Test Volume Flavor Cleanup


Create Volume Flavor HT Nvme EC Hdd CAF48
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=high_throughput  label_value=nvme  ec_enable=true  container_allocation=48  ec_label=hdd  
  Test Volume Flavor Cleanup


Create Volume Flavor LL 
 Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=${EMPTY}
 Test Volume Flavor Cleanup


Create Volume Flavor LL Hdd
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=hdd
  Test Volume Flavor Cleanup


Create Volume Flavor LL Hdd CAF48
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=hdd  container_allocation=48
  Test Volume Flavor Cleanup


Create Volume Flavor LL Hdd EC
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=hdd  ec_enable=true
  Test Volume Flavor Cleanup


Create Volume Flavor LL Hdd EC Hdd
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=hdd  ec_enable=true  ec_label=hdd
  Test Volume Flavor Cleanup


Create Volume Flavor LL Hdd EC Hdd CAF24
  Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=hdd  ec_enable=true  container_allocation=24  ec_label=hdd  
  Test Volume Flavor Cleanup


Create Volume Flavor LL Hdd EC Hdd CAF48
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=hdd  ec_enable=true  container_allocation=48  ec_label=hdd   
   Test Volume Flavor Cleanup


Create Volume Flavor LL Hdd EC Nvme CAF48
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=hdd  ec_enable=true  container_allocation=48  ec_label=nvme
   Test Volume Flavor Cleanup


Create Volume Flavor LL Nvme
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=nvme
   Test Volume Flavor Cleanup


Create Volume Flavor LL Nvme CAF48
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=nvme  container_allocation=48
   Test Volume Flavor Cleanup


Create Volume Flavor LL Nvme EC
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=nvme  ec_enable=true
   Test Volume Flavor Cleanup


Create Volume Flavor LL Nvme EC Nvme
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=nvme  ec_enable=true  ec_label=nvme
   Test Volume Flavor Cleanup


Create Volume Flavor LL Nvme EC Nvme CAF24
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=nvme  ec_enable=true  container_allocation=24  ec_label=nvme 
   Test Volume Flavor Cleanup


Create Volume Flavor LL Nvme EC Nvme CAF48
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=nvme  ec_enable=true  container_allocation=48  ec_label=nvme  
   Test Volume Flavor Cleanup


Create Volume Flavor LL Nvme EC Hdd CAF48
   Test Volume Flavor  hoster_id=${hoster_id}  latency_value=LatencyStandard  replication_factor=3  replication_type=low_latency  label_value=nvme  ec_enable=true  container_allocation=48  ec_label=hdd  
   Test Volume Flavor Cleanup


Delete Array
  ${result}  ${output}  Delete Array  ${array_id}
  Should Be True  ${result}


*** Keywords ****
Check Directory
  [Arguments]  ${path}
  Directory Should Exist    ${path}


Find Capacity Pool
  ${output}  List Capacity Pools
  ${pool_id}  Find Capacity Pool For Array  ${STORAGE_ID}  ${output}
  Should Not Be Empty  ${pool_id}
  Log  ${pool_id}


Get User Ticket For Attachment
  [Arguments]  ${volume_attachment_id}=

  ${ticket}  Get User Ticket  ${volume_attachment_id}
  Should Not Be Empty  ${ticket}


Delete Volume Flavor From System
  [Arguments]  ${flavor_id}=

  ${result}  ${output}  Delete Volume Flavor  ${flavor_id}
  Should Be True  ${result}


Delete Volume From System
  [Arguments]  ${volume_id}=

  ${result}  ${output}  Delete Volume  ${volume_id}
  Should Be True  ${result}


Test Volume Flavor
  [Arguments]  ${hoster_id}=  ${latency_value}=  ${replication_factor}=  ${replication_type}=  ${label_value}=  ${ec_enable}=  ${container_allocation}=  ${ec_label}=


  # Create Volume Flavor
  ${flavor_id}=    Evaluate    str(uuid.uuid4())    modules=uuid
  ${name}  Generate Random String  8  [NUMBERS]
  Create Volume Flavor Yaml Attributes  ${PORTAL_ID}  ${hoster_id}  ${flavor_id}  ${name}  ${latency_value}  ${replication_factor}  ${replication_type}  ${label_value}  ${ec_enable}  ${container_allocation}  ${ec_label}  ${FLAVOR_YAML}
  Set Global Variable  ${flavor_id}
  ${result}  ${output}  Create Volume Flavor  ${FLAVOR_YAML}
  Should Be True  ${result}

  # List Volume Flavors
  ${output}  List Volume Flavors
  Log  ${output}

  # Create Volume
  ${volume_id}=    Evaluate    str(uuid.uuid4())    modules=uuid
  ${name}  Generate Random String  8  [NUMBERS]
  Create Volume Yaml  ${volume_id}  ${name}  ${flavor_id}  ${pod_id}  ${location}  1  ${VOLUME_YAML}
  Set Global Variable  ${volume_id}
  ${result}  ${output}  Create Volume  ${VOLUME_YAML}
  Should Be True  ${result}

  # Check Volume Status
  Wait Until Keyword Succeeds    20x    10 sec  Check Volume Status From System  volume_id=${volume_id}

  #Create Volume Attachment
  ${volume_attachment_id}=    Evaluate    str(uuid.uuid4())    modules=uuid
  ${name}  Generate Random String  8  [NUMBERS]
  Create Volume Attachment Yaml  ${portal_id}  ${hoster_id}  ${volume_attachment_id}  ${name}  ${volume_id}  ${VOLUME_ATTACHMENT_YAML}
  Set Global Variable  ${volume_attachment_id}
  ${result}  ${output}  Create Volume Attachment  ${VOLUME_ATTACHMENT_YAML}
  Should Be True  ${result}

  #Verify User Ticket With Retry
  Wait Until Keyword Succeeds    20x    10 sec  Get User Ticket For Attachment  volume_attachment_id=${volume_attachment_id}

Test Volume Flavor Cleanup
  #Delete Volume Attachment
  ${result}  ${output}  Delete Volume Attachment  ${volume_attachment_id}
  Should Be True  ${result}

  # Delete Volume With Retry
  Wait Until Keyword Succeeds    20x    10 sec  Delete Volume From System  volume_id=${volume_id}

  # Delete Volume Flavor With Retry
  Wait Until Keyword Succeeds    5x    10 sec  Delete Volume Flavor From System  flavor_id=${flavor_id}

 Check Volume Status From System
  [Arguments]  ${volume_id}=

  ${result}  ${output}  Check Volume Status  ${volume_id}
  Should Be True  ${result}

