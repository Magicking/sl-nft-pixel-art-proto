# NFT Baby Face NFT

This NFT art project aim to elevate the computation on reading chain call #ONCHAINGANG

## Attributes

      UI Editor                   UI Editor
    .#############              #############
    .#           #              #   _/ \_   #
    .#    ###    #    canvas    #    ###    #
    .#   #   #   #  /        \  #   #   #   #
    .#  # x x #  # /          \ #  # x x #  #
    .#  #  _ >=8 # Attribute    #  #  _  #  # Attribute    
    .#   #   #   # popularity   #   #   #   # popularity 
    .#    ###    # [ 42 ] [PAY] #    ###    # [ 100 ] [PAY] 
    .#           #  6 copies    #           # 100 copies    
    .#############              #############
     scissor attribute          hat attribute

Attribute definition:
 - Name
 - Royalties (0x42 / 10%)
 - Graphic:
   - X (relative to pos ref)
   - Y (relative to pos ref)
   - PosRef (Eye{R;L} / Ear{R;L} / ...)
   - Compressed (DEFLATE) bitmap 

Attribute price x Popularity share

    ################
    # 100-------+  #
    #  .       /|  #
    #  .      / |  #
    #  .     /  |  #
    # 42----+   |  #
    #  .   /|   |  #
    #  .  / |   |  #
    #  . /  |   |  #
    #  1/   |   |  #
    #  #1...6...10 #
    ################

Note: The popularity is a function of the number of copies sold, the maximum number of copies in the market and the number of copies wanted by the artist(user of the pixel art editor).

## Minting

The mint operation combines multiple attributes and creates a new BabyFace NFT

    #############
    #   _/ \_   #
    #    ###    #
    #   #   #   #
    #  # x o #  #
    #  #  _ >=8 #
    #   #   #   #
    #    ###    #
    #    (x,y,z)#
    #############
      scissor+hat
      attributes
          w/
     x.o base background

Mint:
 - Random background face selected or depending the season (start, halloween, etc)
   - Base background with baby face
 - Choose attributes (or randomly using popularities share and seasonality)
 - Fees
   - Royalties are reversed to attributes creator when minted
   - More dee added to the reserve

Fees on:
 - Mint
 - Transfer
 - Attribute creation

Reserve:
  - use to exchange popularities versus native currency

## Tokenomic 

Attributes have a time to live (TTL) as season item making them cheap 

### Variables

 - Minted NFT value shall increase value over time depending on the popularites of the attributes still in the wild (e.g no attributes available means that value does not increase anymore)
 - Transfered NFT shall see their value decrease significantly so that you don't transfer too much for the season time
 - Attribute creation fee payment
 - Royalties payment distribution

## Display
 - Render on-chain (BMP/GIF/PNG/SVG)
    - Render a fancy format for fun

## Unlockable content
 - Use Stable Diffusion and the resultant PixelArt to generate a glorified version using external service

# Roadmap

1. Prototype - on chain generation using different bitmaps
2. Add tokenomics on top, make the royalties fall to attribute creators
3. Add the possibility for anyone to create attributes via UI

# Tech cheat sheet

Show image using forge test: 
 forge test -vv | grep -A1 Logs | grep -o base64,".*" | sed 's:base64,::' | base64 -d | jq -r .image | sed 's#data:image/png;base64,##' | base64 -d > img.png && feh ./img.png

## Installation

To install with [DappTools](https://github.com/dapphub/dapptools):

```
dapp install [user]/[repo]
```

To install with [Foundry](https://github.com/gakonst/foundry):

```
forge install [user]/[repo]
```

## Local development

This project uses [Foundry](https://github.com/gakonst/foundry) as the development framework.

### Dependencies

```
make update
```

### Compilation

```
make build
```

### Testing

```
make test
```
