A scaled up HL Fabric network with 3 nodes of Raft orderer spanning 2 organizations and 2 peers per organization. 
Also demonstrates how TLS can be enabled and actual domain names (instead of internal Kubernetes service names) can be used.

Transparent load balancing is not posssible because of TLS as of Fabric 1.4.1.
https://jira.hyperledger.org/browse/FAB-15648
