const shim = require('fabric-shim');
const Chaincode = require('./even-simpler');

shim.start(new Chaincode());
