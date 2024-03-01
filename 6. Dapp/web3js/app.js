const Web3 = require('web3')
const rpcURL = "https://goerli.infura.io/v3/8d0ffe371ace4887906f3480f23bdcf3"
const web3 = new Web3(rpcURL)
 
web3.eth.getBalance("0x4b984D560387C22f399B76a38edabFE52903E599", (err, wei) => { 
   balance = web3.utils.fromWei(wei, 'ether'); // convertir la valeur en ether
   console.log(balance);
});
