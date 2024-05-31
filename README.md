### Setup

- Install scarb latest version:

```
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
```
- create an account on [Voyager](https://voyager.online/)
- generate API key
- add a `snfoundry.toml` file at the root of the repo
- fill it like this:

```toml
[sncast.default]
url = "https://rpc.nethermind.io/sepolia-juno/?apikey=API_KEY"
```

- install `sncast`:

```
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
```

```
snfoundryup
```

- Make sure you have the latest version of the `Universal-Sierra-Compiler`:

```
curl -L https://raw.githubusercontent.com/software-mansion/universal-sierra-compiler/master/scripts/install.sh | sh
```

- create an `sncast account`:

```
sncast account create --name main
```

- Fund your account on this [Faucet](https://starknet-faucet.vercel.app/)
- Deploy it:

```
sncast account deploy --name main
```
