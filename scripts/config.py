from brownie import config, accounts, network, chain, web3
# addr 0x833514593c7798551A20Ac69f98D486e2A12dFe8
private_key = config["wallets"]["from_key"]
wallet: network.account.LocalAccount = accounts.add(private_key)

# default: {"from": wallet, "gas_limit": 1000000, "priority_fee": "1 gwei"}
if network.chain.id == 1337:
    accounts[0].transfer(wallet, "10 ether")
else:
    network.priority_fee("3 gwei")
accounts.default = wallet
network.gas_limit(1000000)
