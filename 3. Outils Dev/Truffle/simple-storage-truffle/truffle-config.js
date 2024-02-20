const path = require("path");
module.exports = {
 // See
     
 // to customize your Truffle configuration!
 contracts_build_directory: path.join(__dirname, "client/src/contracts"),
 networks: {
 develop: {
 host: "localhost",
 port: 8545,
 network_id: "*"
  }
 }
};